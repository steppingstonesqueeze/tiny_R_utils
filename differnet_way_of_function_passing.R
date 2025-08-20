# When function take in arbitrary number of arguments, this documents a multitude of ways of passing in the function

`%f%` <- funtion(a,b) {
	return(a - 2*b)
}

5 %f% 1 #3

# way 1 of passing in the infix function 
new_f <- function(operation = `%f%`, ...) {
	  args <- list(...)
  if (length(args) < 2) stop("Need at least two args")
    operation(args[[1]], args[[2]])
}

#Example
new_f(`%f%`, 3, 5)

new_f_2 <- function(operation = "%f%", ...) {
	args <- unlist(list(...))
	if (length(args) < 2) stop("Need at least two args")
	operation(args[1], args[2])
}

new_f_2 <- function("%f%", 3, 5)

###


