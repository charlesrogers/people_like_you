#source("people_like_you-matching.R")

# Calculate Preference User Match Score -----------------------------------
## Match Percentage calculation: 1 - ((difference + total expectations) / total expectations)
calculateUserMatchScore <- function(x){
  x <- x %>%
    mutate(match_percentage=((difference+preference_user_expectations)/preference_user_expectations))
  return(x)
}

# Calculate User Culture Score --------------------------------------------
calculateUserCultureScore <- function(x){
  x <- x %>%
    mutate(cultureScore=(diff_culture_children+diff_culture_breadwinner+diff_culture_homemaker+diff_culture_active+diff_culture_nonTraditional+diff_culture_location+diff_culture_mutualInterests)/7)
  return(x)
}

calculateUserPhysicalScore <- function(x){
  x <- x %>%
    mutate(physicalScore=(diff_physical_age+diff_physical_height)/2)
  return(x)
}

# calculateUserDistanceScore <- function(x){
#   x <- x %>%
#     mutate(physicalScore=(diff_physical_age+diff_physical_height)/2)
#   return(x)
# }

# Create List of Matches --------------------------------------------------
matchListGenerator <- function(user_table,minThresholdMatch, minThresholdCulture){
  matchList <-  user_table %>%
    filter(match_score_aggragate>minThresholdMatch) %>%
    filter(cultureScore_female>=minThresholdCulture) %>%
    filter(cultureScore_male>=minThresholdCulture) %>%
    select(preference_user_id,matching_user_id,match_score_aggragate)%>%
    mutate(match_date=today())
  return(matchList)
}



createUnilateralMatchRanker <- function(x){
  x %>%
    
  return(x)
}

long_list <- rbind(female_user_preferences,male_user_preferences)



male_user_preferences %>%
  filter(cultureScore==1)%>%
  filter(diff_cultural_height_score<3) %>%
  filter(diff_cultural_age_score<1500) %>%
  # filter(diff_same_location==1) %>%
  select(preference_user_id,matching_user_id,match_percentage,gender,diff_cultural_height_score,diff_cultural_age_score) %>%
  group_by(preference_user_id) %>%
  mutate(preferrer_match_rank = order(order(match_percentage, decreasing=TRUE))) %>%
  ungroup() %>%
  filter(preferrer_match_rank<6) %>%
  View()

female_user_preferences %>%
  filter(cultureScore==1)%>%
  #filter(diff_cultural_height_score>3) %>%
  #filter(diff_cultural_age_score>1500) %>%
  # filter(diff_same_location==1) %>%
  select(preference_user_id,matching_user_id,match_percentage,gender,diff_cultural_height_score,diff_cultural_age_score) %>%
  group_by(preference_user_id) %>%
  mutate(preferrer_match_rank = order(order(match_percentage, decreasing=TRUE))) %>%
  ungroup() %>%
  filter(preferrer_match_rank<6) %>%
  View()


  #ggplot(aes(match_percentage,fill=gender))+geom_histogram(alpha=.5)
  count(matching_user_id) %>%
  arrange(desc(n))





matchListTopX <- function(users,number_of_matches){
  
}


# Calculate Overall Percentile Match Score --------------------------------
caclulatePercentile <- function(x){
  
}


# Calculate Overall Rank --------------------------------------------------
caclulatePairMatchScore <- function(x){
  
}


# Check to see if the Male hight is >= the female's -----------------------
executeHeightCheck <- function(x){
  
}



# Open Questions
## Should we discount people who are way more particular that they will generally wait a bit longer, get fewer/less-% match recs?
## Should we tell people who are more particular












# Should we look at things separately at the value/attribute level?
# male_users_preference$difference_values <- rep(0,nrow(male_users_preference))
# male_users_preference$difference_values_count <- rep(0,nrow(male_users_preference))
# male_users_preference$difference_attributes <- rep(0,nrow(male_users_preference))
# male_users_preference$difference_attributes_count <- rep(0,nrow(male_users_preference))

# for(rf in 1:nrow(male_users_preference)){  
#   for(i in 1:7){
#     if(male_users_preference[rf,i]<0)
#       male_users_preference$difference_values[rf] <- male_users_preference$difference_values[rf] + male_users_preference[rf,i]
#     # male_users_preference$difference_values_count[rf] <- male_users_preference$difference_values_count + 1
#   }}
# 
# male_users_preference <- male_users_preference %>%
#   mutate(difference_values=as.numeric(difference_values))
# 
# for(rf in 1:nrow(male_users_preference)){  
#   for(i in 8:23){
#     if(male_users_preference[rf,i]<0)
#       male_users_preference$difference_attributes[rf] <- male_users_preference$difference_attributes[rf] + male_users_preference[rf,i]
#     # male_users_preference$difference_attributes_count[rf] <- male_users_preference$difference_attributes_count + 1
#   }}
# 
# male_users_preference <- male_users_preference %>%
#   mutate(difference_attributes=as.numeric(difference_attributes))

