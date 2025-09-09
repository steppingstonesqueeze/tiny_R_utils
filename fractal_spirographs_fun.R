# ============================================================
# Fractal Spirographs — 1080p animated movie with av + ffmpeg
# Requires: av, ggplot2, dplyr, purrr, tibble
# ============================================================

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(purrr)
  library(tibble)
  library(av)
})


# ---------------- PARAMETERS (edit these!) ----------------
set.seed(7)

# Movie settings
fps        <- 30            # frames per second
seconds    <- 20            # duration
n_frames   <- fps * seconds # total frames
width      <- 1080          # px
height     <- 1080          # px
outfile    <- "fractal_spirograph.mp4"

# Spirograph base curve settings
# We'll draw ONE hypotrochoid base curve and make fractal-y layers
R_base <- 12L   # fixed circle radius (integer)
r_base <- 5L    # rolling circle radius (integer)
d_base <- 7.0   # pen offset

# Curve sampling resolution
n_points <- 6000  # points along the base curve

# Fractal layering
n_layers   <- 9           # number of layers
scale_step <- 0.74        # geometric scale between layers
rot_step   <- pi/7        # fixed rotation between layers (radians)

# Animation dynamics
#  - curve reveals progressively
#  - global rotation over time (gentle), plus a tiny “wobble” in d for shimmer
global_spin_rate <- 2*pi * 0.15   # radians per second
d_wobble_amp     <- 0.20          # amplitude for pen offset wobble
d_wobble_freq    <- 1.2           # Hz

# Styling
bg_col   <- "#0c0c14"
line_col <- function(k, tfrac) { # k: layer index (0-based), tfrac in [0,1]
  # pleasant rotating hue; alpha ramps in subtly with time
  h <- (k * 33 + 260 * tfrac) %% 360
  a <- 0.65 + 0.25 * sin(2*pi*tfrac + k*0.5)
  # hcl returns hex w/o alpha; use rgb w/ hsv for alpha
  cols <- grDevices::hsv(h/360, s=0.55, v=0.95, alpha = max(0.05, min(1, a)))
  cols
}
line_width <- 0.8

# ----------------------------------------------------------
# Geometry helpers
# ----------------------------------------------------------
gcd_int <- function(a, b) { if (b == 0L) abs(a) else Recall(b, a %% b) }

# Hypotrochoid parametric curve (R, r, d must be > 0)
# The curve closes when theta spans 2*pi * (R/g), where g = gcd(R, r)
hypotrochoid <- function(R, r, d, n) {
  g <- gcd_int(R, r)
  period <- 2*pi * (R / g)  # full closure
  theta <- seq(0, period, length.out = n)
  # equations
  k <- (R - r) / r
  x <- (R - r) * cos(theta) + d * cos(k * theta)
  y <- (R - r) * sin(theta) - d * sin(k * theta)
  tibble(theta = theta, x = x, y = y)
}

# 2D similarity transform (scale + rotation + translation)
transform_xy <- function(df, scale = 1, rot = 0, tx = 0, ty = 0) {
  cs <- cos(rot); sn <- sin(rot)
  x2 <- scale * (df$x * cs - df$y * sn) + tx
  y2 <- scale * (df$x * sn + df$y * cs) + ty
  mutate(df, x = x2, y = y2)
}

# Easing for the reveal (smooth-ish)
ease_in_out_cubic <- function(t) ifelse(t < 0.5, 4*t*t*t, 1 - (-2*t + 2)^3/2)

# ----------------------------------------------------------
# Build base curve (normalized to a nice canvas scale)
# ----------------------------------------------------------
base_curve <- hypotrochoid(R_base, r_base, d_base, n_points)

# Normalize to roughly fit [-1,1] for both x and y, then we'll scale to canvas
rng <- max(max(abs(base_curve$x)), max(abs(base_curve$y)))
base_curve <- mutate(base_curve, x = x / rng, y = y / rng)

# Precompute per-layer static transforms (fractal layout)
layer_params <- tibble(
  layer = 0:(n_layers - 1),
  scale = scale_step ^ (0:(n_layers - 1)),
  rot0  = rot_step * (0:(n_layers - 1)),      # base rotation between layers
  tx    = 0,  # centered
  ty    = 0
)

# ----------------------------------------------------------
# Frame rendering
# ----------------------------------------------------------
# Create a temp directory for frames
frames_dir <- "spiro_frames"
dir.create(frames_dir, recursive = TRUE, showWarnings = FALSE)

#frames_dir <- file.path(tempdir(), paste0("spiro_frames_", as.integer(Sys.time())))
#dir.create(frames_dir, recursive = TRUE, showWarnings = FALSE)

message("Rendering frames to: ", frames_dir)

# Canvas limits (square)
lim <- 1.25  # extra padding
xmin <- -lim; xmax <- lim; ymin <- -lim; ymax <- lim

# Per-frame render
for (f in seq_len(n_frames)) {
  tfrac <- (f - 1) / (n_frames - 1)              # goes 0 -> 1
  tsec  <- tfrac * seconds
  
  # Dynamic transforms
  global_rot <- global_spin_rate * tsec
  d_now <- d_base + d_wobble_amp * sin(2*pi*d_wobble_freq * tsec)
  
  # Optionally wobble the base curve slightly (by reusing its param but nudging d component)
  # Fast hack: shift the sub-harmonic term using a tiny extra rotation based on wobble
  wobble <- 0.06 * sin(2*pi*(d_wobble_freq/2) * tsec)
  wob_cs <- cos(wobble); wob_sn <- sin(wobble)
  wob_df <- base_curve
  wob_df <- wob_df %>% mutate(
    # emulate slight "pen offset change" by rotating the (x,y) a tiny amount
    x = x * wob_cs - y * wob_sn,
    y = x * wob_sn + y * wob_cs
  )
  
  # Reveal portion
  frac_draw <- ease_in_out_cubic(tfrac)
  n_draw <- max(2L, floor(n_points * frac_draw))
  
  # Compose all layers
  layers_df <- map_dfr(1:n_layers, function(i) {
    lp <- layer_params[i, ]
    col <- line_col(lp$layer, tfrac)
    
    # layer rotation includes base rot0 (fractal layout) + global spin
    rot <- lp$rot0 + global_rot
    
    # take prefix of curve to "draw-in" path; then transform
    df <- wob_df[seq_len(n_draw), c("x", "y")]
    df <- transform_xy(df, scale = lp$scale, rot = rot, tx = lp$tx, ty = lp$ty)
    
    df$layer <- lp$layer
    df$col   <- col
    df$idx   <- seq_len(nrow(df))
    df
  })
  
  p <- ggplot(layers_df, aes(x, y, group = layer)) +
    geom_path(aes(color = I(col)), linewidth = line_width, lineend = "round") +
    coord_equal(xlim = c(xmin, xmax), ylim = c(ymin, ymax), expand = FALSE) +
    theme_void(base_size = 14) +
    theme(
      plot.background = element_rect(fill = bg_col, color = bg_col),
      panel.background = element_rect(fill = bg_col, color = bg_col),
      plot.margin = margin(20, 20, 20, 20)
    )
  
  frame_path <- file.path(frames_dir, sprintf("frame_%05d.png", f))
  ggsave(frame_path, p, width = width/100, height = height/100, dpi = 100, limitsize = FALSE)
  if (f %% 60 == 0) message(sprintf("... %d / %d frames", f, n_frames))
}

message("Encoding video…")
# Encode to mp4 using av (ffmpeg)
#png_pattern <- file.path(frames_dir, "frame_%05d.png")

png_files <- list.files(frames_dir, pattern = "^frame_\\d+\\.png$", full.names = TRUE)
png_files <- png_files[order(nchar(png_files), png_files)]  # natural order

av::av_encode_video(
  png_files,
  framerate = fps,
  output = outfile,
  vfilter = "scale=1080:1080:flags=lanczos",
  codec = "libx264",
  verbose = TRUE
)

message("Done! Wrote: ", normalizePath(outfile))
message("Tip: For an even smoother look, try crf=16 and fps=60 (and double n_frames).")
