#source("R/people_like_you-data_processing.R")

# Calculate absolute difference between desires and expectations ----------
calculateUserExpectations <- function(x){
  x$total_expectations <- rep(0,nrow(x))
  for(rf in 1:nrow(x)){  
    for(i in 1:25){
      x$total_expectations[rf] <- as.numeric(x$total_expectations[rf] + x[rf,i]^2)
    }}
  return(x)
}

# male_users <- calculateUserExpectations(male_users)

# Calculate Cultural things

