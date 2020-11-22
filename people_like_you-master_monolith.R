# Install Packages --------------------------------------------------------
library(tidyverse)
library(magrittr)
library(lubridate)
library(googlesheets4)
library(googledrive)
library(gmailr)

# Load Data ---------------------------------------------------------------
googledrive::drive_auth(use_oob = TRUE)
drive_user()
sheets_auth(token = drive_token())
df_raw <- read_sheet("1Hp6z3DtakZqR5HzabUINobRbk3I_Ida9F0N8BAYvezE")

# Clean Data --------------------------------------------------------------
# * Exclusion List --------------------------------------------------------

exclusion_email_list <- c('linhao.zhang@gmail.com','dodo@gmail.com','me@example.com')


# * Exclude all but most recent entry -------------------------------------
df <- df_raw %>%
  group_by(`Email Address`) %>%
  slice(which.max(Timestamp)) 


# Exclude fake accounts ---------------------------------------------------
df <- df %>%
  filter(!`Email Address` %in% exclusion_email_list)

# * Format Data -----------------------------------------------------------
# Create Named Values -----------------------------------------------------
df <- df %>%
  select(
      pos_values_selfless=`How well do each of the following statements describe you? [I am deeply concerned with the needs of others]`,
      pos_values_curious=`How well do each of the following statements describe you? [I am eager to learn new things]`,
      pos_values_fun=`How well do each of the following statements describe you? [I actively seek amusement and fun]`,
      pos_values_ambition=`How well do each of the following statements describe you? [I have a strong determination to achieve success]`,
      pos_values_security=`How well do each of the following statements describe you? [I try to avoid potentially risky situations]`,
      pos_values_selfimprovement=`How well do each of the following statements describe you? [I consistently focus on my own improvement]`,
      pos_values_traditional=`How well do each of the following statements describe you? [I tend to hold traditional attitudes and values]`,
      pos_attributes_logical=`How well do each of the following statements describe you? [I tend to approach problems in a rational manner]`,
      pos_attributes_emotionallyInTune=`How well do each of the following statements describe you? [I usually listen to my instincts when making a decision]`,
      pos_attributes_agreeable=`How well do each of the following statements describe you? [People would describe me as being pleasant to be around]`,
      pos_attributes_empathetic=`How well do each of the following statements describe you? [I deeply understand others' points of view and feelings]`,
      pos_attributes_confident=`How well do each of the following statements describe you? [I am typically self-assured in my decisions]`,
      pos_attributes_patient=`How well do each of the following statements describe you? [I usually tolerate delays or trouble without getting upset]`,
      pos_attributes_emotionallyMature=`How well do each of the following statements describe you? [I always understand and manage my emotions]`,
      pos_attributes_responsible=`How well do each of the following statements describe you? [I always fulfill my commitments]`,
      pos_attributes_honest=`How well do each of the following statements describe you? [I tell the truth, even when inconvenient]`,
      pos_attributes_spontaneous=`How well do each of the following statements describe you? [I tend to follow my impulses without deliberating too much first]`,
      pos_attributes_flexible=`How well do each of the following statements describe you? [I am willing to change or compromise my wishes and plans]`,
      pos_attributes_creative=`How well do each of the following statements describe you? [People would describe me as having a strong sense of imagination]`,
      pos_attributes_forgiving=`How well do each of the following statements describe you? [I tend to quickly release feelings of resentment towards others]`,
      pos_attributes_optimistic=`How well do each of the following statements describe you? [I believe that things are good and will generally work out]`,
      pos_attributes_calm=`How well do each of the following statements describe you? [I tend to remain relaxed despite troubling circumstances]`,
      pos_attributes_extroverted=`How well do each of the following statements describe you? [I thrive in social situations]`,
      pos_attributes_openminded=`How well do each of the following statements describe you? [I am willing to consider ideas that are NOT in agreement with my beliefs]`,
      pos_physicalFitness=`How frequently do you exercise?`,
      pos_fct_interests=`Which of the following activities are you passionate about?`,
      pos_fct_levelEducation=`Please select your highest level of education (either completed or in progress)`,
      pos_fct_height=`How tall are you?`,
      pos_fct_residence_region=`Please select the region in which you currently reside`,
      pos_fct_residence_country=`Please select the country in which you currently reside`,
      pos_fct_residence_state=`Please select the state in which you currently reside`,
      pos_fct_desired_region=`In which of the following regions are you willing to consider potential partners?`,
      imp_values_culture_children=`How important are the following to you when considering a potential partner? [That my partner wants to have children]`,
      imp_values_culture_breadwinner=`How important are the following to you when considering a potential partner? [That the male be the primary provider]`,
      imp_values_culture_homemaker=`How important are the following to you when considering a potential partner? [That the female partner stay at home while any children are not yet in school]`,
      imp_values_culture_active=`How important are the following to you when considering a potential partner? [That your partner be an active member of the Church of Jesus Christ of Latter-day Saints]`,
      imp_values_culture_mutualInterests=`How important are the following to you when considering a potential partner? [That you and your partner share hobbies or interests]`,
      imp_values_culture_nonTraditional=`How important are the following to you when considering a potential partner? [That your partner be okay with non-traditional interpretations of the commandments]`,
      imp_values_culture_location=`How important are the following to you when considering a potential partner? [That you settle down in a particular location? (e.g live near your family)]`,
      imp_values_selfless=`How important are the following when considering a potential partner?  [Selfless]`,
      imp_values_curious=`How important are the following when considering a potential partner?  [Curious]`,
      imp_values_fun=`How important are the following when considering a potential partner?  [Fun]`,
      imp_values_ambition=`How important are the following when considering a potential partner?  [Ambitious]`,
      imp_values_security=`How important are the following when considering a potential partner?  [Risk-averse]`,
      imp_values_selfimprovement=`How important are the following when considering a potential partner?  [Self-improvement focused]`,
      imp_values_traditional=`How important are the following when considering a potential partner?  [Traditional]`,
      imp_values_physicalAttraction=`How important are the following when considering a potential partner?  [Physical attractiveness]`,
      imp_attributes_logical=`How well do each of the following statements describe you? [I tend to approach problems in a rational manner]`,
      imp_attributes_emotionallyInTune=`How well do each of the following statements describe you? [I usually listen to my instincts when making a decision]`,
      imp_attributes_agreeable=`How well do each of the following statements describe you? [People would describe me as being pleasant to be around]`,
      imp_attributes_empathetic=`How well do each of the following statements describe you? [I deeply understand others' points of view and feelings]`,
      imp_attributes_confident=`How well do each of the following statements describe you? [I am typically self-assured in my decisions]`,
      imp_attributes_patient=`How well do each of the following statements describe you? [I usually tolerate delays or trouble without getting upset]`,
      imp_attributes_emotionallyMature=`How well do each of the following statements describe you? [I always understand and manage my emotions]`,
      imp_attributes_responsible=`How well do each of the following statements describe you? [I always fulfill my commitments]`,
      imp_attributes_honest=`How well do each of the following statements describe you? [I tell the truth, even when inconvenient]`,
      imp_attributes_spontaneous=`How well do each of the following statements describe you? [I tend to follow my impulses without deliberating too much first]`,
      imp_attributes_flexible=`How well do each of the following statements describe you? [I am willing to change or compromise my wishes and plans]`,
      imp_attributes_creative=`How well do each of the following statements describe you? [People would describe me as having a strong sense of imagination]`,
      imp_attributes_forgiving=`How well do each of the following statements describe you? [I tend to quickly release feelings of resentment towards others]`,
      imp_attributes_optimistic=`How well do each of the following statements describe you? [I believe that things are good and will generally work out]`,
      imp_attributes_calm=`How well do each of the following statements describe you? [I tend to remain relaxed despite troubling circumstances]`,
      imp_attributes_extroverted=`How well do each of the following statements describe you? [I thrive in social situations]`,
      imp_fct_attributes_fiveAttributes=`Which of the following characteristics are most important to you in a partner? (Select up to 5)`,
      demo_gender=`Please select your gender`,
      demo_birth_year=`Please select your birth year`,
      demo_birth_month=`Please select your birth month`,
      demo_birth_day=`Please select your birth day`,
      demo_first_name=`What is your first name?`,
      demo_last_name=`What is your last name?`,
      date_joined=Timestamp,
      email_address=`Email Address`,
      referrer=`Who told you about this?`
  )

# Recode Likert Data from String to Numeric -------------------------------
for(r in 1:ncol(df)){
  for(c in 1:nrow(df)){
    if(df[c,r] %in% c('Extremely important','Describes me extremely well')){
      df[c,r] <- 5}
    else if(df[c,r] %in% c('Very important','Describes me well')){
      df[c,r] <-4}
    else if(df[c,r] %in% c('Moderately important','Moderately describes me',"Important")){
      df[c,r] <-3}
    else if(df[c,r] %in% c('Not that important','Somewhat describes me','Somewhat describes')){
      df[c,r] <-2}
    else if(df[c,r] %in% c('Not at all important','Does not describe me at all')){
      df[c,r] <-1}
    else if(df[c,r] %in% c('I would prefer that they not')){
      df[c,r] <--10}
  }}


# * Fix Factors -----------------------------------------------------------
df <- df %>% mutate_at(vars(starts_with(c("pos_attributes",'pos_values','imp_values','imp_attributes'))),as.numeric)
str(df)
# Create User Ids ---------------------------------------------------------
df$user_id <- 1:nrow(df) 

for (i in 1:nrow(df)){
  if(nchar(df$user_id[i])==1){
    df$user_id[i]<- paste0('uid0000000',df$user_id[i])}
  
  else if(nchar(df$user_id[i])==2){
    df$user_id[i]<- paste0('uid000000',df$user_id[i])
  }
  else if(nchar(df$user_id[i])==3){
    df$user_id[i]<- paste0('uid00000',df$user_id[i])
  }
  else if(nchar(df$user_id[i])==4){
    df$user_id[i]<- paste0('uid0000',df$user_id[i])
  }
  else if(nchar(df$user_id[i])==5){
    df$user_id[i]<- paste0('uid000',df$user_id[i])
  }
  else if(nchar(df$user_id[i])==6){
    df$user_id[i]<- paste0('uid00',df$user_id[i])
  }
  else if(nchar(df$user_id[i])==7){
    df$user_id[i]<- paste0('uid0',df$user_id[i])
  }
  else if(nchar(df$user_id[i])==8){
    df$user_id[i]<- paste0('uid',df$user_id[i])
  }}


# Create Gender Tables ----------------------------------------------------
male_users <- NULL
female_users <- NULL
for(i in 1:nrow(df)){
  if(df$demo_gender[i]=='Male'){
    male_users <- rbind(male_users,df[i,])
  } else{
    female_users <- rbind(female_users,df[i,])}
}

# Matching ----------------------------------------------------------------
# * Calculate Male User Preference ----------------------------------------
## Create empty data frames
male_users_preference <- NULL
preference_user_id <- NULL
matching_user_id <- NULL

# (female_users$pos_values_selfless[1]-male_users$imp_values_selfless[1])*male_users$imp_values_selfless[1]
# (female_users$pos_values_selfless[2]-male_users$imp_values_selfless[1])*male_users$imp_values_selfless[1]
# (female_users$pos_values_selfless[3]-male_users$imp_values_selfless[1])*male_users$imp_values_selfless[1]
# (female_users$pos_values_curious[1]-male_users$pos_values_curious[1])*male_users$pos_values_curious[1]
# (female_users$pos_values_curious[2]-male_users$pos_values_curious[1])*male_users$pos_values_curious[1]
# (female_users$pos_values_curious[3]-male_users$pos_values_curious[1])*male_users$pos_values_curious[1]
# (female_users$pos_values_fun[1]-male_users$pos_values_fun[1])*male_users$pos_values_fun[1]
# (female_users$pos_values_fun[2]-male_users$pos_values_fun[1])*male_users$pos_values_fun[1]
# (female_users$pos_values_fun[3]-male_users$pos_values_fun[1])*male_users$pos_values_fun[1]

for(wr in 1:nrow(male_users)){
  for(mr in 1:nrow(female_users)){
    male_users_preference <- rbind(male_users_preference,cbind((female_users$pos_values_selfless[mr]-male_users$imp_values_selfless[wr])*male_users$imp_values_selfless[wr],
                                                               (female_users$pos_values_curious[mr]-male_users$imp_values_curious[wr])*male_users$imp_values_curious[wr],
                                                               (female_users$pos_values_fun[mr]-male_users$imp_values_fun[wr])*male_users$imp_values_fun[wr],
                                                               (female_users$pos_values_ambition[mr]-male_users$imp_values_ambition[wr])*male_users$imp_values_ambition[wr],
                                                               (female_users$pos_values_security[mr]-male_users$imp_values_security[wr])*male_users$imp_values_security[wr],
                                                               (female_users$pos_values_selfimprovement[mr]-male_users$imp_values_selfimprovement[wr])*male_users$imp_values_selfimprovement[wr],
                                                               (female_users$pos_values_traditional[mr]-male_users$imp_values_traditional[wr])*male_users$imp_values_traditional[wr],
                                                               (female_users$pos_attributes_logical[mr]-male_users$imp_attributes_logical[wr])*male_users$imp_attributes_logical[wr],
                                                               (female_users$pos_attributes_emotionallyInTune[mr]-male_users$imp_attributes_emotionallyInTune[wr])*male_users$imp_attributes_emotionallyInTune[wr],
                                                               (female_users$pos_attributes_agreeable[mr]-male_users$imp_attributes_agreeable[wr])*male_users$imp_attributes_agreeable[wr],
                                                               (female_users$pos_attributes_empathetic[mr]-male_users$imp_attributes_empathetic[wr])*male_users$imp_attributes_empathetic[wr],
                                                               (female_users$pos_attributes_confident[mr]-male_users$imp_attributes_confident[wr])*male_users$imp_attributes_confident[wr],
                                                               (female_users$pos_attributes_patient[mr]-male_users$imp_attributes_patient[wr])*male_users$imp_attributes_patient[wr],
                                                               (female_users$pos_attributes_emotionallyMature[mr]-male_users$imp_attributes_emotionallyMature[wr])*male_users$imp_attributes_emotionallyMature[wr],
                                                               (female_users$pos_attributes_responsible[mr]-male_users$imp_attributes_responsible[wr])*male_users$imp_attributes_responsible[wr],
                                                               (female_users$pos_attributes_honest[mr]-male_users$imp_attributes_honest[wr])*male_users$imp_attributes_honest[wr],
                                                               (female_users$pos_attributes_spontaneous[mr]-male_users$imp_attributes_spontaneous[wr])*male_users$imp_attributes_spontaneous[wr],
                                                               (female_users$pos_attributes_flexible[mr]-male_users$imp_attributes_flexible[wr])*male_users$imp_attributes_flexible[wr],
                                                               (female_users$pos_attributes_creative[mr]-male_users$imp_attributes_creative[wr])*male_users$imp_attributes_creative[wr],
                                                               (female_users$pos_attributes_forgiving[mr]-male_users$imp_attributes_forgiving[wr])*male_users$imp_attributes_forgiving[wr],
                                                               (female_users$pos_attributes_optimistic[mr]-male_users$imp_attributes_optimistic[wr])*male_users$imp_attributes_optimistic[wr],
                                                               (female_users$pos_attributes_calm[mr]-male_users$imp_attributes_calm[wr])*male_users$imp_attributes_calm[wr],
                                                               (female_users$pos_attributes_extroverted[mr]-male_users$imp_attributes_extroverted[wr])*male_users$imp_attributes_extroverted[wr],
                                                               male_users$user_id[wr],
                                                               female_users$user_id[mr]))
  }}

# Make column names meaningful --------------------------------------------
male_users_preference <- male_users_preference %>%
  as_tibble() %>%
  rename(diff_value_selfless=V1,
         diff_value_curious=V2,
         diff_value_fun=V3,
         diff_value_ambition=V4,
         diff_value_security=V5,
         diff_value_selfImprovement=V6,
         diff_value_traditional=V7,
         diff_attribute_logical=V8,
         diff_attribute_emotionallyInTune=V9,
         diff_attribute_agreeable=V10,
         diff_attribute_empathetic=V11,
         diff_attribute_confident=V12,
         diff_attribute_patient=V13,
         diff_attribute_emotionallyMature=V14,
         diff_attribute_responsible=V15,
         diff_attribute_honest=V16,
         diff_attribute_spontaneous=V17,
         diff_attribute_flexible=V18,
         diff_attribute_creative=V19,
         diff_attribute_forgiving=V20,
         diff_attribute_optimistic=V21,
         diff_attribute_calm=V22,
         diff_attribute_extroverted=V23,
         preference_user_id=V24,
         matching_user_id=V25)


male_users_preference <- male_users_preference %>%
  mutate_at(vars(-preference_user_id, -matching_user_id), as.numeric)

male_users_preference$difference <- rep(0,nrow(male_users_preference))
male_users_preference$difference_values <- rep(0,nrow(male_users_preference))
# male_users_preference$difference_values_count <- rep(0,nrow(male_users_preference))
male_users_preference$difference_attributes <- rep(0,nrow(male_users_preference))
# male_users_preference$difference_attributes_count <- rep(0,nrow(male_users_preference))
#Calculate male user total diff
for(rf in 1:nrow(male_users_preference)){  
  for(i in 1:23){
    if(male_users_preference[rf,i]<0)
      male_users_preference$difference[rf] <- male_users_preference$difference[rf] + male_users_preference[rf,i]
  }}

male_users_preference <- male_users_preference %>%
  mutate(difference=as.numeric(difference))

for(rf in 1:nrow(male_users_preference)){  
  for(i in 1:7){
    if(male_users_preference[rf,i]<0)
      male_users_preference$difference_values[rf] <- male_users_preference$difference_values[rf] + male_users_preference[rf,i]
    # male_users_preference$difference_values_count[rf] <- male_users_preference$difference_values_count + 1
  }}

male_users_preference <- male_users_preference %>%
  mutate(difference_values=as.numeric(difference_values))

for(rf in 1:nrow(male_users_preference)){  
  for(i in 8:23){
    if(male_users_preference[rf,i]<0)
      male_users_preference$difference_attributes[rf] <- male_users_preference$difference_attributes[rf] + male_users_preference[rf,i]
    # male_users_preference$difference_attributes_count[rf] <- male_users_preference$difference_attributes_count + 1
  }}

male_users_preference <- male_users_preference %>%
  mutate(difference_attributes=as.numeric(difference_attributes))

# male_users_preference <- male_users_preference %>%
#   mutate(difference_attributes_count=as.numeric(difference_attributes_count))
# male_users_preference <- male_users_preference %>%
#   mutate(difference_values_count=as.numeric(difference_values_count))
# * Calculate Female User Preference ----------------------------------------
## Create empty data frames
female_users_preference <- NULL
preference_user_id <- NULL
matching_user_id <- NULL

# (male_users$pos_values_selfless[1]-female_users$imp_values_selfless[1])*female_users$imp_values_selfless[1]
# (male_users$pos_values_selfless[2]-female_users$imp_values_selfless[1])*female_users$imp_values_selfless[1]
# (male_users$pos_values_selfless[3]-female_users$imp_values_selfless[1])*female_users$imp_values_selfless[1]
# (male_users$pos_values_curious[1]-female_users$pos_values_curious[1])*female_users$pos_values_curious[1]
# (male_users$pos_values_curious[2]-female_users$pos_values_curious[1])*female_users$pos_values_curious[1]
# (male_users$pos_values_curious[3]-female_users$pos_values_curious[1])*female_users$pos_values_curious[1]
# (male_users$pos_values_fun[1]-female_users$pos_values_fun[1])*female_users$pos_values_fun[1]
# (male_users$pos_values_fun[2]-female_users$pos_values_fun[1])*female_users$pos_values_fun[1]
# (male_users$pos_values_fun[3]-female_users$pos_values_fun[1])*female_users$pos_values_fun[1]

## Cycle through users, subtract, multiply by weight
for(wr in 1:nrow(female_users)){
  for(mr in 1:nrow(male_users)){
    female_users_preference <- rbind(female_users_preference,cbind((male_users$pos_values_selfless[mr]-female_users$imp_values_selfless[wr])*female_users$imp_values_selfless[wr],
                                                               (male_users$pos_values_curious[mr]-female_users$imp_values_curious[wr])*female_users$imp_values_curious[wr],
                                                               (male_users$pos_values_fun[mr]-female_users$imp_values_fun[wr])*female_users$imp_values_fun[wr],
                                                               (male_users$pos_values_ambition[mr]-female_users$imp_values_ambition[wr])*female_users$imp_values_ambition[wr],
                                                               (male_users$pos_values_security[mr]-female_users$imp_values_security[wr])*female_users$imp_values_security[wr],
                                                               (male_users$pos_values_selfimprovement[mr]-female_users$imp_values_selfimprovement[wr])*female_users$imp_values_selfimprovement[wr],
                                                               (male_users$pos_values_traditional[mr]-female_users$imp_values_traditional[wr])*female_users$imp_values_traditional[wr],
                                                               (male_users$pos_attributes_logical[mr]-female_users$imp_attributes_logical[wr])*female_users$imp_attributes_logical[wr],
                                                               (male_users$pos_attributes_emotionallyInTune[mr]-female_users$imp_attributes_emotionallyInTune[wr])*female_users$imp_attributes_emotionallyInTune[wr],
                                                               (male_users$pos_attributes_agreeable[mr]-female_users$imp_attributes_agreeable[wr])*female_users$imp_attributes_agreeable[wr],
                                                               (male_users$pos_attributes_empathetic[mr]-female_users$imp_attributes_empathetic[wr])*female_users$imp_attributes_empathetic[wr],
                                                               (male_users$pos_attributes_confident[mr]-female_users$imp_attributes_confident[wr])*female_users$imp_attributes_confident[wr],
                                                               (male_users$pos_attributes_patient[mr]-female_users$imp_attributes_patient[wr])*female_users$imp_attributes_patient[wr],
                                                               (male_users$pos_attributes_emotionallyMature[mr]-female_users$imp_attributes_emotionallyMature[wr])*female_users$imp_attributes_emotionallyMature[wr],
                                                               (male_users$pos_attributes_responsible[mr]-female_users$imp_attributes_responsible[wr])*female_users$imp_attributes_responsible[wr],
                                                               (male_users$pos_attributes_honest[mr]-female_users$imp_attributes_honest[wr])*female_users$imp_attributes_honest[wr],
                                                               (male_users$pos_attributes_spontaneous[mr]-female_users$imp_attributes_spontaneous[wr])*female_users$imp_attributes_spontaneous[wr],
                                                               (male_users$pos_attributes_flexible[mr]-female_users$imp_attributes_flexible[wr])*female_users$imp_attributes_flexible[wr],
                                                               (male_users$pos_attributes_creative[mr]-female_users$imp_attributes_creative[wr])*female_users$imp_attributes_creative[wr],
                                                               (male_users$pos_attributes_forgiving[mr]-female_users$imp_attributes_forgiving[wr])*female_users$imp_attributes_forgiving[wr],
                                                               (male_users$pos_attributes_optimistic[mr]-female_users$imp_attributes_optimistic[wr])*female_users$imp_attributes_optimistic[wr],
                                                               (male_users$pos_attributes_calm[mr]-female_users$imp_attributes_calm[wr])*female_users$imp_attributes_calm[wr],
                                                               (male_users$pos_attributes_extroverted[mr]-female_users$imp_attributes_extroverted[wr])*female_users$imp_attributes_extroverted[wr],
                                                               female_users$user_id[wr],
                                                               male_users$user_id[mr]))
  }}

## Make column names meaningful
female_users_preference <- female_users_preference %>%
  as_tibble() %>%
  rename(diff_value_selfless=V1,
         diff_value_curious=V2,
         diff_value_fun=V3,
         diff_value_ambition=V4,
         diff_value_security=V5,
         diff_value_selfImprovement=V6,
         diff_value_traditional=V7,
         diff_attribute_logical=V8,
         diff_attribute_emotionallyInTune=V9,
         diff_attribute_agreeable=V10,
         diff_attribute_empathetic=V11,
         diff_attribute_confident=V12,
         diff_attribute_patient=V13,
         diff_attribute_emotionallyMature=V14,
         diff_attribute_responsible=V15,
         diff_attribute_honest=V16,
         diff_attribute_spontaneous=V17,
         diff_attribute_flexible=V18,
         diff_attribute_creative=V19,
         diff_attribute_forgiving=V20,
         diff_attribute_optimistic=V21,
         diff_attribute_calm=V22,
         diff_attribute_extroverted=V23,
         preference_user_id=V24,
         matching_user_id=V25)

female_users_preference <- female_users_preference %>%
  mutate_at(vars(-preference_user_id, -matching_user_id), as.numeric)

female_users_preference$difference <- rep(0,nrow(female_users_preference))

#Calculate male user total diff
for(rf in 1:nrow(female_users_preference)){  
  for(i in 1:23){
    if(female_users_preference[rf,i]<0)
      female_users_preference$difference[rf] <- female_users_preference$difference[rf] + female_users_preference[rf,i]
  }}

female_users_preference <- female_users_preference %>%
  mutate(difference=as.numeric(difference))

# Create Merged Database --------------------------------------------------
pref_merged_df <- NULL
pref_merged_df <- rbind(male_users_preference, female_users_preference)
pref_merged_df <- pref_merged_df %>%
  mutate(difference=as.numeric(difference))
# View(pref_merged_df)


# pref_merged_df %>%
#   filter(is.na(preference_user_id))%>%
#   select(preference_user_id)

# Send Email --------------------------------------------------------------
# * Authenticate App 
# * Send Test Email -------------------------------------------------------
test_email <- mime(
  To = "charlesrogers@gmail.com",
  From = "findpeoplelikeyou@gmail.com",
  Subject = "this is just a gmailr test",
  body = "Can you hear me now?")
gm_send_message(test_email)

test_email_url <- 'https://dogtime.com/assets/uploads/2018/10/puppies-cover-1280x720.jpg'

# Welcome Email Template --------------------------------------------------
welcome_email <- gm_mime() %>%
  gm_to('charlesrogers@gmail.com') %>%
  gm_from("findpeoplelikeyou@gmail.com") %>%
  gm_subject("Test: Welcome Email") %>%
  gm_html_body(
    '<center>
            <table align="center" border="0" cellpadding="0" cellspacing="0" height="100%" width="100%" id="bodyTable" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;height: 100%;margin: 0;padding: 0;width: 100%;background-color: #fffff7;">
                <tbody><tr>
                    <td align="center" valign="top" id="bodyCell" style="mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;height: 100%;margin: 0;padding: 10px;width: 100%;border-top: 0;">
                        <!-- BEGIN TEMPLATE // -->
                        <!--[if (gte mso 9)|(IE)]>
                        <table align="center" border="0" cellspacing="0" cellpadding="0" width="600" style="width:600px;">
                        <tr>
                        <td align="center" valign="top" width="600" style="width:600px;">
                        <![endif]-->
                        <table border="0" cellpadding="0" cellspacing="0" width="100%" class="templateContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;border: 0;max-width: 600px !important;">
                            <tbody><tr>
                                <td valign="top" id="templatePreheader" style="background:#FAFAFA none no-repeat center/cover;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #FAFAFA;background-image: none;background-repeat: no-repeat;background-position: center;background-size: cover;border-top: 0;border-bottom: 0;padding-top: 9px;padding-bottom: 9px;"><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnTextBlock" style="min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
    <tbody class="mcnTextBlockOuter">
        <tr>
            <td valign="top" class="mcnTextBlockInner" style="padding-top: 9px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
              	<!--[if mso]>
				<table align="left" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100%;">
				<tr>
				<![endif]-->
			    
				<!--[if mso]>
				<td valign="top" width="600" style="width:600px;">
				<![endif]-->
                <table align="left" border="0" cellpadding="0" cellspacing="0" style="max-width: 100%;min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;" width="100%" class="mcnTextContentContainer">
                    <tbody><tr>
                        
                        <td valign="top" class="mcnTextContent" style="padding: 0px 18px 9px;text-align: center;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #656565;font-family: Helvetica;font-size: 12px;line-height: 150%;">
                        
                            <a href="https://us19.campaign-archive.com/?e=[UNIQID]&amp;u=f810ad07cdd7b094de228a555&amp;id=61528a3c3a" target="_blank" style="mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #656565;font-weight: normal;text-decoration: underline;">View this email in your browser</a>
                        </td>
                    </tr>
                </tbody></table>
				<!--[if mso]>
				</td>
				<![endif]-->
                
				<!--[if mso]>
				</tr>
				</table>
				<![endif]-->
            </td>
        </tr>
    </tbody>
</table></td>
                            </tr>
                            <tr>
                                <td valign="top" id="templateHeader" style="background:#FFFFFF none no-repeat center/cover;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #FFFFFF;background-image: none;background-repeat: no-repeat;background-position: center;background-size: cover;border-top: 0;border-bottom: 0;padding-top: 9px;padding-bottom: 0;"><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnImageBlock" style="min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
    <tbody class="mcnImageBlockOuter">
            <tr>
                <td valign="top" style="padding: 9px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;" class="mcnImageBlockInner">
                    <table align="left" width="100%" border="0" cellpadding="0" cellspacing="0" class="mcnImageContentContainer" style="min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
                        <tbody><tr>
                            <td class="mcnImageContent" valign="top" style="padding-right: 9px;padding-left: 9px;padding-top: 0;padding-bottom: 0;text-align: center;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
                                
                                    
                                        <img align="center" alt="" src="https://mcusercontent.com/f810ad07cdd7b094de228a555/images/ddab4b17-917b-4973-ab47-212030c437db.png" width="564" style="max-width: 1384px;padding-bottom: 0;display: inline !important;vertical-align: bottom;border: 0;height: auto;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;" class="mcnImage">
                                    
                                
                            </td>
                        </tr>
                    </tbody></table>
                </td>
            </tr>
    </tbody>
</table></td>
                            </tr>
                            <tr>
                                <td valign="top" id="templateBody" style="background:#FFFFFF none no-repeat center/cover;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #FFFFFF;background-image: none;background-repeat: no-repeat;background-position: center;background-size: cover;border-top: 0;border-bottom: 2px solid #EAEAEA;padding-top: 0;padding-bottom: 9px;"><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnTextBlock" style="min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
    <tbody class="mcnTextBlockOuter">
        <tr>
            <td valign="top" class="mcnTextBlockInner" style="padding-top: 9px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
              	<!--[if mso]>
				<table align="left" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100%;">
				<tr>
				<![endif]-->
			    
				<!--[if mso]>
				<td valign="top" width="600" style="width:600px;">
				<![endif]-->
                <table align="left" border="0" cellpadding="0" cellspacing="0" style="max-width: 100%;min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;" width="100%" class="mcnTextContentContainer">
                    <tbody><tr>
                        
                        <td valign="top" class="mcnTextContent" style="padding-top: 0;padding-right: 18px;padding-bottom: 9px;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #202020;font-family: Helvetica;font-size: 16px;line-height: 150%;text-align: left;">
                        
                            <h1 style="display: block;margin: 0;padding: 0;color: #202020;font-family: \'Roboto\', \'Helvetica Neue\', Helvetica, Arial, sans-serif;font-size: 26px;font-style: normal;font-weight: bold;line-height: 125%;letter-spacing: normal;text-align: left;"><strong><span style="color:#ff3333">Welcome!</span></strong></h1>
<p style="margin: 10px 0;padding: 0;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #202020;font-family: Helvetica;font-size: 16px;line-height: 150%;text-align: left;">First, we hope you and your loved ones are healthy.<br>
<br>
We launched <strong><span style="color:#330099">People<em>Like</em>You</span>&nbsp;</strong>this Monday and have been pleasantly&nbsp;surprised with how many people have already signed up—thank you for sharing.<br>
<br>
We\'re currently running the matching algorithm and&nbsp;expect to start sending the first round of potential matches this weekend via email. Once you receive an email, please reply whether you\'d like to be connected with the person.<br>
<br>
Your&nbsp;potential matches&nbsp;are&nbsp;based on the values, expectations, and attitudinal factors you indicated in the questionnaire (and notably&nbsp;<em>not</em> on physical appearance—the email&nbsp;you receive of your potential matches will include photos to help you&nbsp;decide&nbsp;who you’d like to meet).<br>
<br>
Our long-term&nbsp;goal is to help you find a great partner, but for now we just hope you meet some really cool people while on lockdown.<br>
<br>
If you know anyone else who you think would be a good fit, we\'d be grateful if you\'d share <a href="http://people-like-you.com/" target="_blank" style="mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #007C89;font-weight: normal;text-decoration: underline;">the survey with them</a>, too.<br>
<br>
If you have any questions check out&nbsp;<a href="http://people-like-you.com/" style="mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #007C89;font-weight: normal;text-decoration: underline;">http://people-like-you.com/</a>&nbsp;or feel free to&nbsp;reach out to <a href="mailto:findpeoplelikeyou@gmail.com" target="_blank" style="mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #007C89;font-weight: normal;text-decoration: underline;">findpeoplelikeyou@gmail.com</a>—we\'d love to hear from you.<br>
      <br>
      Take care and talk soon.<br>
      - C</p>
      
      </td>
      </tr>
      </tbody></table>
      <!--[if mso]>
      </td>
      <![endif]-->
      
      <!--[if mso]>
      </tr>
      </table>
      <![endif]-->
      </td>
      </tr>
      </tbody>
      </table></td>
      </tr>
      <tr>
      <td valign="top" id="templateFooter" style="background:#FAFAFA none no-repeat center/cover;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #FAFAFA;background-image: none;background-repeat: no-repeat;background-position: center;background-size: cover;border-top: 0;border-bottom: 0;padding-top: 9px;padding-bottom: 9px;"><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnFollowBlock" style="min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <tbody class="mcnFollowBlockOuter">
      <tr>
      <td align="center" valign="top" style="padding: 9px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;" class="mcnFollowBlockInner">
      <table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnFollowContentContainer" style="min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <tbody><tr>
      <td align="center" style="padding-left: 9px;padding-right: 9px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <table border="0" cellpadding="0" cellspacing="0" width="100%" style="min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;" class="mcnFollowContent">
      <tbody><tr>
      <td align="center" valign="top" style="padding-top: 9px;padding-right: 9px;padding-left: 9px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <table align="center" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <tbody><tr>
      <td align="center" valign="top" style="mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <!--[if mso]>
      <table align="center" border="0" cellspacing="0" cellpadding="0">
      <tr>
      <![endif]-->
      
      <!--[if mso]>
      <td align="center" valign="top">
      <![endif]-->
      
      
      <table align="left" border="0" cellpadding="0" cellspacing="0" style="display: inline;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <tbody><tr>
      <td valign="top" style="padding-right: 10px;padding-bottom: 9px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;" class="mcnFollowContentItemContainer">
      <table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnFollowContentItem" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <tbody><tr>
      <td align="left" valign="middle" style="padding-top: 5px;padding-right: 10px;padding-bottom: 5px;padding-left: 9px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <table align="left" border="0" cellpadding="0" cellspacing="0" width="" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <tbody><tr>
      
      <td align="center" valign="middle" width="24" class="mcnFollowIconContent" style="mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <a href="http://www.twitter.com/" target="_blank" style="mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><img src="https://cdn-images.mailchimp.com/icons/social-block-v2/color-twitter-48.png" alt="Twitter" style="display: block;border: 0;height: auto;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;" height="24" width="24" class=""></a>
      </td>
      
      
      </tr>
      </tbody></table>
      </td>
      </tr>
      </tbody></table>
      </td>
      </tr>
      </tbody></table>
      
      <!--[if mso]>
      </td>
      <![endif]-->
      
      <!--[if mso]>
      <td align="center" valign="top">
      <![endif]-->
      
      
      <table align="left" border="0" cellpadding="0" cellspacing="0" style="display: inline;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <tbody><tr>
      <td valign="top" style="padding-right: 10px;padding-bottom: 9px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;" class="mcnFollowContentItemContainer">
      <table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnFollowContentItem" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <tbody><tr>
      <td align="left" valign="middle" style="padding-top: 5px;padding-right: 10px;padding-bottom: 5px;padding-left: 9px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <table align="left" border="0" cellpadding="0" cellspacing="0" width="" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <tbody><tr>
      
      <td align="center" valign="middle" width="24" class="mcnFollowIconContent" style="mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <a href="http://www.facebook.com" target="_blank" style="mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><img src="https://cdn-images.mailchimp.com/icons/social-block-v2/color-facebook-48.png" alt="Facebook" style="display: block;border: 0;height: auto;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;" height="24" width="24" class=""></a>
      </td>
      
      
      </tr>
      </tbody></table>
      </td>
      </tr>
      </tbody></table>
      </td>
      </tr>
      </tbody></table>
      
      <!--[if mso]>
      </td>
      <![endif]-->
      
      <!--[if mso]>
      <td align="center" valign="top">
      <![endif]-->
      
      
      <table align="left" border="0" cellpadding="0" cellspacing="0" style="display: inline;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <tbody><tr>
      <td valign="top" style="padding-right: 0;padding-bottom: 9px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;" class="mcnFollowContentItemContainer">
      <table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnFollowContentItem" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <tbody><tr>
      <td align="left" valign="middle" style="padding-top: 5px;padding-right: 10px;padding-bottom: 5px;padding-left: 9px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <table align="left" border="0" cellpadding="0" cellspacing="0" width="" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <tbody><tr>
      
      <td align="center" valign="middle" width="24" class="mcnFollowIconContent" style="mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <a href="http://mailchimp.com" target="_blank" style="mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><img src="https://cdn-images.mailchimp.com/icons/social-block-v2/color-link-48.png" alt="Website" style="display: block;border: 0;height: auto;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;" height="24" width="24" class=""></a>
      </td>
      
      
      </tr>
      </tbody></table>
      </td>
      </tr>
      </tbody></table>
      </td>
      </tr>
      </tbody></table>
      
      <!--[if mso]>
      </td>
      <![endif]-->
      
      <!--[if mso]>
      </tr>
      </table>
      <![endif]-->
      </td>
      </tr>
      </tbody></table>
      </td>
      </tr>
      </tbody></table>
      </td>
      </tr>
      </tbody></table>
      
      </td>
      </tr>
      </tbody>
      </table><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnDividerBlock" style="min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;table-layout: fixed !important;">
      <tbody class="mcnDividerBlockOuter">
      <tr>
      <td class="mcnDividerBlockInner" style="min-width: 100%;padding: 10px 18px 25px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <table class="mcnDividerContent" border="0" cellpadding="0" cellspacing="0" width="100%" style="min-width: 100%;border-top: 2px solid #EEEEEE;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <tbody><tr>
      <td style="mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <span></span>
      </td>
      </tr>
      </tbody></table>
      <!--            
      <td class="mcnDividerBlockInner" style="padding: 18px;">
      <hr class="mcnDividerContent" style="border-bottom-color:none; border-left-color:none; border-right-color:none; border-bottom-width:0; border-left-width:0; border-right-width:0; margin-top:0; margin-right:0; margin-bottom:0; margin-left:0;" />
      -->
      </td>
      </tr>
      </tbody>
      </table><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnTextBlock" style="min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <tbody class="mcnTextBlockOuter">
      <tr>
      <td valign="top" class="mcnTextBlockInner" style="padding-top: 9px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
      <!--[if mso]>
      <table align="left" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100%;">
      <tr>
      <![endif]-->
      
      <!--[if mso]>
      <td valign="top" width="600" style="width:600px;">
      <![endif]-->
      <table align="left" border="0" cellpadding="0" cellspacing="0" style="max-width: 100%;min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;" width="100%" class="mcnTextContentContainer">
      <tbody><tr>
      
      <td valign="top" class="mcnTextContent" style="padding-top: 0;padding-right: 18px;padding-bottom: 9px;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #656565;font-family: Helvetica;font-size: 12px;line-height: 150%;text-align: center;">
      
      <em>Copyright © 2020 People Like You, All rights reserved.</em>
      <br>
      
      <br>
      <br>
      Want to change how you receive these emails?<br>
      You can <a href="https://people-like-you.us19.list-manage.com/profile?u=f810ad07cdd7b094de228a555&amp;id=4b979e0121&amp;e=[UNIQID]" style="mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #656565;font-weight: normal;text-decoration: underline;">update your preferences</a> or <a href="https://people-like-you.us19.list-manage.com/unsubscribe?u=f810ad07cdd7b094de228a555&amp;id=4b979e0121&amp;e=[UNIQID]&amp;c=61528a3c3a" style="mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #656565;font-weight: normal;text-decoration: underline;">unsubscribe from this list</a>.
    <br>
      <br>
      <a href="http://www.mailchimp.com/monkey-rewards/?utm_source=freemium_newsletter&amp;utm_medium=email&amp;utm_campaign=monkey_rewards&amp;aid=f810ad07cdd7b094de228a555&amp;afl=1"><img src="https://cdn-images.mailchimp.com/monkey_rewards/MC_MonkeyReward_15.png" border="0" alt="Email Marketing Powered by Mailchimp" title="Mailchimp Email Marketing" width="139" height="54"></a>
      
      
      </td>
      </tr>
      </tbody></table>
      <!--[if mso]>
      </td>
      <![endif]-->
      
      <!--[if mso]>
      </tr>
      </table>
      <![endif]-->
      </td>
      </tr>
      </tbody>
      </table></td>
      </tr>
      </tbody></table>
      <!--[if (gte mso 9)|(IE)]>
      </td>
      </tr>
      </table>
      <![endif]-->
      <!-- // END TEMPLATE -->
      </td>
      </tr>
      </tbody></table>
      </center>') 
gm_send_message(welcome_email)

# Check Who Has Been Sent Emails Already ----------------------------------

# * Store Who Has Been Sent an Email --------------------------------------

# EDA ---------------------------------------------------------------------
# * Top Referrers ---------------------------------------------------------
df %>%
  group_by(referrer)%>%
  count() %>%
  arrange(desc(n))
df %>%
  group_by(demo_gender)%>%
  count()


# Open Questions ----------------------------------------------------------
# Should working out be a close proxy for physical attractiveness
# How to make sure everyone gets some matches

# Determine Who to Send To ------------------------------------------------
# * Find the Rank of Each Potential Match
ranked_matches <- pref_merged_df %>%
  group_by(preference_user_id) %>%
  arrange(desc(difference),.by_group = TRUE) %>%
  mutate(match_rank=row_number(),
         average_match=median(difference))
# * Find the Rank of Each Potential Match
ranked_matches_male <- male_users_preference %>%
  group_by(preference_user_id) %>%
  arrange(desc(difference),.by_group = TRUE) %>%
  mutate(match_rank=row_number(),
         average_match=median(difference))

ranked_matches_female <- female_users_preference %>%
  group_by(preference_user_id) %>%
  arrange(desc(difference),.by_group = TRUE) %>%
  mutate(match_rank=row_number(),
         average_match=median(difference))

match_dispersion_male <- ranked_matches_male %>%
  group_by(preference_user_id) %>% 
  summarise(match_quantile = list(enframe(quantile(difference, probs=c(0.25,0.5,0.75))))) %>% 
  unnest %>% pivot_wider(names_prefix = "quantile_",names_from = name,values_from = value)

match_dispersion_female <- ranked_matches_female %>%
  group_by(preference_user_id) %>% 
  summarise(match_quantile = list(enframe(quantile(difference, probs=c(0.25,0.5,0.75))))) %>% 
  unnest %>% pivot_wider(names_prefix = "quantile_",names_from = name,values_from = value)

quantile_matches_female <- female_users_preference %>% 
  left_join(match_dispersion_female, by = c("preference_user_id" = "preference_user_id")) %>% 
  mutate(match_tier=case_when(
    difference >= `quantile_75%`~ 1,
    difference >= `quantile_50%`& difference < `quantile_75%` ~ 2,
    difference >= `quantile_25%`& difference < `quantile_50%`~ 3,
    TRUE ~ 4
  ))

quantile_matches_male <- male_users_preference %>% 
  left_join(match_dispersion_male, by = c("preference_user_id" = "preference_user_id")) %>% 
  mutate(match_tier=case_when(
    difference >= `quantile_75%`~ 1,
    difference >= `quantile_50%`& difference < `quantile_75%` ~ 2,
    difference >= `quantile_25%`& difference < `quantile_50%`~ 3,
    TRUE ~ 4
  ))

relative_compatability_table <- quantile_matches_male %>%
  left_join(quantile_matches_female, by=c("preference_user_id"="matching_user_id","matching_user_id"="preference_user_id")) 

short_list_v1 <- relative_compatability_table %>%
  # filter((match_tier.x<3&match_tier.y==1)|(match_tier.x==1&match_tier.y<3)) %>%
  filter((match_tier.x==1&match_tier.y==1)) %>%
  select(preference_user_id,match_tier.x,matching_user_id,match_tier.y)

short_list_v1 %>%
  select(matching_user_id,preference_user_id)%>%
  pivot_longer(cols=everything(),names_to = "not_important",values_to = "user_id") %>%
  arrange(user_id) %>% 
  View()

#MEN NEED at least 2x as many matches

short_list_v2 <- relative_compatability_table %>%
  filter((match_tier.x<3&match_tier.y==1)) %>%
  select(preference_user_id,match_tier.x,matching_user_id,match_tier.y)

short_list_v2_long <- short_list_v2 %>%
  select(matching_user_id,preference_user_id)%>%
  pivot_longer(cols=everything(),names_to = "not_important",values_to = "user_id") %>%
  arrange(user_id) 

short_list_v2_long %>%
  group_by(user_id)%>%
  count(user_id)%>%
  # arrange(desc(n)) %>%
  ggplot(aes(n))+geom_histogram(binwidth = 2)


# Find the Consumer Surplus for each match --------------------------------
## Are you in each other's top quartile?
### https://stackoverflow.com/questions/30488389/using-dplyr-window-functions-to-calculate-percentiles

match_dispersion <- ranked_matches %>%
  group_by(preference_user_id) %>% 
  summarise(match_quantile = list(enframe(quantile(difference, probs=c(0.25,0.5,0.75))))) %>% 
  unnest %>% pivot_wider(names_prefix = "quantile_",names_from = name,values_from = value)

# PROBABLY SHOULD SWITCH FROM QUANTILE TO MEDIAN
quantile_matches <- match_dispersion %>% 
  left_join(master_sheet, by = c("preference_user_id" = "preference_user_id")) %>% 
  mutate(match_tier=case_when(
    difference >= `quantile_75%`~ 1,
    difference >= `quantile_50%`& difference < `quantile_75%` ~ 2,
    difference >= `quantile_25%`& difference < `quantile_50%`~ 3,
    TRUE ~ 4
  ))

#How to tell if you are both in each other's top tier?
quantile_matches %>%
  select(preference_user_id,matching_user_id, match_tier) %>%
  

# * Ty Data Analysis ------------------------------------------------------


pref_merged_df %>%
  filter(difference< -100) %>%
  select(preference_user_id,matching_user_id,difference) %>%
  View()

pref_merged_df %>%
  filter(preference_user_id=='uid00000119') %>%
  ggplot(aes(difference))+geom_histogram() +
  labs(title="",subtitle="",x="",y="",color="",fill="", size="",caption=paste0("Matches from People-Like-You.com"))+
  theme(text=element_text(family = "Roboto"),
        panel.grid.major = element_line(color = "#DAE1E7"),
        panel.background = element_blank(),axis.text = element_text(size = 12),
       # axis.text.x = element_text(margin = margin(t = 5),hjust = 1),#angle=90
        axis.text.x=element_blank(),
        axis.text.y =element_blank(),
        axis.title = element_text (size = 15),
        axis.line = element_line(),
        axis.title.y = element_text(margin = margin(r = 10), hjust = 0.5),
        axis.title.x = element_text(margin = margin(t = 10), hjust = 0.5),
        plot.caption = element_text(size = 8,
                                    margin = margin(t = 10),
                                    color = "#3D4852"), 
        title = element_text (size = 15,margin = margin(b = 10)),
        legend.position = "none") +
  expand_limits(x=0,y=0)
  #scale_x_discrete(breaks=seq(-200,0), limits=c(-200,0),labels = c("Annulment", "Couple Goals"))

# * Joins by Time ---------------------------------------------------------
df %>%
  mutate(date_joined=ymd_hms(date_joined)) %>%
  ggplot(aes(date_joined))+geom_histogram() +
  scale_y_continuous()

# Population Level Matching
master_sheet %>%
  ggplot(aes(difference))+geom_histogram()+
  labs(title="",subtitle="",x="",y="",color="",fill="", size="",caption=paste0("Matches from People-Like-You.com"))+
  theme(text=element_text(family = "Roboto"),
        panel.grid.major = element_line(color = "#DAE1E7"),
        panel.background = element_blank(),axis.text = element_text(size = 12),
        # axis.text.x = element_text(margin = margin(t = 5),hjust = 1),#angle=90
        axis.text.x=element_blank(),
        axis.text.y =element_blank(),
        axis.title = element_text (size = 15),
        axis.line = element_line(),
        axis.title.y = element_text(margin = margin(r = 10), hjust = 0.5),
        axis.title.x = element_text(margin = margin(t = 10), hjust = 0.5),
        plot.caption = element_text(size = 8,
                                    margin = margin(t = 10),
                                    color = "#3D4852"), 
        title = element_text (size = 15,margin = margin(b = 10)),
        legend.position = "none") +
  expand_limits(x=0,y=0)
