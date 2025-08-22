# generate dataframe of multidimensional random numbers from any PRNG 

generate_uniform_nums <- function(...) {
  
  DEFAULTS <- list(dims = 3,
                   min_val = 0.0,
                   max_val = 1.0,
                   N = 1000)
  
  args <- list(...)
  
  n_args <- names(args)
  
  if (length(n_args) == 0) {
    # specify default args
    dims <- DEFAULTS$dims
    min_val <- DEFAULTS$min_val
    max_val <-DEFAULTS$max_val
    N <- DEFAULTS$N
    
  } else {
    
    # check which params are specified and accordingly set rest to defaults only
    if ("dims" %in% n_args) {
      dims <- args$dims
    } else {
      dims <- DEFAULTS$dims
    }
    
    if ("min_val" %in% n_args) {
      min_val <- args$min_val
    } else {
      min_val <- DEFAULTS$min_val
    }
    
    if ("max_val" %in% n_args) {
      max_val <- args$max_val
    } else {
      max_val <- DEFAULTS$max_val
    }
    
    if ("N" %in% n_args) {
      N <- args$N
    } else {
      N <- DEFAULTS$N
    }
    
  } # if-else of params done
  
  df <- data.frame(runif(N, min = min_val, max = max_val))
  
  for (j in 2:dims) {
    df2 <- data.frame(runif(N, min = min_val, max = max_val))
    df <- bind_cols(df, df2)
  }
  
  colnames(df) <- NULL # not needed for what follows
  return(df)
}


# USAGE
d <- generate_uniform_nums() # default settings
d <- generate_uniform_nums(N = 10000) # 10000 points for each dim
d <- generate_uniform_nums(dims = 10) # 1000 points in 10D
