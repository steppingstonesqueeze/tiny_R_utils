# glocal counters via closures

counter <- function() {
  count <- 0
  function() {
    count <<- count + 1
    return(count)
  }
}

c1 <- counter()
c1()  # 1
c1()  # 2
c1()  # 3