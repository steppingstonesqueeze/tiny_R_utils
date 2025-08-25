# List flatteners when arbitrary. number of mixed arguments are used

my_new_func <- function(...) {
  args <- list(...) 
  print(args)
}

# Now lets print out stuff

# Example 1
mm1 <- my_new_func(list(a=1, b=-1), list(c=0, d=0.5)) # flattener
mm2 <- my_new_func(list(a=1, b=-1), x = seq_len(3), l1 = list(c=0, d=0.5), y = "abc")

# For mm1
mm1[[1]]
mm1[[2]]

mm[[1]]$a

# For mm2
mm2$x
mm2$y
mm2$l1

mm2$l1$c