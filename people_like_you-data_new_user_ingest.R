# source('people_like_you-data_new_user_ingest.R')

# Check for updated user data ---------------------------------------------
checkForUpdatedUserData <- function(x){
  # TBD
}

# Authorize User ----------------------------------------------------------
authGoogleSheets <- function(x){
  googledrive::drive_auth(use_oob = TRUE)
}

# See the user who is logged in -------------------------------------------
## drive_user()

# Load New Data -----------------------------------------------------------
loadNewUserData <- function(x){
  sheets_auth(token = drive_token())
  x <- read_sheet("1Hp6z3DtakZqR5HzabUINobRbk3I_Ida9F0N8BAYvezE")
  return(x)
}

# * Exclude all but most recent entry -------------------------------------
excludeAllButMostRecentEntryPerUser <- function(x){
  x <- x %>%
    group_by(`Email Address`) %>%
    slice(which.max(Timestamp))
  return(x)
} 

# Exclude Fake Accounts ---------------------------------------------------
excludeFakeAccounts <- function(x){
  exclusion_email_list <- c('linhao.zhang@gmail.com','dodo@gmail.com','me@example.com')
 x <-  x %>%
    filter(!`Email Address` %in% exclusion_email_list)
  return(x)
}

# Exclude Inactive Accounts -----------------------------------------------
excludeInactiveAccounts <- function(x){
  inactive_email_list <- c('turner.mollyk@gmail.com')
  x <-  x %>%
    filter(!`Email Address` %in% inactive_email_list)
  return(x)
}

# Exclude Non-Active Region Accounts -----------------------------------------------
excludeNonactiveRegionAccounts <- function(x){
  nonactive_region_list <- c('South America','Indian subcontinent')
  x <-  x %>%
    filter(!`Please select the region in which you currently reside` %in% nonactive_region_list)
  return(x)
}

excludePeopleWithNoPhotos <- function(x){
  no_photo_list <- c('danielle.harter@ymail.com','lindseyblake2020@gmail.com')
  x <-  x %>%
    filter(!`Email Address` %in% no_photo_list)
  return(x)
}

# Load Existing User Database ---------------------------------------------
loadExistingUserTable <- function(file_name){
  x <- read.csv(file_name)
  x <- x %>%
    select(-X) %>%
    mutate(date_joined=as.POSIXct(date_joined),
           user_id=as.character(user_id))
  return(x)
}

# Check For New Users -----------------------------------------------------
excludePreviousUsers <- function(existing_user_database,potential_new_user_list){
  existing_user_email_check <- existing_user_database %>%
    select(email_address)
  
  verified_new_users <- potential_new_user_list %>%
    filter(!`Email Address`%in% existing_user_email_check$email_address)
  return(verified_new_users)
}

# Make Column Names Legible -----------------------------------------------
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
      imp_fct_attributes_fiveAttributes=`Which of the following characteristics are *MOST* important to you in a partner?                                      [Select UP to 5]`,
      pref_fct_partner_locations=`In which of the following regions are you willing to consider potential partners?`,
      demo_gender=`Please select your gender`,
      demo_birth_year=`Please select your birth year`,
      demo_birth_month=`Please select your birth month`,
      demo_birth_day=`Please select your birth day`,
      demo_first_name=`What is your first name?`,
      demo_last_name=`What is your last name?`,
      demo_height=`How tall are you?`,
      demo_location_region=`Please select the region in which you currently reside`,
      demo_location_country=`Please select the country in which you currently reside`,
      demo_location_state=`Please select the state in which you currently reside`,
      date_joined=Timestamp,
      email_address=`Email Address`,
      referrer=`What is the name of the person who told you (or where did you find out) about this?`,
      prompt_ted_talk=`I could give a TED talk on... (optional)`,
      prompt_mistaken=`Something most people get wrong about me... (optional)`,
      prompt_life_hack=`My best life hack... (optional)`,
      prompt_controversal_opinion=`My most controversial opinion... (optional)`,
      prompt_tile_of_bio=`The title of my biography... (optional)`,
      prompt_never_ever=`Never have I ever... (optional)`,
      prompt_never_again=`One thing I’ll never do again... (optional)`,
      prompt_random_thought=`A random thought I recently had was... (optional)`,
      prompt_weirdest_gift=`The weirdest gift I have given or received... (optional)`,
      prompt_secret_talent=`My secret talent... (optional)`)
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

recodeHeightData <- function(x){
x <- x %>%
  mutate(demo_height=str_replace(demo_height,"\\(~183 cm\\)",'')) %>%
  as_tibble() %>%
  separate(demo_height, c("demo_height_feet", "demo_height_inches"), "([\\ \\'])") %>%
  mutate(demo_height_inches=as.numeric(str_replace(demo_height_inches,'"','')),
         demo_height_feet=as.numeric(demo_height_feet)) %>%
  mutate(demo_height_inches_and_feet=((demo_height_feet*12)+demo_height_inches))
return(x)
}

recodeBirthDateData <- function(x){
  x <-  x %>%
    mutate(demo_birth_month=case_when(demo_birth_month=='January'~1,
                                      demo_birth_month=='February'~2,
                                      demo_birth_month=='March'~3,
                                      demo_birth_month=='April'~4,
                                      demo_birth_month=='May'~5,
                                      demo_birth_month=='June'~6,
                                      demo_birth_month=='July'~7,
                                      demo_birth_month=='August'~8,
                                      demo_birth_month=='September'~9,
                                      demo_birth_month=='October'~10,
                                      demo_birth_month=='November'~11,
                                      demo_birth_month=='December'~12)) %>%
    unite(demo_birthdate_full,c(demo_birth_year,demo_birth_month,demo_birth_day),sep = "-",remove = FALSE) %>%
    mutate(demo_birthdate_full=as.character(demo_birthdate_full)) %>%
    mutate(demo_birthdate_full = lubridate::ymd(demo_birthdate_full),
           demo_age_days =(today()-demo_birthdate_full))
  
  return(x)
}

# new_user_table %>%
#   mutate(demo_birth_month=case_when(demo_birth_month=='January'~1,
#                                     demo_birth_month=='February'~2,
#                                     demo_birth_month=='March'~3,
#                                     demo_birth_month=='April'~4,
#                                     demo_birth_month=='May'~5,
#                                     demo_birth_month=='June'~6,
#                                     demo_birth_month=='July'~7,
#                                     demo_birth_month=='August'~8,
#                                     demo_birth_month=='September'~9,
#                                     demo_birth_month=='October'~10,
#                                     demo_birth_month=='November'~11,
#                                     demo_birth_month=='December'~12)) %>%
#   unite(demo_birthdate_full,c(demo_birth_year,demo_birth_month,demo_birth_day),sep = "-",remove = FALSE) %>%
#   mutate(demo_birthdate_full=as.character(demo_birthdate_full)) %>%
#   mutate(demo_birthdate_full = lubridate::ymd(demo_birthdate_full),
#          demo_age_days =(today()-demo_birthdate_full)) %>%
#   View()

createUserIdsFirstTime<- function(new_user_table){
  # x$user_id <- 1:nrow(x) 
  new_user_table$user_id <- (1:nrow(new_user_table))
  for (i in 1:nrow(new_user_table)){
    if(nchar(new_user_table$user_id[i])==1){
      new_user_table$user_id[i]<- paste0('uid0000000',new_user_table$user_id[i])}
    
    else if(nchar(new_user_table$user_id[i])==2){
      new_user_table$user_id[i]<- paste0('uid000000',new_user_table$user_id[i])
    }
    else if(nchar(new_user_table$user_id[i])==3){
      new_user_table$user_id[i]<- paste0('uid00000',new_user_table$user_id[i])
    }
    else if(nchar(new_user_table$user_id[i])==4){
      new_user_table$user_id[i]<- paste0('uid0000',new_user_table$user_id[i])
    }
    else if(nchar(new_user_table$user_id[i])==5){
      new_user_table$user_id[i]<- paste0('uid000',new_user_table$user_id[i])
    }
    else if(nchar(new_user_table$user_id[i])==6){
      new_user_table$user_id[i]<- paste0('uid00',new_user_table$user_id[i])
    }
    else if(nchar(new_user_table$user_id[i])==7){
      new_user_table$user_id[i]<- paste0('uid0',new_user_table$user_id[i])
    }
    else if(nchar(new_user_table$user_id[i])==8){
      new_user_table$user_id[i]<- paste0('uid',new_user_table$user_id[i])
    }}
  new_user_table <- new_user_table %>% mutate(user_id=as.character(user_id))
  return(new_user_table)
}

createUserIds<- function(existing_user_table,new_user_table){
  # x$user_id <- 1:nrow(x) 
  new_user_table$user_id <- (nrow(existing_user_table)+1):(nrow(existing_user_table)+nrow(new_user_table))
  for (i in 1:nrow(new_user_table)){
    if(nchar(new_user_table$user_id[i])==1){
      new_user_table$user_id[i]<- paste0('uid0000000',new_user_table$user_id[i])}
    
    else if(nchar(new_user_table$user_id[i])==2){
      new_user_table$user_id[i]<- paste0('uid000000',new_user_table$user_id[i])
    }
    else if(nchar(new_user_table$user_id[i])==3){
      new_user_table$user_id[i]<- paste0('uid00000',new_user_table$user_id[i])
    }
    else if(nchar(new_user_table$user_id[i])==4){
      new_user_table$user_id[i]<- paste0('uid0000',new_user_table$user_id[i])
    }
    else if(nchar(new_user_table$user_id[i])==5){
      new_user_table$user_id[i]<- paste0('uid000',new_user_table$user_id[i])
    }
    else if(nchar(new_user_table$user_id[i])==6){
      new_user_table$user_id[i]<- paste0('uid00',new_user_table$user_id[i])
    }
    else if(nchar(new_user_table$user_id[i])==7){
      new_user_table$user_id[i]<- paste0('uid0',new_user_table$user_id[i])
    }
    else if(nchar(new_user_table$user_id[i])==8){
      new_user_table$user_id[i]<- paste0('uid',new_user_table$user_id[i])
    }}
  new_user_table <- new_user_table %>% mutate(user_id=as.character(user_id))
  return(new_user_table)
}

createDistinctAttributeImportanceColumns <- function(x){
  y <- x %>%
    select(user_id,imp_fct_attributes_fiveAttributes) %>%
    separate(imp_fct_attributes_fiveAttributes,c("imp_attribute_1","imp_attribute_2","imp_attribute_3","imp_attribute_4","imp_attribute_5","imp_attribute_6","imp_attribute_7","imp_attribute_8","imp_attribute_9","imp_attribute_10","imp_attribute_11","imp_attribute_12","imp_attribute_13","imp_attribute_14","imp_attribute_15","imp_attribute_16"),sep = "([\\,\\?\\:])", remove = TRUE) %>%
    pivot_longer(-user_id) %>%
    filter(!is.na(value)) %>%
    filter(name!="email_address")
  
  y$importance <- as.numeric(rep(5,nrow(y)))
  
  y$value <- str_trim(y$value)
  
  y <- y %>%
    mutate(value = str_replace(value, "Empathtic", "Empathetic")) %>%
    mutate(value = str_replace(value, "Emotionally in-tune", "Intuitive")) %>%
    mutate(value = str_replace(value, "Empathtic", "Empathetic")) %>%
    mutate(value = str_replace(value, "Responsibile", "Responsible")) %>%
    mutate(value = str_replace(value, " ", "_")) %>%
    mutate(value = str_replace(value, "-", "_"))
  
  y <- y %>%
    group_by(name)%>%
    mutate(rn = row_number()) %>% 
    pivot_wider(names_from="value",values_from = "importance",names_prefix = "imp_attributes_") %>%
    ungroup()
  
  y <- y %>%
    setNames(tolower(names(.))) %>%
    select(-name,-rn)
  
  
  y <- y %>%
    pivot_longer(-user_id) %>%
    filter(!is.na(value)) %>%
    pivot_wider(names_from="name",values_from = "value") %>% unnest()
  y <- y %>%
    replace(is.na(.), 0) 
  
  x <- x %>%
    left_join(y) 
  
  x <- x %>% select(starts_with("imp_attributes_"),everything()) %>%
    select(starts_with("imp_values_"),everything()) %>%
    as_tibble()
  return(x)
}


createDistinctAttributeImportanceColumns <- function(x){
  x %>%
  return(x)
}

createUnifiedPromptField <- function(x){
  y <- NULL
  y$prompt_unified <- x %>%
    mutate(prompt_ted_talk=map_chr(prompt_ted_talk,~str_c("<b>I could give a TED talk on...</b><br>",.,"<br><br><br>"))) %>%
    mutate(prompt_mistaken=map_chr(prompt_mistaken,~str_c("<b>Something most people get wrong about me...</b><br>",.,"<br><br><br>"))) %>%
    mutate(prompt_life_hack=map_chr(prompt_life_hack,~str_c("<b>My best life hack...</b><br>",.,"<br><br><br>"))) %>%
    mutate(prompt_controversal_opinion=map_chr(prompt_controversal_opinion,~str_c("<b>My most controversial opinion...</b><br>",.,"<br><br><br>"))) %>%
    mutate(prompt_tile_of_bio=map_chr(prompt_tile_of_bio,~str_c("<b>The title of my biography...</b><br>",.,"<br><br><br>"))) %>%
    mutate(prompt_never_ever=map_chr(prompt_never_ever,~str_c("<b>Never have I ever...</b><br>",.,"<br><br><br>"))) %>%
    mutate(prompt_never_again=map_chr(prompt_never_again,~str_c("<b>One thing I’ll never do again...</b><br>",.,"<br><br><br>"))) %>%
    mutate(prompt_random_thought=map_chr(prompt_random_thought,~str_c("<b>A random thought I recently had was...</b><br>",.,"<br><br><br>"))) %>%
    mutate(prompt_weirdest_gift=map_chr(prompt_weirdest_gift,~str_c("<b>The weirdest gift I have given or received...</b><br>",.,"<br><br><br>"))) %>%
    mutate(prompt_secret_talent=map_chr(prompt_secret_talent,~str_c("<b>My secret talent...</b><br>",.,"<br><br><br>"))) %>%
    select(prompt_ted_talk,prompt_mistaken,prompt_life_hack,prompt_controversal_opinion,prompt_tile_of_bio,prompt_never_ever,prompt_never_again,prompt_random_thought,prompt_weirdest_gift,prompt_secret_talent) %>%
    unite("prompt_unified",prompt_ted_talk,prompt_mistaken,prompt_life_hack,prompt_controversal_opinion,prompt_tile_of_bio,prompt_never_ever,prompt_never_again,prompt_random_thought,prompt_weirdest_gift,prompt_secret_talent,sep = "") %>%
    mutate(prompt_unified=ifelse(prompt_unified=='NANANANANANANA','NA',
                                 paste0('<h2>Get to know them a bit better</h2>',prompt_unified))) %>%
    mutate(prompt_unified=str_replace_all(prompt_unified,"NA","")) %>%
    as.list()
  
  x <- cbind(x,y)
  return(x)
}

# new_user_table <- new_user_table %>%
#   select(-prompt_unified)
# 
# x <- new_user_table %>%
#   mutate(prompt_ted_talk=map_chr(prompt_ted_talk,~str_c("<b>I could give a TED talk on...</b><br>",.,"<br><br><br>"))) %>%
#   mutate(prompt_mistaken=map_chr(prompt_mistaken,~str_c("<b>Something most people get wrong about me...</b><br>",.,"<br><br><br>"))) %>%
#   mutate(prompt_life_hack=map_chr(prompt_life_hack,~str_c("<b>My best life hack...</b><br>",.,"<br><br><br>"))) %>%
#   mutate(prompt_controversal_opinion=map_chr(prompt_controversal_opinion,~str_c("<b>My most controversial opinion...</b><br>",.,"<br><br><br>"))) %>%
#   mutate(prompt_tile_of_bio=map_chr(prompt_tile_of_bio,~str_c("<b>The title of my biography...</b><br>",.,"<br><br><br>"))) %>%
#   mutate(prompt_never_ever=map_chr(prompt_never_ever,~str_c("<b>Never have I ever...</b><br>",.,"<br><br><br>"))) %>%
#   mutate(prompt_never_again=map_chr(prompt_never_again,~str_c("<b>One thing I’ll never do again...</b><br>",.,"<br><br><br>"))) %>%
#   mutate(prompt_random_thought=map_chr(prompt_random_thought,~str_c("<b>A random thought I recently had was...</b><br>",.,"<br><br><br>"))) %>%
#   mutate(prompt_weirdest_gift=map_chr(prompt_weirdest_gift,~str_c("<b>The weirdest gift I have given or received...</b><br>",.,"<br><br><br>"))) %>%
#   mutate(prompt_secret_talent=map_chr(prompt_secret_talent,~str_c("<b>My secret talent...</b><br>",.,"<br><br><br>"))) %>%
#   select(prompt_ted_talk,prompt_mistaken,prompt_life_hack,prompt_controversal_opinion,prompt_tile_of_bio,prompt_never_ever,prompt_never_again,prompt_random_thought,prompt_weirdest_gift,prompt_secret_talent) %>%
#   unite("prompt_unified",prompt_ted_talk,prompt_mistaken,prompt_life_hack,prompt_controversal_opinion,prompt_tile_of_bio,prompt_never_ever,prompt_never_again,prompt_random_thought,prompt_weirdest_gift,prompt_secret_talent,sep = "") %>%
#   mutate(prompt_unified=ifelse(prompt_unified=='NANANANANANANA','NA',
#                                paste0('<h2>Get to know them a bit better</h2>',prompt_unified))) %>%
#   mutate(prompt_unified=str_replace_all(prompt_unified,"NA","")) %>%
#   as.list()
# 
# new_user_table <- cbind(new_user_table,x)

# Recode Data As Numeric --------------------------------------------------
recodeDataAsNumeric <- function(x){
  x <- x %>% mutate_at(vars(starts_with(c("pos_attributes",'pos_values','imp_values','imp_attributes','imp_culture'))),as.numeric)
  return(x)
}

mergeNewAndExistingUsers <- function(x,y){
  z <- rbind(y,x)
  return(z)
}

saveNewUserData <- function(x){
  write.csv(x,paste0('user_table/user_table_',today(),'.csv'))
  write.csv(x,'user_table.csv')
}

createGenderTable <- function(data_frame,gender_user_table,gender){
  gender_user_table <- NULL
  for(i in 1:nrow(data_frame)){
  if(data_frame$demo_gender[i]==gender){
    gender_user_table <- rbind(gender_user_table,data_frame[i,])
  }}
  return(gender_user_table)
}

createGenderTableSimple <- function(data_frame,gender){
  x <- NULL
  for(i in 1:nrow(data_frame)){
    if(data_frame$demo_gender[i]==gender){
      x <- rbind(x,data_frame[i,])
    }}
  return(x)
}

colnames(new_male_users)

# Calculate absolute difference between desires and expectations ----------
calculateUserExpectations <- function(x){
  x$user_expectations <- rep(0,nrow(x))
  for(rf in 1:nrow(x)){  
    for(i in 1:25){
      x$user_expectations[rf] <- as.numeric(x$user_expectations[rf] + x[rf,i]^2)
    }}
  return(x)
}

calculateUserSelfEvaluation <- function(x){
  x$total_self_evaluation <- rep(0,nrow(x))
  for(rf in 1:nrow(x)){  
    for(i in 26:50){
      x$total_self_evaluation[rf] <- as.numeric(x$total_self_evaluation[rf] + x[rf,i]^2)
    }}
  return(x)
}

colnames(new_user_table)
str(new_user_table)

loadExistingGenderData <- function(x){
  x <- read.csv(x)
  return(x)
}

saveMaleUserData <- function(x){
  write.csv(x,paste0('user_table/existing_male_user_data_',today(),'.csv'))
  write.csv(x,'existing_male_user_data.csv')
}
saveFemaleUserData <- function(x){
  write.csv(x,paste0('user_table/existing_female_user_data_',today(),'.csv'))
  write.csv(x,'existing_female_user_data.csv')
}



loadExistingDifferenceDataMale <- function(x){
  x <- read.csv('existing_female_users_preference.csv')
  return(x)
}
loadExistingDifferenceDataFemale <- function(x){
  x <- read.csv('existing_female_users_preference.csv')
  return(x)
}
