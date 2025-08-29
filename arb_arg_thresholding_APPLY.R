#Applying functions with an arbitrary number of args in the "apply" setting


thresholding <- function(...) {
  args <- list(...)
  DEFAULT_THRESHOLD <- 1
  
  if (!is.null(args$thresh)) {
    thresh <- args$thresh
    args$thresh <- NULL
  } else {
    thresh <- DEFAULT_THRESHOLD
  }
  
  values <- unlist(args)  # only unnamed args left
  
  out <- ifelse(values < thresh, 1, 0)
  return(out)
}

thresholding(1,2,3,4,5, thresh = 3)

# apply this to a matrix

m <- matrix(sample(50, 50, replace = TRUE),
            nrow = 10)

m

apply(m, 1, thresholding, thresh = 15)

