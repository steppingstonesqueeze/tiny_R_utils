# t-tests asnd the effect of a simple bootstrap 


attach(sleep)

# split out groups for the test -- not needed but whatever
extra.1=extra[group==1]
extra.2=extra[group==2]


t.test(extra.1, extra.2, paired=TRUE, alternative="two.sided")

# approximately normal so that assumption is not completely violated #
diffs = extra.1-extra.2
qqnorm(diffs, main= "Normal Probability Plot")
qqline(diffs)


sleep

subset(sleep, group == 1)

### Bootstrapped sleep dataset with a tiny amount of noise for making a larger dataset
# Note : need to bootstrap sample each group separately, generate NEW IDs and have those new
# IDs match similar ones in the bootstrapped sample of 2nd group!
sleep_2 <- sleep

tot_samples <- 1000 #990 new patients supposedly

# paired samples - so sample by ID and include both groups at once!

#sample_data <- as.numeric(unique(sleep$ID))
#sample_data

current_patients <- length(unique(sleep$ID))
current_patients

ctr <- 11

for (ctr in 11:tot_samples) {
  # sample an ID
  id <- sample(current_patients, 1)
  
  new_pat <- subset(sleep_2, ID == id)
  #new_pat$
  #print(new_pat)
  #cat("ID\n")
  new_pat$ID <- ctr
  
  #cat(new_pat$ID, "\n")
  #print(new_pat)
  
  new_pat$ID <- as.factor(new_pat$ID)
  # rbind
  sleep_2 <- rbind(sleep_2, new_pat)
}

#sleep

#v t test on a bootstrapped pop now

sleep_2_1 <- subset(sleep_2, group == 1)
sleep_2_2 <- subset(sleep_2, group == 2)

t.test(sleep_2_1$extra, sleep_2_2$extra, paired=TRUE, alternative="two.sided")
