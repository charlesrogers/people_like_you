# source('people_like_you-data_prep.R')

legibleColumnNames <- function(x){
 x <-  x %>%
    select(
      pos_values_selfless=`How well do each of the following statements describe you? [I am deeply concerned with the needs of others]`,
      pos_values_curious=`How well do each of the following statements describe you? [I am eager to learn new things]`,
      pos_values_fun=`How well do each of the following statements describe you? [I actively seek amusement and fun]`,
      pos_values_ambition=`How well do each of the following statements describe you? [I have a strong determination to achieve success]`,
      pos_values_security=`How well do each of the following statements describe you? [I try to avoid potentially risky situations]`,
      pos_values_selfimprovement=`How well do each of the following statements describe you? [I consistently focus on my own improvement]`,
      pos_values_traditional=`How well do each of the following statements describe you? [I tend to hold traditional attitudes and values]`,
      pos_attributes_logical=`How well do each of the following statements describe you? [I tend to approach problems in a rational manner]`,
      pos_attributes_intuitive=`How well do each of the following statements describe you? [I usually listen to my instincts when making a decision]`,
      pos_attributes_agreeable=`How well do each of the following statements describe you? [People would describe me as being pleasant to be around]`,
      pos_attributes_empathetic=`How well do each of the following statements describe you? [I deeply understand others' points of view and feelings]`,
      pos_attributes_confident=`How well do each of the following statements describe you? [I am typically self-assured in my decisions]`,
      pos_attributes_patient=`How well do each of the following statements describe you? [I usually tolerate delays or trouble without getting upset]`,
      pos_attributes_emotional_maturity=`How well do each of the following statements describe you? [I always understand and manage my emotions]`,
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
      imp_culture_children=`How important are the following to you when considering a potential partner? [That my partner wants to have children]`,
      imp_culture_breadwinner=`How important are the following to you when considering a potential partner? [That the male be the primary provider]`,
      imp_culture_homemaker=`How important are the following to you when considering a potential partner? [That the female partner stay at home while any children are not yet in school]`,
      imp_culture_active=`How important are the following to you when considering a potential partner? [That your partner be an active member of the Church of Jesus Christ of Latter-day Saints]`,
      imp_culture_mutual_interests=`How important are the following to you when considering a potential partner? [That you and your partner share hobbies or interests]`,
      imp_culture_nonTraditional=`How important are the following to you when considering a potential partner? [That your partner be okay with non-traditional interpretations of the commandments]`,
      imp_culture_location=`How important are the following to you when considering a potential partner? [That you settle down in a particular location? (e.g live near your family)]`,
      imp_values_selfless=`How important are the following when considering a potential partner?  [Selfless]`,
      imp_values_curious=`How important are the following when considering a potential partner?  [Curious]`,
      imp_values_fun=`How important are the following when considering a potential partner?  [Fun]`,
      imp_values_ambition=`How important are the following when considering a potential partner?  [Ambitious]`,
      imp_values_security=`How important are the following when considering a potential partner?  [Risk-averse]`,
      imp_values_selfimprovement=`How important are the following when considering a potential partner?  [Self-improvement focused]`,
      imp_values_traditional=`How important are the following when considering a potential partner?  [Traditional]`,
      imp_values_physical_attraction=`How important are the following when considering a potential partner?  [Physical attractiveness]`,
      # imp_attributes_logical=`How well do each of the following statements describe you? [I tend to approach problems in a rational manner]`,
      # imp_attributes_emotionally_in_tune=`How well do each of the following statements describe you? [I usually listen to my instincts when making a decision]`,
      # imp_attributes_agreeable=`How well do each of the following statements describe you? [People would describe me as being pleasant to be around]`,
      # imp_attributes_empathetic=`How well do each of the following statements describe you? [I deeply understand others' points of view and feelings]`,
      # imp_attributes_confident=`How well do each of the following statements describe you? [I am typically self-assured in my decisions]`,
      # imp_attributes_patient=`How well do each of the following statements describe you? [I usually tolerate delays or trouble without getting upset]`,
      # imp_attributes_emotionally_mature=`How well do each of the following statements describe you? [I always understand and manage my emotions]`,
      # imp_attributes_responsible=`How well do each of the following statements describe you? [I always fulfill my commitments]`,
      # imp_attributes_honest=`How well do each of the following statements describe you? [I tell the truth, even when inconvenient]`,
      # imp_attributes_spontaneous=`How well do each of the following statements describe you? [I tend to follow my impulses without deliberating too much first]`,
      # imp_attributes_flexible=`How well do each of the following statements describe you? [I am willing to change or compromise my wishes and plans]`,
      # imp_attributes_creative=`How well do each of the following statements describe you? [People would describe me as having a strong sense of imagination]`,
      # imp_attributes_forgiving=`How well do each of the following statements describe you? [I tend to quickly release feelings of resentment towards others]`,
      # imp_attributes_optimistic=`How well do each of the following statements describe you? [I believe that things are good and will generally work out]`,
      # imp_attributes_calm=`How well do each of the following statements describe you? [I tend to remain relaxed despite troubling circumstances]`,
      # imp_attributes_extroverted=`How well do each of the following statements describe you? [I thrive in social situations]`,
      imp_fct_attributes_fiveAttributes=`Which of the following characteristics are *MOST* important to you in a partner?                                      [Select UP to 5]`,
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
  return(x)
}


# Recode Likert Data ------------------------------------------------------
recodeLikertDataForNewUsers <- function(x){
   for(r in 1:ncol(x)){
    for(c in 1:nrow(x)){
      if(x[c,r] %in% c('Extremely important','Describes me extremely well')){
        x[c,r] <- 5}
      else if(x[c,r] %in% c('Very important','Describes me well')){
        x[c,r] <-4}
      else if(x[c,r] %in% c('Moderately important','Moderately describes me',"Important")){
        x[c,r] <-3}
      else if(x[c,r] %in% c('Not that important','Somewhat describes me','Somewhat describes')){
        x[c,r] <-2}
      else if(x[c,r] %in% c('Not at all important','Does not describe me at all')){
        x[c,r] <-1}
      else if(x[c,r] %in% c('I would prefer that they not')){
        x[c,r] <--10}
    }}
  return(x)
}

# Create User IDs ---------------------------------------------------------
#HOW DO WE MAKE SURE NOT TO mess with the previous ones?

# nrow(existing_user_table)+nrow(new_users_column_names)
createUserIds <- function(x,existing_user_table,new_user_table){
  # x$user_id <- 1:nrow(x) 
  x$user_id <- (nrow(existing_user_table)+1):(nrow(existing_user_table)+nrow(new_user_table))
  for (i in 1:nrow(x)){
    if(nchar(x$user_id[i])==1){
      x$user_id[i]<- paste0('uid0000000',x$user_id[i])}
    
    else if(nchar(x$user_id[i])==2){
      x$user_id[i]<- paste0('uid000000',x$user_id[i])
    }
    else if(nchar(x$user_id[i])==3){
      x$user_id[i]<- paste0('uid00000',x$user_id[i])
    }
    else if(nchar(x$user_id[i])==4){
      x$user_id[i]<- paste0('uid0000',x$user_id[i])
    }
    else if(nchar(x$user_id[i])==5){
      x$user_id[i]<- paste0('uid000',x$user_id[i])
    }
    else if(nchar(x$user_id[i])==6){
      x$user_id[i]<- paste0('uid00',x$user_id[i])
    }
    else if(nchar(x$user_id[i])==7){
      x$user_id[i]<- paste0('uid0',x$user_id[i])
    }
    else if(nchar(x$user_id[i])==8){
      x$user_id[i]<- paste0('uid',x$user_id[i])
    }}
  return(x)
}

# df$user_id <- 1:nrow(df) 
# 
# for (i in 1:nrow(df)){
#   if(nchar(df$user_id[i])==1){
#     df$user_id[i]<- paste0('uid0000000',df$user_id[i])}
#   
#   else if(nchar(df$user_id[i])==2){
#     df$user_id[i]<- paste0('uid000000',df$user_id[i])
#   }
#   else if(nchar(df$user_id[i])==3){
#     df$user_id[i]<- paste0('uid00000',df$user_id[i])
#   }
#   else if(nchar(df$user_id[i])==4){
#     df$user_id[i]<- paste0('uid0000',df$user_id[i])
#   }
#   else if(nchar(df$user_id[i])==5){
#     df$user_id[i]<- paste0('uid000',df$user_id[i])
#   }
#   else if(nchar(df$user_id[i])==6){
#     df$user_id[i]<- paste0('uid00',df$user_id[i])
#   }
#   else if(nchar(df$user_id[i])==7){
#     df$user_id[i]<- paste0('uid0',df$user_id[i])
#   }
#   else if(nchar(df$user_id[i])==8){
#     df$user_id[i]<- paste0('uid',df$user_id[i])
#   }}

# # Create IMP for ATTRIBUTES -----------------------------------------------
# importance_attributes <- new_users_column_names %>%
#   select(user_id,imp_fct_attributes_fiveAttributes) %>%
#   separate(imp_fct_attributes_fiveAttributes,c("imp_attribute_1","imp_attribute_2","imp_attribute_3","imp_attribute_4","imp_attribute_5","imp_attribute_6","imp_attribute_7","imp_attribute_8","imp_attribute_9","imp_attribute_10","imp_attribute_11","imp_attribute_12","imp_attribute_13","imp_attribute_14","imp_attribute_15","imp_attribute_16"),sep = "([\\,\\?\\:])", remove = TRUE) %>%
#   pivot_longer(-user_id) %>%
#   filter(!is.na(value)) %>%
#   filter(name!="email_address")
# 
# importance_attributes <- df %>%
#   select(user_id,imp_fct_attributes_fiveAttributes) %>%
#   separate(imp_fct_attributes_fiveAttributes,c("imp_attribute_1","imp_attribute_2","imp_attribute_3","imp_attribute_4","imp_attribute_5","imp_attribute_6","imp_attribute_7","imp_attribute_8","imp_attribute_9","imp_attribute_10","imp_attribute_11","imp_attribute_12","imp_attribute_13","imp_attribute_14","imp_attribute_15","imp_attribute_16"),sep = "([\\,\\?\\:])", remove = TRUE) %>%
#   pivot_longer(-user_id) %>%
#   filter(!is.na(value)) %>%
#   filter(name!="email_address")
# 
# importance_attributes$importance <- as.numeric(rep(5,nrow(importance_attributes)))
# 
# importance_attributes$value <- str_trim(importance_attributes$value)
# 
# merge_importance_attributes <- importance_attributes %>%
#   mutate(value = str_replace(value, "Empathtic", "Empathetic")) %>%
#   mutate(value = str_replace(value, "Emotionally in-tune", "Intuitive")) %>%
#   mutate(value = str_replace(value, "Empathtic", "Empathetic")) %>%
#   mutate(value = str_replace(value, "Responsibile", "Responsible")) %>%
#   mutate(value = str_replace(value, " ", "_")) %>%
#   mutate(value = str_replace(value, "-", "_")) %>%
#   pivot_wider(names_from="value",values_from = "importance",names_prefix = "imp_attributes_") %>%
#   setNames(tolower(names(.))) %>%
#   select(-name)
# 
# merge_importance_attributes <- merge_importance_attributes %>%
#   pivot_longer(-user_id) %>%
#   filter(!is.na(value)) %>%
#   pivot_wider(names_from="name",values_from = "value") %>%
#   replace(is.na(.), 0)
# 
# df <- df %>%
#   left_join(merge_importance_attributes)
# 
# df <- df %>% select(starts_with("imp_attributes_"),everything()) %>%
#   select(starts_with("imp_values_"),everything())

# View(colnames(df))
write.csv(df,paste0('user_table/df_',today(),'.csv'))
write.csv(df,'user_table.csv')


# Recode Data As Numeric --------------------------------------------------
recodeDataAsNumeric <- function(x){
  x <- x %>% mutate_at(vars(starts_with(c("pos_attributes",'pos_values','imp_values','imp_attributes','imp_culture'))),as.numeric)
  return(x)
}
