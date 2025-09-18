# paramterised function factories -- some syntactic sugar

power_factory <- function(n) {
  function(x) x^n
}

square <- power_factory(2)
cube   <- power_factory(3)

square(4)  # 16
cube(4)    # 64