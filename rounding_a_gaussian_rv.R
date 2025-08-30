## Take Gaussian rvs and round them ; what is the resultant histo look like?
# How much of a deviation from a Gaussian is it?

library(ggplot2)
library(randomForest)
library(xgboost)

N <- 100000

mean <- 10
sd <- 5

data <- rnorm(N, mean, sd)

rounded_data <- round(data)

df <- data.frame(
  data = c(data, rounded_data)
)

df$type <- c(rep("orig", N), rep("rounded", N))

# plot both histos together now

ggplot(df, aes(x = data, fill = type)) + 
  geom_histogram(binwidth=.5, alpha=.5, position="identity")

# for the rounded data - let us count up by occurence of a number

count_num_occ <- aggregate(
  rep(1, N),
  by = list(df$data[(N+1):nrow(df)]),
  FUN = sum
)

colnames(count_num_occ) <- c("rounded_data", "num_occ")

ggplot(data = count_num_occ, aes(x = rounded_data, y = num_occ)) + 
  geom_point(colour = "blue")

# what do extreme values look like?

# consider values that are at mean +/- 3*sigma and les or above that

df_extreme <- subset(df, data <= mean - 3*sd | data >= mean + 3*sd)

# plot for completeness

ggplot(df_extreme, aes(x = data, fill = type)) +  geom_histogram(binwidth=.5, alpha=.5, position="identity")

# cool - now to motivate something from streaming algos

# take the count data and compute F_2 = sum(square of occurences)
# then compute F_1 = sum(occurences)
# then compute the occurence variance

f_1 <- sum(count_num_occ$num_occ)
f_2 <- sum(count_num_occ$num_occ * count_num_occ$num_occ)

occurence_variance <- f_2 / N - (f_1 / N) * (f_1/N) # 


