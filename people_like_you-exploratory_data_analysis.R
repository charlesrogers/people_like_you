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

# What is a "good" score?  ------------------------------------------------
pref_merged_df %>%
  filter(cultureScore==1)%>%
  ggplot(aes(match_percentage,fill=factor(gender)))+geom_histogram(alpha=.7)+
  theme_light() + labs(title="Average Match Score",subtitle="",x="Match Score",y="Number of Matches",color="",fill="", size="",caption=paste0("Matches from People-Like-You.com"))
  

potential_matches %>%
  filter(female_id=="uid00000003") %>%
  filter(male_id %in% c('uid00000065','uid00000079')) %>% View("Rebeccagorithm-Aimee Grout")

potential_matches %>%
  filter(female_id=="uid00000060") %>%
  filter(male_id %in% c('uid00000016','uid00000024','uid00000032','uid00000039','uid00000065')) %>% View("Rebeccagorithm-Janelle Biggs")

potential_matches %>%
  filter(female_id=="uid00000012") %>%
  filter(male_id %in% c('uid00000004','uid00000016','uid00000024','uid00000032','uid00000096')) %>% View("Rebeccagorithm-Ana Flores")


potential_matches %>%
  filter(male_id=='uid00000065')%>%
  ggplot(aes(match_percentage_female)) + geom_histogram()



# Look at matches ---------------------------------------------------------
# df_adjacent %>%
#   mutate(match_score_aggragate=round(match_score_aggragate,1)) %>%
#   count(match_score_aggragate)
# 
# df_adjacent %>%
#   mutate(match_percentage_female=round(match_percentage_female,1))%>%
#   count(match_percentage_female)
# 
# df_adjacent %>%
#   mutate(match_percentage_male=round(match_percentage_male,1))%>%
#   count(match_percentage_male)

# potential_matches %>%
#   filter(match_score_aggragate> 1.7) %>%
#   # filter(match_percentage_male>.9&match_percentage_female>.9) %>%
#   # filter(cultureScore_male==1&cultureScore_female==1) %>%
#   ggplot(aes(match_score_aggragate)) + geom_histogram()
# 
# potential_matches %>%
#   count(female_id) %>%
#   arrange(desc(n)) %>%
#   ggplot(aes(n))+geom_histogram(binwidth = 3)
# 
# 
# female_users_preference %>%
#   filter(is.na(diff_culture_breadwinner)) %>%View()
# 
# male_users_preference %>%
#   select(starts_with("diff_culture")) %>% View()
