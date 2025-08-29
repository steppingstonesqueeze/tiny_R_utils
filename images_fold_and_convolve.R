library(imager)

fold_and_convolve <- function(img, direction = "vertical") {
  # Grayscale it if needed
  if (spectrum(img) != 1) {
    img <- grayscale(img)
  }
  
  # Get dimensions
  w <- dim(img)[1]
  h <- dim(img)[2]
  
  if (direction == "vertical") {
    mid <- floor(w / 2)
    left  <- imsub(img, x <= mid)
    right <- imsub(img, x > mid)
  } else if (direction == "horizontal") {
    mid <- floor(h / 2)
    top    <- imsub(img, y <= mid)
    bottom <- imsub(img, y > mid)
    left <- top
    right <- bottom
  } else {
    stop("Direction must be 'vertical' or 'horizontal'")
  }
  
  # Normalize halves
  left <- left / max(left)
  right <- right / max(right)
  
  # Convolve left with right
  result <- correlate(left, right)
  
  return(result)
}


orig_image <- "/Users/gn/work/projects/lethal_R/tiny_R_utils/boris-becker-playing-at-wimbledon-lawn-tennis-club-when-he-was-16-A9MMC9.jpg"

img <- load.image(orig_image)
plot(img)

Sys.sleep(5)

# fold ansd convolve

folded_img <- fold_and_convolve(img, direction = "vertical")
plot(folded_img, main = "Left ⊛ Right (Convolution of Halves)")




