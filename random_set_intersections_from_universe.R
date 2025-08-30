### Set intersection problem #

# Consider a universe of size N ; say ints from 1,2,..N

# Consider two sets of equal size m <= N ; what is the minimum size of their intersection 
# and what is the max size?

EPS <- 1.0e-10

library(ggplot2)
library(tidyverse)
library(magrittr)

# A more interesting and general question is : Given two sets of cardinality
# m <= n from a universe of size n, what is the expected intersection size?

N <- 200

set1_size <- seq(1, N, by = 1)

avg_int <- numeric(length = N)

df <- data.frame(
  set1_size=rep(0,N),
  avg_int=rep(0,N),
  normalized_set1_size = rep(0,N),
  normalized_avg_int = rep(0,N)
)

num_sim <- 1000 # 1000 different set pairs simulated for each set size

ctr <- 1


for (i in set1_size) {
  set1_card <- i
  set2_card <- i
  
  cat("Set size is ", i, "\n")
  
  avg_int[ctr] <- 0
  
  for (j in 1:num_sim) {
    s1 <- sample(N, set1_card, replace = F)
    s2 <- sample(N, set2_card, replace = F)
    int1 <- length(intersect(s1,s2))
    avg_int[ctr] <- avg_int[ctr] + int1
  }
  
  avg_int[ctr] <- avg_int[ctr] / num_sim
  
  ctr <- ctr + 1
}

df[,1] <- set1_size
df[,2] <- avg_int
df[,3] <- set1_size / N # normalized universe size if you like
df[,4] <- avg_int / set1_size # called the efficiency of intersection

ggplot(data = df) + geom_point(aes(x = normalized_set1_size, y = normalized_avg_int), colour = "red") 

# log plot of the normalized version

ggplot(data = df) + geom_point(aes(x = log(normalized_set1_size+EPS), y = log(normalized_avg_int+EPS)), colour = "green") 

# the unnornalized plot for completeness
ggplot(data = df) + geom_point(aes(x = set1_size, y = avg_int), colour = "blue") 

