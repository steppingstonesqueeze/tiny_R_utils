# function composition with arbitrary number of functions as args

compose <- function(...) {
  funcs <- list(...)
  function(x) {
    # apply functions from right to left
    result <- x
    for (f in rev(funcs)) {
      result <- f(result)
    }
    result
  }
}

square <- function(x) x^2
double <- function(x) 2*x
inc    <- function(x) x + 1

# Compose multiple
f <- compose(square, double, inc)  
# means: square(double(inc(x)))

f(3)   # square(double(4)) = square(8) = 64

# Using Reduce to make this efficient and essenntially one-line

compose_v2 <- function(...) {
  funcs <- list(...)
  function(x) {
    Reduce(function(acc, f) f(acc), rev(funcs), init = x)
  }
}

f <- compose_v2(square, double, inc)
f(3)