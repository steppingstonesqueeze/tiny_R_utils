# Creating infix functions and using it in function with arbitrary numbers od arguments

# Addition
`%plus%` <- function(a,b) {
	  return (a+b)
}

#Example
4 %plus% 5

#Subtraction
`%minus%` <- function(a,b) {
	  return (a-b)
}

#Example
4 %minus% 5

#multiplication
`%mult%` <- function(a,b) {
	  return (a*b)
}

#Division
`%div%` <- function(a,b) {
	  return(ifelse(b != 0, a/b, NA))
}

# A few examples
15 %mult% 5

15 %div% 5

15 %div% 0 #Example to show NAs from div

15 %mult% -8

15 %div% -4

# Using the infix functions in a function with arbitrary number of arguments #
cumulative_ops <- function(operation = `%plus%`, ...) {
	  args <- list(...)
  data <- unlist(args)
    
    len_data <- length(data)
    
    stopifnot(len_data >= 2)
      
      value <- data[1]
      for (i in seq(2, len_data, by = 1)) {
	          value <- operation(value, data[i])
        }
        
        return(value)
}


# Tests
cumulative_ops(`%plus%`, 1,2,3,4)

cumulative_ops(`%mult%`, 1,2,3,4,5)

cumulative_ops(`%div%`, 1,2,3)

cumulative_ops(`%plus%`, 1)

