# from table to ordered top K
t <- table(c(5,12,13,12,8,5))

t

top_K_ordered <- function(table_name, increasing = TRUE, k = 2) {
  dt <- as.data.frame(table_name)
  nrow_dt <- nrow(dt)
  
  if (k > nrow_dt) {
    k <- nrow_dt
  }
  
  dec <- !increasing
  freq_rev <- order(dt$Freq, decreasing = dec)
  dt_rev_ordered <- dt[freq_rev, ][1:k, ]
  dt_rev_ordered
}

top_K_ordered(t, increasing = FALSE)