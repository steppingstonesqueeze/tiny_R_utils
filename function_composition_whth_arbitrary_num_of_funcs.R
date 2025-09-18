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

# pipe operators in the magrittr / dplyr style - left to right func applications 

pipe_v1 <- function(...) {
  funcs <- list(...)
  function(x) {
    Reduce(function(acc, f) f(acc), funcs, init = x)
  }
}

g <- pipe_v1(inc, double, square)  # ((x + 1) * 2)^2
g(3)  # 64

# finally -- checking that all arguments passed are actually functions so that the composition is safe

compose_safe <- function(...) {
  funcs <- list(...)
  stopifnot(all(vapply(funcs, is.function, logical(1))))
  function(x) Reduce(function(acc, f) f(acc), rev(funcs), init = x)
}

g1 <- compose_safe(square, double, inc)
g1(3)

# unsafe
g1 <- compose_safe(square, 44, inc)
g1(3)






