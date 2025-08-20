# generally useful to find memoery addresses of objects
# particularly useful for copy semantics

library(lobstr)

x <- 1:3
obj_addr(x)
# [1] "0x55b8c4d5d0"

y <- x
obj_addr(y)   # same as x (since no copy yet)

y[1] <- 99
obj_addr(y)   # different now
obj_addr(x)   # original unchanged

# lists
l1 <- list(a = 1, name = "Boo", age = 47, occupation = "Writer")

len_l1 <- length(l1)

for (i in seq(len_l1)) {
	print(obj_addr(l1[[i]]))
}
