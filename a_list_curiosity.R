# A lit curiosity to be aware of 


my_list <- c(5,2,list(a=-1011,b=4))

# good
my_list[[1]]
my_list[[2]]

# good
my_list$a
my_list[[3]][1]

#meh
my_list$b # works perfectly !
my_list[[3]][2] # NA !<- not recognised