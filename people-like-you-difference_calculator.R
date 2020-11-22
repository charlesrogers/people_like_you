source('people_like_you-difference_calculator.R')

# calculateUserDifference <- function(new_preferring_users,new_matching_users,exsiting_matching_users,matching_users_existing_preference_data){
#   
#   compareUsers <- function(evaluating_user,matching_users){
#     x <- NULL
#     for(wr in 1:nrow(evaluating_user)){
#       for(mr in 1:nrow(matching_users)){
#         x <- rbind(x,cbind((matching_users$pos_values_selfless[mr]-evaluating_user$imp_values_selfless[wr])*evaluating_user$imp_values_selfless[wr],
#                            (matching_users$pos_values_curious[mr]- evaluating_user$imp_values_curious[wr])*evaluating_user$imp_values_curious[wr],
#                            (matching_users$pos_values_fun[mr]-evaluating_user$imp_values_fun[wr])*evaluating_user$imp_values_fun[wr],
#                            (matching_users$pos_values_ambition[mr]-evaluating_user$imp_values_ambition[wr])*evaluating_user$imp_values_ambition[wr],
#                            (matching_users$pos_values_security[mr]-evaluating_user$imp_values_security[wr])*evaluating_user$imp_values_security[wr],
#                            (matching_users$pos_values_selfimprovement[mr]-evaluating_user$imp_values_selfimprovement[wr])*evaluating_user$imp_values_selfimprovement[wr],
#                            (matching_users$pos_values_traditional[mr]-evaluating_user$imp_values_traditional[wr])*evaluating_user$imp_values_traditional[wr],
#                            (matching_users$pos_attributes_logical[mr]-evaluating_user$imp_attributes_logical[wr])*evaluating_user$imp_attributes_logical[wr],
#                            (matching_users$pos_attributes_intuitive[mr]-evaluating_user$imp_attributes_intuitive[wr])*evaluating_user$imp_attributes_intuitive[wr],
#                            (matching_users$pos_attributes_agreeable[mr]-evaluating_user$imp_attributes_agreeable[wr])*evaluating_user$imp_attributes_agreeable[wr],
#                            (matching_users$pos_attributes_empathetic[mr]-evaluating_user$imp_attributes_empathetic[wr])*evaluating_user$imp_attributes_empathetic[wr],
#                            (matching_users$pos_attributes_confident[mr]-evaluating_user$imp_attributes_confident[wr])*evaluating_user$imp_attributes_confident[wr],
#                            (matching_users$pos_attributes_patient[mr]-evaluating_user$imp_attributes_patient[wr])*evaluating_user$imp_attributes_patient[wr],
#                            (matching_users$pos_attributes_emotional_maturity[mr]-evaluating_user$imp_attributes_emotional_maturity[wr])*evaluating_user$imp_attributes_emotional_maturity[wr],
#                            (matching_users$pos_attributes_responsible[mr]-evaluating_user$imp_attributes_responsible[wr])*evaluating_user$imp_attributes_responsible[wr],
#                            (matching_users$pos_attributes_honest[mr]-evaluating_user$imp_attributes_honest[wr])*evaluating_user$imp_attributes_honest[wr],
#                            (matching_users$pos_attributes_spontaneous[mr]-evaluating_user$imp_attributes_spontaneous[wr])*evaluating_user$imp_attributes_spontaneous[wr],
#                            (matching_users$pos_attributes_flexible[mr]-evaluating_user$imp_attributes_flexible[wr])*evaluating_user$imp_attributes_flexible[wr],
#                            (matching_users$pos_attributes_creative[mr]-evaluating_user$imp_attributes_creative[wr])*evaluating_user$imp_attributes_creative[wr],
#                            (matching_users$pos_attributes_forgiving[mr]-evaluating_user$imp_attributes_forgiving[wr])*evaluating_user$imp_attributes_forgiving[wr],
#                            (matching_users$pos_attributes_optimistic[mr]-evaluating_user$imp_attributes_optimistic[wr])*evaluating_user$imp_attributes_optimistic[wr],
#                            (matching_users$pos_attributes_calm[mr]-evaluating_user$imp_attributes_calm[wr])*evaluating_user$imp_attributes_calm[wr],
#                            (matching_users$pos_attributes_extroverted[mr]-evaluating_user$imp_attributes_extroverted[wr])*evaluating_user$imp_attributes_extroverted[wr],
#                            (matching_users$pos_attributes_openminded[mr]-evaluating_user$imp_attributes_openminded[wr])*evaluating_user$imp_attributes_openminded[wr],
#                            if_else(matching_users$imp_culture_children[mr]==-10&(evaluating_user$imp_culture_children[wr]==5|evaluating_user$imp_culture_children[wr]==4),0,1),
#                            if_else(matching_users$imp_culture_breadwinner[mr]==-10&(evaluating_user$imp_culture_breadwinner[wr]==5|evaluating_user$imp_culture_breadwinner[wr]==4),0,1),
#                            if_else(matching_users$imp_culture_homemaker[mr]==-10&(evaluating_user$imp_culture_homemaker[wr]==5|evaluating_user$imp_culture_homemaker[wr]==4),0,1),
#                            if_else(matching_users$imp_culture_active[mr]==-10&(evaluating_user$imp_culture_active[wr]==5|evaluating_user$imp_culture_active[wr]==4),0,1),
#                            if_else(matching_users$imp_culture_nonTraditional[mr]==-10&(evaluating_user$imp_culture_nonTraditional[wr]==5|evaluating_user$imp_culture_nonTraditional[wr]==4),0,1),
#                            if_else(matching_users$imp_culture_location[mr]==-10&(evaluating_user$imp_culture_location[wr]==5|evaluating_user$imp_culture_location[wr]==4),0,1),
#                            if_else(matching_users$imp_culture_mutual_interests[mr]==-10&(evaluating_user$imp_culture_mutual_interests[wr]==5|evaluating_user$imp_culture_mutual_interests[wr]==4),0,1),
#                            evaluating_user$user_id[wr],
#                            matching_users$user_id[mr],
#                            evaluating_user$total_expectations[wr]))
#       }}
#     return(x)
#   }
#    
#   new_users_by_new_users <- compareUsers(new_preferring_users,new_matching_users)
#   new_users_by_existing_users <- compareUsers(new_preferring_users,exsiting_matching_users)
#   one_gender_merged_user_preferences_NEW <- rbind(new_users_by_new_users,new_users_by_existing_users)
#   
#   one_gender_merged_user_preferences_NEW <- one_gender_merged_user_preferences_NEW %>%
#     as_tibble() %>%
#     rename(diff_value_selfless=V1,
#            diff_value_curious=V2,
#            diff_value_fun=V3,
#            diff_value_ambition=V4,
#            diff_value_security=V5,
#            diff_value_selfImprovement=V6,
#            diff_value_traditional=V7,
#            diff_attribute_logical=V8,
#            diff_attribute_intuitive=V9,
#            diff_attribute_agreeable=V10,
#            diff_attribute_empathetic=V11,
#            diff_attribute_confident=V12,
#            diff_attribute_patient=V13,
#            diff_attribute_emotional_maturity=V14,
#            diff_attribute_responsible=V15,
#            diff_attribute_honest=V16,
#            diff_attribute_spontaneous=V17,
#            diff_attribute_flexible=V18,
#            diff_attribute_creative=V19,
#            diff_attribute_forgiving=V20,
#            diff_attribute_optimistic=V21,
#            diff_attribute_calm=V22,
#            diff_attribute_extroverted=V23,
#            diff_attribute_openminded=V24,
#            diff_culture_children=V25,
#            diff_culture_breadwinner=V26,
#            diff_culture_homemaker=V27,
#            diff_culture_active=V28,
#            diff_culture_nonTraditional=V29,
#            diff_culture_location=V30,
#            diff_culture_mutualInterests=V31,
#            preference_user_id=V32,
#            matching_user_id=V33,
#            preference_user_expectations=V34
#     )
#   # x <- x %>%
#   # mutate_at(vars(-preference_user_id, -matching_user_id), as.numeric)
#   # 
#   # x$difference <- rep(0,nrow(x))
#   # 
#   # #Calculate male user total diff
#   # for(rf in 1:nrow(x)){
#   #   for(i in 1:23){
#   #     if(x[rf,i]<0)
#   #       x$difference[rf] <- x$difference[rf] + x[rf,i]
#   #   }}
#   one_gender_merged_user_preferences_ALL <- rbind(one_gender_merged_user_preferences_NEW,matching_users_existing_preference_data)
#   return(one_gender_merged_user_preferences_ALL)
# }



calculateUserDifferenceSimple <- function(prefering_party,matching_party){
  x <- NULL
  for(wr in 1:nrow(prefering_party)){
    for(mr in 1:nrow(matching_party)){
      x <- rbind(x,cbind((matching_party$pos_values_selfless[mr]-prefering_party$imp_values_selfless[wr])*prefering_party$imp_values_selfless[wr],
                         (matching_party$pos_values_curious[mr]-prefering_party$imp_values_curious[wr])*prefering_party$imp_values_curious[wr],
                         (matching_party$pos_values_fun[mr]-prefering_party$imp_values_fun[wr])*prefering_party$imp_values_fun[wr],
                         (matching_party$pos_values_ambition[mr]-prefering_party$imp_values_ambition[wr])*prefering_party$imp_values_ambition[wr],
                         (matching_party$pos_values_security[mr]-prefering_party$imp_values_security[wr])*prefering_party$imp_values_security[wr],
                         (matching_party$pos_values_selfimprovement[mr]-prefering_party$imp_values_selfimprovement[wr])*prefering_party$imp_values_selfimprovement[wr],
                         (matching_party$pos_values_traditional[mr]-prefering_party$imp_values_traditional[wr])*prefering_party$imp_values_traditional[wr],
                         (matching_party$pos_attributes_logical[mr]-prefering_party$imp_attributes_logical[wr])*prefering_party$imp_attributes_logical[wr],
                         (matching_party$pos_attributes_intuitive[mr]-prefering_party$imp_attributes_intuitive[wr])*prefering_party$imp_attributes_intuitive[wr],
                         (matching_party$pos_attributes_agreeable[mr]-prefering_party$imp_attributes_agreeable[wr])*prefering_party$imp_attributes_agreeable[wr],
                         (matching_party$pos_attributes_empathetic[mr]-prefering_party$imp_attributes_empathetic[wr])*prefering_party$imp_attributes_empathetic[wr],
                         (matching_party$pos_attributes_confident[mr]-prefering_party$imp_attributes_confident[wr])*prefering_party$imp_attributes_confident[wr],
                         (matching_party$pos_attributes_patient[mr]-prefering_party$imp_attributes_patient[wr])*prefering_party$imp_attributes_patient[wr],
                         (matching_party$pos_attributes_emotional_maturity[mr]-prefering_party$imp_attributes_emotional_maturity[wr])*prefering_party$imp_attributes_emotional_maturity[wr],
                         (matching_party$pos_attributes_responsible[mr]-prefering_party$imp_attributes_responsible[wr])*prefering_party$imp_attributes_responsible[wr],
                         (matching_party$pos_attributes_honest[mr]-prefering_party$imp_attributes_honest[wr])*prefering_party$imp_attributes_honest[wr],
                         (matching_party$pos_attributes_spontaneous[mr]-prefering_party$imp_attributes_spontaneous[wr])*prefering_party$imp_attributes_spontaneous[wr],
                         (matching_party$pos_attributes_flexible[mr]-prefering_party$imp_attributes_flexible[wr])*prefering_party$imp_attributes_flexible[wr],
                         (matching_party$pos_attributes_creative[mr]-prefering_party$imp_attributes_creative[wr])*prefering_party$imp_attributes_creative[wr],
                         (matching_party$pos_attributes_forgiving[mr]-prefering_party$imp_attributes_forgiving[wr])*prefering_party$imp_attributes_forgiving[wr],
                         (matching_party$pos_attributes_optimistic[mr]-prefering_party$imp_attributes_optimistic[wr])*prefering_party$imp_attributes_optimistic[wr],
                         (matching_party$pos_attributes_calm[mr]-prefering_party$imp_attributes_calm[wr])*prefering_party$imp_attributes_calm[wr],
                         (matching_party$pos_attributes_extroverted[mr]-prefering_party$imp_attributes_extroverted[wr])*prefering_party$imp_attributes_extroverted[wr],
                         (matching_party$pos_attributes_openminded[mr]-prefering_party$imp_attributes_openminded[wr])*prefering_party$imp_attributes_openminded[wr],
                         if_else(matching_party$imp_culture_children[mr]==-10&(prefering_party$imp_culture_children[wr]==5|prefering_party$imp_culture_children[wr]==4),0,1),
                         if_else(matching_party$imp_culture_breadwinner[mr]==-10&(prefering_party$imp_culture_breadwinner[wr]==5|prefering_party$imp_culture_breadwinner[wr]==4),0,1),
                         if_else(matching_party$imp_culture_homemaker[mr]==-10&(prefering_party$imp_culture_homemaker[wr]==5|prefering_party$imp_culture_homemaker[wr]==4),0,1),
                         if_else(matching_party$imp_culture_active[mr]==-10&(prefering_party$imp_culture_active[wr]==5|prefering_party$imp_culture_active[wr]==4),0,1),
                         if_else(matching_party$imp_culture_nonTraditional[mr]==-10&(prefering_party$imp_culture_nonTraditional[wr]==5|prefering_party$imp_culture_nonTraditional[wr]==4),0,1),
                         if_else(matching_party$imp_culture_location[mr]==-10&(prefering_party$imp_culture_location[wr]==5|prefering_party$imp_culture_location[wr]==4),0,1),
                         if_else(matching_party$imp_culture_mutual_interests[mr]==-10&(prefering_party$imp_culture_mutual_interests[wr]==5|prefering_party$imp_culture_mutual_interests[wr]==4),0,1),
                         #if_else((matching_party$demo_location_state==prefering_party$demo_location_state),1,0),
                         matching_party$demo_height_inches_and_feet[mr]-prefering_party$demo_height_inches_and_feet[wr],
                         matching_party$demo_age_days[mr]-prefering_party$demo_age_days[wr],
                         prefering_party$user_id[wr],
                         matching_party$user_id[mr],
                         prefering_party$user_expectations[wr],
                         prefering_party$total_self_evaluation[wr]
                         #prefering_party$demo_location_state[wr],
                         #matching_party$demo_location_state[mr]
      ))
    }}

  x <- x %>%
    as_tibble() %>%
    rename(diff_value_selfless=V1,
           diff_value_curious=V2,
           diff_value_fun=V3,
           diff_value_ambition=V4,
           diff_value_security=V5,
           diff_value_selfImprovement=V6,
           diff_value_traditional=V7,
           diff_attribute_logical=V8,
           diff_attribute_intuitive=V9,
           diff_attribute_agreeable=V10,
           diff_attribute_empathetic=V11,
           diff_attribute_confident=V12,
           diff_attribute_patient=V13,
           diff_attribute_emotional_maturity=V14,
           diff_attribute_responsible=V15,
           diff_attribute_honest=V16,
           diff_attribute_spontaneous=V17,
           diff_attribute_flexible=V18,
           diff_attribute_creative=V19,
           diff_attribute_forgiving=V20,
           diff_attribute_optimistic=V21,
           diff_attribute_calm=V22,
           diff_attribute_extroverted=V23,
           diff_attribute_openminded=V24,
           diff_culture_children=V25,
           diff_culture_breadwinner=V26,
           diff_culture_homemaker=V27,
           diff_culture_active=V28,
           diff_culture_nonTraditional=V29,
           diff_culture_location=V30,
           diff_culture_mutualInterests=V31,
           diff_cultural_height_score=V32,
           diff_cultural_age_score=V33,
           preference_user_id=V34,
           matching_user_id=V35,
           preference_user_expectations=V36,
           preference_user_self_evaluation=V37
          # preference_user_location_state=V36,
          # matching_user_location_state=V37
    )
  
  x <- x %>%
    mutate_at(vars(-starts_with(c('preference_user_id','matching_user_id'))), as.numeric)
  x$difference <- as.numeric(rep(0,nrow(x)))
  for(rf in 1:nrow(x)){
    for(i in 1:23){
      if(x[rf,i]<0)
        x$difference[rf] <- x$difference[rf] + x[rf,i]
    }}
  x <- x %>%
    mutate(difference=as.numeric(difference))
  return(x)
}
 

# # Calculate for all at once -----------------------------------------------
# calculateUserDifferenceSimple <- function(prefering_party,matching_party){
#   x <- NULL
#   for(wr in 1:nrow(prefering_party)){
#     for(mr in 1:nrow(matching_party)){
#       x <- rbind(x,cbind((matching_party$pos_values_selfless[mr]-prefering_party$imp_values_selfless[wr])*prefering_party$imp_values_selfless[wr],
#                          (matching_party$pos_values_curious[mr]-prefering_party$imp_values_curious[wr])*prefering_party$imp_values_curious[wr],
#                          (matching_party$pos_values_fun[mr]-prefering_party$imp_values_fun[wr])*prefering_party$imp_values_fun[wr],
#                          (matching_party$pos_values_ambition[mr]-prefering_party$imp_values_ambition[wr])*prefering_party$imp_values_ambition[wr],
#                          (matching_party$pos_values_security[mr]-prefering_party$imp_values_security[wr])*prefering_party$imp_values_security[wr],
#                          (matching_party$pos_values_selfimprovement[mr]-prefering_party$imp_values_selfimprovement[wr])*prefering_party$imp_values_selfimprovement[wr],
#                          (matching_party$pos_values_traditional[mr]-prefering_party$imp_values_traditional[wr])*prefering_party$imp_values_traditional[wr],
#                          (matching_party$pos_attributes_logical[mr]-prefering_party$imp_attributes_logical[wr])*prefering_party$imp_attributes_logical[wr],
#                          (matching_party$pos_attributes_intuitive[mr]-prefering_party$imp_attributes_intuitive[wr])*prefering_party$imp_attributes_intuitive[wr],
#                          (matching_party$pos_attributes_agreeable[mr]-prefering_party$imp_attributes_agreeable[wr])*prefering_party$imp_attributes_agreeable[wr],
#                          (matching_party$pos_attributes_empathetic[mr]-prefering_party$imp_attributes_empathetic[wr])*prefering_party$imp_attributes_empathetic[wr],
#                          (matching_party$pos_attributes_confident[mr]-prefering_party$imp_attributes_confident[wr])*prefering_party$imp_attributes_confident[wr],
#                          (matching_party$pos_attributes_patient[mr]-prefering_party$imp_attributes_patient[wr])*prefering_party$imp_attributes_patient[wr],
#                          (matching_party$pos_attributes_emotional_maturity[mr]-prefering_party$imp_attributes_emotional_maturity[wr])*prefering_party$imp_attributes_emotional_maturity[wr],
#                          (matching_party$pos_attributes_responsible[mr]-prefering_party$imp_attributes_responsible[wr])*prefering_party$imp_attributes_responsible[wr],
#                          (matching_party$pos_attributes_honest[mr]-prefering_party$imp_attributes_honest[wr])*prefering_party$imp_attributes_honest[wr],
#                          (matching_party$pos_attributes_spontaneous[mr]-prefering_party$imp_attributes_spontaneous[wr])*prefering_party$imp_attributes_spontaneous[wr],
#                          (matching_party$pos_attributes_flexible[mr]-prefering_party$imp_attributes_flexible[wr])*prefering_party$imp_attributes_flexible[wr],
#                          (matching_party$pos_attributes_creative[mr]-prefering_party$imp_attributes_creative[wr])*prefering_party$imp_attributes_creative[wr],
#                          (matching_party$pos_attributes_forgiving[mr]-prefering_party$imp_attributes_forgiving[wr])*prefering_party$imp_attributes_forgiving[wr],
#                          (matching_party$pos_attributes_optimistic[mr]-prefering_party$imp_attributes_optimistic[wr])*prefering_party$imp_attributes_optimistic[wr],
#                          (matching_party$pos_attributes_calm[mr]-prefering_party$imp_attributes_calm[wr])*prefering_party$imp_attributes_calm[wr],
#                          (matching_party$pos_attributes_extroverted[mr]-prefering_party$imp_attributes_extroverted[wr])*prefering_party$imp_attributes_extroverted[wr],
#                          (matching_party$pos_attributes_openminded[mr]-prefering_party$imp_attributes_openminded[wr])*prefering_party$imp_attributes_openminded[wr],
#                          if_else(matching_party$imp_culture_children[mr]==-10&(prefering_party$imp_culture_children[wr]==5|prefering_party$imp_culture_children[wr]==4),0,1),
#                          if_else(matching_party$imp_culture_breadwinner[mr]==-10&(prefering_party$imp_culture_breadwinner[wr]==5|prefering_party$imp_culture_breadwinner[wr]==4),0,1),
#                          if_else(matching_party$imp_culture_homemaker[mr]==-10&(prefering_party$imp_culture_homemaker[wr]==5|prefering_party$imp_culture_homemaker[wr]==4),0,1),
#                          if_else(matching_party$imp_culture_active[mr]==-10&(prefering_party$imp_culture_active[wr]==5|prefering_party$imp_culture_active[wr]==4),0,1),
#                          if_else(matching_party$imp_culture_nonTraditional[mr]==-10&(prefering_party$imp_culture_nonTraditional[wr]==5|prefering_party$imp_culture_nonTraditional[wr]==4),0,1),
#                          if_else(matching_party$imp_culture_location[mr]==-10&(prefering_party$imp_culture_location[wr]==5|prefering_party$imp_culture_location[wr]==4),0,1),
#                          if_else(matching_party$imp_culture_mutual_interests[mr]==-10&(prefering_party$imp_culture_mutual_interests[wr]==5|prefering_party$imp_culture_mutual_interests[wr]==4),0,1),
#                          prefering_party$user_id[wr],
#                          matching_party$user_id[mr],
#                          prefering_party$total_self_evaluation[wr]
#       ))
#     }}
#   x <- x %>%
#     as_tibble() %>%
#     rename(diff_value_selfless=V1,
#            diff_value_curious=V2,
#            diff_value_fun=V3,
#            diff_value_ambition=V4,
#            diff_value_security=V5,
#            diff_value_selfImprovement=V6,
#            diff_value_traditional=V7,
#            diff_attribute_logical=V8,
#            diff_attribute_intuitive=V9,
#            diff_attribute_agreeable=V10,
#            diff_attribute_empathetic=V11,
#            diff_attribute_confident=V12,
#            diff_attribute_patient=V13,
#            diff_attribute_emotional_maturity=V14,
#            diff_attribute_responsible=V15,
#            diff_attribute_honest=V16,
#            diff_attribute_spontaneous=V17,
#            diff_attribute_flexible=V18,
#            diff_attribute_creative=V19,
#            diff_attribute_forgiving=V20,
#            diff_attribute_optimistic=V21,
#            diff_attribute_calm=V22,
#            diff_attribute_extroverted=V23,
#            diff_attribute_openminded=V24,
#            diff_culture_children=V25,
#            diff_culture_breadwinner=V26,
#            diff_culture_homemaker=V27,
#            diff_culture_active=V28,
#            diff_culture_nonTraditional=V29,
#            diff_culture_location=V30,
#            diff_culture_mutualInterests=V31,
#            preference_user_id=V32,
#            matching_user_id=V33,
#            preference_user_expectations=V34
#     )
#   
#   x <- x %>%
#     mutate_at(vars(-starts_with(c('preference_user_id','matching_user_id'))), as.numeric)
#   x$difference <- as.numeric(rep(0,nrow(x)))
#   for(rf in 1:nrow(x)){
#     for(i in 1:23){
#       if(x[rf,i]<0)
#         x$difference[rf] <- x$difference[rf] + x[rf,i]
#     }}
#   x <- x %>%
#     mutate(difference=as.numeric(difference))
#   return(x)
# }

calculatePairScore <- function(x,y){
  combinedTable <- x %>%
    left_join(y, by=c("preference_user_id"="matching_user_id","matching_user_id"="preference_user_id"),suffix = c("_male", "_female")) %>%
    mutate(match_score_aggragate=match_percentage_female+match_percentage_male)
  return(combinedTable)
}

saveGenderDifferenceTables <- function(gender_table,file_name){
  write.csv(gender_table,paste0('user_table/',file_name,today(),'.csv'))
  write.csv(gender_table,paste0(file_name,'.csv'))
}
