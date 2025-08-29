# Images and some simple manipulations

library(imager)

img <- load.image("/Users/gn/work/projects/lethal_R/tiny_R_utils/boris-becker-playing-at-wimbledon-lawn-tennis-club-when-he-was-16-A9MMC9.jpg")  # returns cimg object
dim(img)
# [x, y, color channel, frame]

# Example: increase red channel intensity
img[,,1,] <- img[,,1,] * 0.09  # red channel

# Clamp to [0,1]
img <- pmin(pmax(img, 0), 1)

# Display
plot(img)

# convolution

img_gray <- grayscale(img)

# blur filter 
kernel <- matrix(1/9, nrow = 3, ncol = 3)

# edge detection Sobel filter


sobel_x <- matrix(c(-1,0,1,
                    -2,0,2,
                    -1,0,1), nrow=3, byrow=TRUE)

# blurred image
kernel <- as.cimg(matrix(1/9, nrow = 3, ncol = 3))

img_filtered <- correlate(img_gray, kernel)  # zero-padding
plot(img_filtered)

# Sdobelize

# Does lovely edge detection

sobel_x <- as.cimg(sobel_x)

img_sobelised <- correlate(img_gray,
                           sobel_x)

plot(img_sobelised)

# Do Sobel on original

img_orig_sobelised <- correlate(img,
                                sobel_x)

plot(img_orig_sobelised)




