suppressPackageStartupMessages({
  library(ggplot2); library(dplyr); library(purrr); library(tibble); library(av)
})

## -------- Parameters --------
set.seed(7)
R_base <- 12L; r_base <- 5L; d_base <- 7.0
n_points   <- 900

max_depth  <- 4        # recursion depth
branch_k   <- 3        # children per node
child_scale<- 0.55     # <1 ensures contraction
child_rot  <- pi/7

seconds <- 16; fps <- 30; n_frames <- seconds * fps
width <- 1080; height <- 1080
bg_col <- "#090a12"; line_w <- 0.7
frames_dir <- "spiro_frames"; outfile <- "fractal_spirograph_fractal.mp4"

## -------- Geometry --------
gcd_int <- function(a,b){ if(b==0L) abs(a) else Recall(b, a %% b) }
hypotrochoid <- function(R,r,d,n){
  g <- gcd_int(R,r); period <- 2*pi*(R/g); th <- seq(0, period, length.out=n)
  k <- (R - r)/r
  tibble(theta=th,
         x=(R - r)*cos(th) + d*cos(k*th),
         y=(R - r)*sin(th) - d*sin(k*th))
}
transform_xy <- function(df, scale=1, rot=0, tx=0, ty=0){
  cs <- cos(rot); sn <- sin(rot)
  tibble(x = scale*(df$x*cs - df$y*sn) + tx,
         y = scale*(df$x*sn + df$y*cs) + ty)
}
ease_in_out_cubic <- function(t) ifelse(t<0.5, 4*t*t*t, 1 - (-2*t+2)^3/2)

## -------- Base curve (normalized) --------
base_curve <- hypotrochoid(R_base, r_base, d_base, n_points)
rng <- max(max(abs(base_curve$x)), max(abs(base_curve$y)))
base_curve <- mutate(base_curve, x = x/rng, y = y/rng)

## -------- IFS tree construction (FIXED) --------
# Place K children at evenly spaced *indices* along the parent's base curve.
make_children <- function(parent, level){
  if (level >= max_depth) return(list())
  idxs <- round(seq(1, n_points, length.out = branch_k + 2))[-c(1, branch_k+2)]
  places <- base_curve[idxs, c("x","y")]  # rows of (x,y)
  
  map(seq_along(idxs), function(j){
    row <- places[j, ]
    list(
      id    = paste0(parent$id, ".", j),
      level = level + 1,
      scale = parent$scale * child_scale,
      rot   = parent$rot + child_rot + (j-1) * (2*pi/branch_k),
      tx    = parent$tx + row$x * parent$scale,
      ty    = parent$ty + row$y * parent$scale
    )
  })
}

# Build nodes breadth-first
root <- list(id="0", level=0, scale=1, rot=0, tx=0, ty=0)
nodes <- list(root); i <- 1
while (i <= length(nodes)) {
  nd <- nodes[[i]]
  if (nd$level < max_depth) nodes <- c(nodes, make_children(nd, nd$level))
  i <- i + 1
}

## -------- Render frames --------
if (!dir.exists(frames_dir)) dir.create(frames_dir, recursive=TRUE, showWarnings=FALSE)
lim <- 1.35; xmin <- -lim; xmax <- lim; ymin <- -lim; ymax <- lim
level_cols <- function(levels, tfrac) grDevices::hsv(((levels*37 + 220*tfrac) %% 360)/360,
                                                     s=0.55, v=0.98, alpha=0.85)

for (f in seq_len(n_frames)) {
  tfrac <- (f - 1) / (n_frames - 1)
  depth_float <- max_depth * tfrac
  depth_full  <- floor(depth_float)
  frontier_frac <- ease_in_out_cubic(depth_float - depth_full)
  
  # Fully drawn nodes up to depth_full
  draw_nodes <- nodes[sapply(nodes, `[[`, "level") <= depth_full]
  full_df <- map_dfr(draw_nodes, function(nd){
    df <- transform_xy(base_curve, scale=nd$scale, rot=nd$rot, tx=nd$tx, ty=nd$ty)
    mutate(df, level=nd$level, id=nd$id, idx=row_number())
  })
  
  # Partially drawn frontier (next depth)
  frontier_df <- tibble()
  if (depth_full < max_depth) {
    frontier_nodes <- nodes[sapply(nodes, `[[`, "level") == (depth_full + 1)]
    frontier_df <- map_dfr(frontier_nodes, function(nd){
      n_draw <- max(2L, floor(n_points * frontier_frac))
      df <- transform_xy(base_curve[seq_len(n_draw),], scale=nd$scale, rot=nd$rot, tx=nd$tx, ty=nd$ty)
      mutate(df, level=nd$level, id=nd$id, idx=row_number())
    })
  }
  
  layers_df <- bind_rows(full_df, frontier_df)
  if (nrow(layers_df) == 0) next
  
  layers_df$col <- level_cols(layers_df$level, tfrac)
  
  p <- ggplot(layers_df, aes(x, y, group=id)) +
    geom_path(aes(color=col), linewidth=line_w, lineend="round", show.legend=FALSE) +
    scale_color_identity() +
    coord_equal(xlim=c(xmin,xmax), ylim=c(ymin,ymax), expand=FALSE) +
    theme_void(base_size=14) +
    theme(plot.background = element_rect(fill=bg_col, color=bg_col),
          panel.background = element_rect(fill=bg_col, color=bg_col),
          plot.margin = margin(20,20,20,20))
  
  frame_path <- file.path(frames_dir, sprintf("frame_%05d.png", f))
  ggsave(frame_path, p, width=width/100, height=height/100, dpi=100, limitsize=FALSE)
  if (f %% 60 == 0) message(sprintf("... %d / %d frames", f, n_frames))
}

## -------- Encode video (explicit file list) --------
png_files <- list.files(frames_dir, pattern="^frame_\\d+\\.png$", full.names=TRUE)
png_files <- png_files[order(nchar(png_files), png_files)]
stopifnot(length(png_files) > 0)

av::av_encode_video(
  input     = png_files,
  framerate = fps,
  output    = outfile,
  vfilter   = "scale=1080:1080:flags=lanczos",
  codec     = "libx264",
  verbose   = TRUE
)

cat("Done! Wrote:", normalizePath(outfile), "\n")
# unlink(frames_dir, recursive=TRUE)  # <- uncomment to clean up

