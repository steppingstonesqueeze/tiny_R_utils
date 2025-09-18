# simple effective function composition

compose <- function(f, g) function(x) f(g(x))

quare <- function(x) x^2
double <- function(x) 2 * x

sq_after_double <- compose(square, double)
sq_after_double(3)   # (2*3)^2 = 36

double_after_sq <- compose(double, square)
double_after_sq(3)   # 2 * (3^2) = 18

inc <- function(x) x + 1
triple <- function(x) 3 * x

f <- compose(triple, compose(inc, square))
f(4)   # triple(inc(square(4))) = 3*(16+1) = 51