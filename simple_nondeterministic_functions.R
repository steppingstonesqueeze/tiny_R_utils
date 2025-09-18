# simple nondeterministic functions

random_multiplier <- function() {
  k <- runif(1, 0, 10)
  function(x) k * x
}

f1 <- random_multiplier()
f2 <- random_multiplier()
f1(5); f2(5)  # Different answers!