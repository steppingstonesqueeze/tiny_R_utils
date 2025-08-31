### Curse of dimensionality simple illustration ###

# Hypercube of unit volume

# p : fraction of points / volume needed in each bin for neighborhood !
require(tidyverse)
require(ggplot2)

seq_p <- seq(0.01, 0.15, by = 0.01)

seq_d <- seq(1, 100, by = 1)

len_p <- length(seq_p)
len_d <- length(seq_d)

num_data <- len_p * len_d

data <- tibble(
  p = rep(NA, num_data),
  d = rep(NA, num_data),
  rs = rep(NA, num_data)
)

ctr <- 1

for (p in seq_p) {
  
  for (d in seq_d) {
    relevant_side <- p ** (1./d)
    data[ctr,1] <- p
    data[ctr,2] <- d
    data[ctr,3] <- relevant_side
    ctr <- ctr + 1
  }
}

data %>%
  ggplot(aes(x = d, y = rs, colour = factor(p))) + geom_line()


