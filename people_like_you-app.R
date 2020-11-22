# Install Packages --------------------------------------------------------
library(tidyverse)
library(magrittr)
library(lubridate)
library(googlesheets4)
library(googledrive)
library(gmailr)
library(skimr)

# Load Files --------------------------------------------------------------
source('people_like_you-data_new_user_ingest.R')
source("people_like_you-data_processing.R")
source('people_like_you-tracking.R')
source('people_like_you-data_prep.R')
source('people_like_you-difference_calculator.R')
source("people_like_you-matcher.R")
authGoogleSheets()
#existing_user_table <- NULL
#existing_user_table <- new_user_table
user_ids_old <- read.csv('user_ids.csv')
user_ids_old <- user_ids_old %>%
  select(email_address,user_id)
# Load Data ---------------------------------------------------------------
raw_new_user_table <- loadNewUserData(raw_new_user_table)
new_user_table <- excludeAllButMostRecentEntryPerUser(raw_new_user_table)
new_user_table <- excludeFakeAccounts(new_user_table)
new_user_table <- excludeInactiveAccounts(new_user_table)
new_user_table <- excludeNonactiveRegionAccounts(new_user_table)
new_user_table <- excludePeopleWithNoPhotos(new_user_table)
# existing_user_table <- loadExistingUserTable('user_table.csv')
# verified_new_users <- excludePreviousUsers(existing_user_table,new_user_table)
# new_user_table <- legibleColumnNames(verified_new_users)
# raw_new_user_table <- legibleColumnNames(raw_new_user_table)
new_user_table <- legibleColumnNames(new_user_table)
new_user_table <- recodeLikertDataForNewUsers(new_user_table)
new_user_table <- recodeHeightData(new_user_table)
new_user_table <- recodeBirthDateData(new_user_table)
# new_user_table <- createUserIds(existing_user_table,new_user_table)
# new_user_table <- createUserIdsFirstTime(new_user_table)
new_user_table <- new_user_table %>%
  left_join(user_ids_old) %>% as_tibble() %>%
  mutate(user_id=as.character(user_id))

new_user_table <- recodeDataAsNumeric(new_user_table)
new_user_table <- createDistinctAttributeImportanceColumns(new_user_table)
# new_user_table_test <- createDistinctLocationColumns(new_user_table)
# new_user_table <- createUnifiedPromptField(new_user_table)
new_user_table <- createUnifiedPromptField(new_user_table)
# user_table <- mergeNewAndExistingUsers(existing_user_table,new_user_table)

saveNewUserData(new_user_table)

new_male_users <- createGenderTableSimple(new_user_table,'Male')
new_female_users <- createGenderTableSimple(new_user_table,'Female')
new_male_users <- calculateUserExpectations(new_male_users)
new_female_users <- calculateUserExpectations(new_female_users)
new_male_users <- calculateUserSelfEvaluation(new_male_users)
new_female_users <- calculateUserSelfEvaluation(new_female_users)

saveMaleUserData(new_male_users)
saveFemaleUserData(new_female_users)




# Matching ----------------------------------------------------------------
existing_male_users <- loadExistingGenderData('existing_male_user_data.csv')
# FOR WHEN THIS DOESN'T WORK
# existing_male_users %<>%
#   # select(-X) %>%
#   mutate(user_id=as.character(user_id))
  
existing_female_users <- loadExistingGenderData('existing_female_user_data.csv')
# existing_female_users %<>%
#   # select(-X) %>%
#   mutate(user_id=as.character(user_id))
existing_male_users_preference <- loadExistingDifferenceDataMale()
# existing_male_users_preference %<>%
#   #select(-X) %>%
#   mutate(preference_user_id=as.character(preference_user_id),
#          matching_user_id=as.character(matching_user_id))
  
existing_female_users_preference <- loadExistingDifferenceDataFemale()
# existing_female_users_preference %<>%
#   #select(-X) %>%
#   mutate(preference_user_id=as.character(preference_user_id),
#          matching_user_id=as.character(matching_user_id))
# 
# existing_male_users_preference <- existing_male_users_preference %>%
#   mutate_at(vars(-preference_user_id, -matching_user_id), as.numeric)
# 
# existing_male_users_preference$difference <- rep(0,nrow(existing_male_users_preference))


male_user_preferences <- calculateUserDifferenceSimple(new_male_users,new_female_users)
female_user_preferences <- calculateUserDifferenceSimple(new_female_users,new_male_users)

# male_users_preference <- calculateUserDifference(new_male_users,new_female_users,existing_female_user_data,existing_female_users_preference)
# female_users_preference <- calculateUserDifference(new_female_users,new_male_users,existing_male_user_data,existing_male_users_preference)

saveGenderDifferenceTables(male_user_preferences,'existing_male_users_preference')
saveGenderDifferenceTables(female_user_preferences,'existing_female_users_preference')
# Determine Individual Match Score ----------------------------------------
male_user_preferences <- calculateUserMatchScore(male_user_preferences)
male_user_preferences <- calculateUserCultureScore(male_user_preferences)
male_user_preferences$gender <- rep("male",nrow(male_user_preferences))
female_user_preferences <- calculateUserMatchScore(female_user_preferences)
female_user_preferences <- calculateUserCultureScore(female_user_preferences)
female_user_preferences$gender <- rep("female",nrow(female_user_preferences))
# Calculate Pair Score ----------------------------------------------------
pairedTable <- calculatePairScore(male_user_preferences,female_user_preferences)
# male_user_preferences %>%
#   ggplot(aes(match_percentage))+geom_histogram()
# female_user_preferences %>%
#   ggplot(aes(match_percentage))+geom_histogram()
# 
# pairedTable %>%
#   ggplot(aes(match_score_aggragate))+geom_histogram()

#unilateralMatches<- unilateralMatchGenerator(pairedTable,1.6,1)

matchList<- matchListGenerator(pairedTable,1.7,1)

pairedTable %>%
  filter(match_score_aggragate>1.7) %>%
  select(preference_user_id,matching_user_id,match_score_aggragate) %>%
  filter(cultureScore_female>=1) %>%
  filter(cultureScore_male>=1) %>%
  mutate(match_date=today())
# <- matchListTopX(pairedTable,10)
new_user_table %>%
  mutate(prompt_unified=prompt_unified_real)

matchList %>%
  count(matching_user_id) %>%
  arrange(desc(n))

pairedTable %>%
  filter(matching_user_id=='uid00000092') %>%
  filter(preference_user_id=='uid00000037')%>%
  View()
  #filter(cultureScore_female==1) %>%
  #select(match_percentage_female,match_percentage_male) %>%
  arrange(desc(match_percentage_female))

# Punch List
## Determine Who is getting an email
### See who is going to get matches
pairedTable %>%
  group_by(preference_user_id) %>%
  mutate(maxMaleMatchScore=max(match_percentage_male)) %>%
  ungroup() %>%
  group_by(matching_user_id) %>%
  mutate(maxFemaleMatchScore=max(match_percentage_female)) %>%
  View()

## Create an email generator
### Test with a welcome email
sendWelcomeEmail('charlesrogers@gmail.com')
View(new_user_table$prompt_unified)

###Check to see if they have already received an email in V2 --  CHARLES DON'T DO THIS FOR v1

# Things to fix:
## Don't penalize people for picking over 5 attributes, just decrease their weight from a "5" to a "4"
## Discount people who rate themselves very highly
## Add in a height filter for some points
## Add in physical attractiveness
## Add in physical location filter
