# source('people_like_you-email_generator_potential_match.R')

# Test: send 1 email for everyone (where they are top match)


## Join matches with important data
# Left Join on male_user_preferences
# Get prompts from new_user_table

## Potential Match email
# Receiver_email
# Receiver_name
# candidate_name
# candidate_photo
# candidate_interests
# candidate_prompt_answers
# Yes/No match link

gm_auth_configure(key="151592556251-e1s93c94a16ebjv3h7vj7363t5bhhvdg.apps.googleusercontent.com",secret = 'tU3MMNSPXS5eoI74vEwEWpa-')
gm_auth()
# new_user_table <- new_user_table[, !duplicated(colnames(new_user_table))]

male_match_list_short <- send_list_adjusted_male %>%
  #filter(matching_user_id!="uid00000023")%>%
  select(preference_user_id,matching_user_id)

female_match_list_short <- send_list_adjusted_female %>%
  mutate(preference_user_id_swap=preference_user_id,
         matching_user_id_swap=matching_user_id) %>%
  mutate(matching_user_id=preference_user_id_swap,
         preference_user_id=matching_user_id_swap) %>%
  select(preference_user_id,matching_user_id)
merged_email_match_list <- rbind(male_match_list_short,female_match_list_short)

str(merged_email_match_list)

email_match_list <- merged_email_match_list %>%
  left_join(new_user_table,by=c('preference_user_id'='user_id')) %>%
  select(email_address,demo_first_name,preference_user_id,matching_user_id) %>% 
  mutate(preferrer_email_address=email_address,
         preferrer_demo_first_name=demo_first_name) %>%
  select(preferrer_email_address,preferrer_demo_first_name,preference_user_id,matching_user_id) %>%
  left_join(new_user_table,by=c('matching_user_id'='user_id')) %>%
  mutate(matching_demo_first_name=demo_first_name) %>%
  select(preferrer_email_address,preferrer_demo_first_name,preference_user_id,matching_user_id,matching_demo_first_name,prompt_unified)


match_tracker_bcc <- 'matches@people-like-you.com'
email_sender <- 'People Like You <team@people-like-you.com>'


test <- email_match_list %>%
  select(matching_user_id,preference_user_id) %>%
  mutate(yes_link_json=sprintf('{
    "event": "Click Yes",
    "properties": {
        "token": "0263eb159db1395608cbfeff9bbb9c4d",
        "Match Id": "%s"
    }}\')',matching_user_id))

test %>%
  mutate(yes_link_json_encoded=lapply(yes_link_json,base64Encode)) %>%
  View()
  # mutate(yes_link_json_encoded=pmap(.,~base64Encode(yes_link_json))) %>% View()

base64Encode(test$yes_link_json[1])==base64Encode(test$yes_link_json[2])

d <- data.frame(text = rownames(mtcars), stringsAsFactors = FALSE)
d$raw <- lapply(d$text, charToRaw)
d$encode <- lapply(d$raw, base64enc::base64encode)
d$decode <- lapply(d$encode, base64enc::base64decode)
d$text_back <- sapply(d$decode, rawToChar)
head(d)



match_user_email_content <- email_match_list %>%
  filter(preferrer_email_address=='ecruz87@icloud.com') %>%
  mutate(
    To = 'charlesrogers@gmail.com',
    Bcc = '',
    From = email_sender,
    accept_recommendation_link = paste0('http://people-like-you.com/recommendation-accepted.html?utm_source=match_email&utm_medium=preferrer_id_',preference_user_id,'-recommended_id_',matching_user_id,'-yes&utm_name=round_one'),
    decline_recommendation_link = paste0('http://people-like-you.com/recommendation-declined.html?utm_source=match_email&utm_medium=preferrer_id_',preference_user_id,'-recommended_id_',matching_user_id,'-no&utm_name=round_one'),
    photo_url = paste0('https://peoplelikeyouuserprofilephotos.s3.us-east-2.amazonaws.com/people/',matching_user_id,'.jpg'),
    yes_link_json=sprintf('{
    "event": "Click Yes",
    "properties": {
        "token": "0263eb159db1395608cbfeff9bbb9c4d",
        "Preference Id": "%s",
        "Match Id": "%s",
        "Pair Id": "%s%s"
    }}\')',preference_user_id,matching_user_id,preference_user_id,matching_user_id),
    yes_link_json_encoded=lapply(yes_link_json,base64Encode),
    no_link_json= sprintf('{
    "event": "Click No",
    "properties": {
        "token": "0263eb159db1395608cbfeff9bbb9c4d",
        "Preference Id": "%s",
        "Match Id": "%s",
        "Pair Id": "%s%s"
    }}\')',preference_user_id,matching_user_id,preference_user_id,matching_user_id),
    no_link_json_encoded=lapply(no_link_json,base64Encode),
    email_open_json= sprintf('{
    "event": "Email Open",
    "properties": {
    "token": "0263eb159db1395608cbfeff9bbb9c4d",
    "email_user_id": "%s",
    "email_match_user_id": "%s",
    "$insert_id": "%s%s",
    "$add": { "Opened This Email": 1 }
    }}',preference_user_id,matching_user_id,preference_user_id,matching_user_id),
    email_open_json_encoded=lapply(email_open_json,base64Encode),
    mixpanel_url_yes=sprintf('https://api.mixpanel.com/track/?data=%s=&redirect=%s',yes_link_json_encoded,accept_recommendation_link),
    mixpanel_url_no=sprintf('https://api.mixpanel.com/track/?data=%s=&redirect=%s',no_link_json_encoded,decline_recommendation_link),
    mixpanel_url_email_open=sprintf('https://api.mixpanel.com/track/?data=%s=&img=1',email_open_json_encoded),
    Subject = sprintf('Hey %s, we think you might like %s', preferrer_demo_first_name, matching_demo_first_name),
    body = paste0(email_body_header,sprintf(email_modular_content,preferrer_demo_first_name,matching_demo_first_name,photo_url,prompt_unified,matching_demo_first_name,mixpanel_url_yes,mixpanel_url_no,mixpanel_url_email_open,"'"))) %>%
  select(To,Bcc,From,Subject,body)
# select(yes_link_json,mixpanel_url_yes,mixpanel_url_email_open,email_open_json_encoded,yes_link_json_encoded) %>%
# view()
write_csv(match_user_email_content, "composed-emails.csv")

matchEmailsTest <- match_user_email_content %>%
  pmap(mime, 
       attr = list(content_type = "text/html"))

safe_send_message <- safely(send_message)
sent_mail <- matchEmailsTest %>% 
  map(safe_send_message)







# match_user_email_content <- email_match_list %>%
#   filter(preferrer_email_address=='cameronprattedwards@gmail.com') %>%
#   mutate(
#     To = 'charlesrogers@gmail.com',
#     Bcc = '',
#     From = email_sender,
#     accept_recommendation_link = paste0('http://people-like-you.com/recommendation-accepted.html?utm_source=match_email&utm_medium=preferrer_id_',preference_user_id,'-recommended_id_',matching_user_id,'-yes&utm_name=round_one'),
#     decline_recommendation_link = paste0('http://people-like-you.com/recommendation-declined.html?utm_source=match_email&utm_medium=preferrer_id_',preference_user_id,'-recommended_id_',matching_user_id,'-no&utm_name=round_one'),
#     photo_url = paste0('https://peoplelikeyouuserprofilephotos.s3.us-east-2.amazonaws.com/people/',matching_user_id,'.jpg'),
#     yes_link_json=sprintf('{
#     "event": "Click Yes",
#     "properties": {
#         "token": "0263eb159db1395608cbfeff9bbb9c4d",
#         "Match Id": "%s"
#     }}\')',matching_user_id),
#     # yes_link_json= sprintf('{
#     # "event": "Click Yes",
#     # "properties": {
#     #     "token": "0263eb159db1395608cbfeff9bbb9c4d",
#     #     "Response_Id": "%s",
#     #     "$insert_id": "%s",
#     #     "$unset": [ "Match_Id" ],
#     #     "Match_Id": "%s",
#     #     "$set": {
#     #       "Yes Click Preference ID": "%s",
#     #       "Yes Click Matching ID": "%s"},
#     #     "$append": { "Yes Matching ID": "%s" }
#     # }}\')',preference_user_id,matching_user_id,matching_user_id,preference_user_id,matching_user_id,matching_user_id),
#     no_link_json= sprintf('{
#     "event": "Click Yes",
#     "properties": {
#         "token": "0263eb159db1395608cbfeff9bbb9c4d",
#         "Response_Id": "%s",
#         "Match_Id": "%s",
#         "$insert_id": "%s%s"
#     }}\')',preference_user_id,matching_user_id,preference_user_id,matching_user_id),
#     email_open_json= sprintf('{
#       "event": "Email Open",
#       "properties": {
#         "token": "0263eb159db1395608cbfeff9bbb9c4d",
#         "email_user_id": "%s",
#         "email_match_user_id": "%s",
#         "$insert_id": "%s%s",
#         "$add": { "Opened This Email": 1 }
#       }
#     }',preference_user_id,matching_user_id,preference_user_id,matching_user_id),
#     encoded_json_email_open=base64_enc(email_open_json),
#     encoded_json_yes=base64_enc(yes_link_json),
#     encoded_json_no=base64_enc(no_link_json),
#     mixpanel_url_yes=sprintf('https://api.mixpanel.com/track/?data=%s=&redirect=%s',encoded_json_yes,accept_recommendation_link),
#     mixpanel_url_no=sprintf('https://api.mixpanel.com/track/?data=%s=&redirect=%s',encoded_json_no,decline_recommendation_link),
#     mixpanel_url_email_open=sprintf('https://api.mixpanel.com/track/?data=%s=&img=1',encoded_json_email_open),
#     Subject = sprintf('Hey %s, we think you might like %s', preferrer_demo_first_name, matching_demo_first_name),
#     body = paste0(email_body_header,sprintf(email_modular_content,preferrer_demo_first_name,matching_demo_first_name,photo_url,prompt_unified,matching_demo_first_name,mixpanel_url_yes,mixpanel_url_no,mixpanel_url_email_open,"'"))) %>%
#   select(To,Bcc,From,Subject,body)
#   # select(yes_link_json,encoded_json_yes,mixpanel_url_yes,mixpanel_url_email_open,encoded_json_email_open,yes_link_json) %>%
#   # view()
# write_csv(match_user_email_content, "composed-emails.csv")
# 
# matchEmailsTest <- match_user_email_content %>%
#   pmap(mime, 
#        attr = list(content_type = "text/html"))
# 
# safe_send_message <- safely(send_message)
# sent_mail <- matchEmailsTest %>% 
#   map(safe_send_message)



# https://api.mixpanel.com/track/?data=eyJldmVudCI6ICJnYW1lIiwgInByb3BlcnRpZXMiOiB7ImlwIjogIjEyMy4xMjMuMTIzLjEyMyIsICJkaXN0aW5jdF9pZCI6ICIxMzc5MyIsICJ0b2tlbiI6ICJlM2JiNDEwMDMzMGMzNTcyMjc0MGZiOGM2ZjVhYmRkYyIsICJ0aW1lIjogMTI0NTYxMzg4NSwgImFjdGlvbiI6ICJwbGF5In19==&redirect=http%3A%2F%2Fwww.example.com
#https://api.mixpanel.com/track/?data=eyJldmVudCI6ICJnYW1lIiwgInByb3BlcnRpZXMiOiB7ImlwIjogIjEyMy4xMjMuMTIzLjEyMyIsICJkaXN0aW5jdF9pZCI6IDEzNzkzLCAidG9rZW4iOiAiZTNiYjQxMDAzMzBjMzU3MjI3NDBmYjhjNmY1YWJkZGMiLCAidGltZSI6IDEyNDU2MTM4ODUsICJhY3Rpb24iOiAicGxheSJ9fQ==&img=1



# match_user_email_content <- email_match_list %>%
#   filter(preferrer_email_address=='daneroge@gmail.com') %>%
#   mutate(
#     To = 'charlesrogers@gmail.com',
#     Bcc = '',
#     From = email_sender,
#     accept_recommendation_link = paste0('http://people-like-you.com/recommendation-accepted.html?utm_source=match_email&utm_medium=preferrer_id_',preference_user_id,'-recommended_id_',matching_user_id,'-yes&utm_name=round_one'),
#     decline_recommendation_link = paste0('http://people-like-you.com/recommendation-declined.html?utm_source=match_email&utm_medium=preferrer_id_',preference_user_id,'-recommended_id_',matching_user_id,'-no&utm_name=round_one'),
#     photo_url = paste0('https://peoplelikeyouuserprofilephotos.s3.us-east-2.amazonaws.com/people/',matching_user_id,'.jpg'),
#     Subject = sprintf('Hey %s, we think you might like %s', preferrer_demo_first_name, matching_demo_first_name),
#     body = paste0(email_body_header,sprintf(email_modular_content,preferrer_demo_first_name,matching_demo_first_name,photo_url,prompt_unified,matching_demo_first_name,accept_recommendation_link,decline_recommendation_link,"'"))) %>%
#   select(To,Bcc,From,Subject,body)
# write_csv(match_user_email_content, "composed-emails.csv")
# 
# matchEmailsTest <- match_user_email_content %>%
#   pmap(mime, 
#        attr = list(content_type = "text/html"))
# 
# safe_send_message <- safely(send_message)
# sent_mail <- matchEmailsTest %>% 
#   map(safe_send_message)

# match_user_email_content <- email_match_list %>%
#   mutate(
#     #To = email_address,
#     To = 'charlesrogers@gmail.com',
#     Bcc = match_tracker_bcc,
#     From = email_sender,
#     accept_recommendation_link = paste0('http://people-like-you.com/recommendation-accepted.html?source=preferrer_id_',preference_user_id,'recommended_id_',matching_user_id,'-yes'),
#     decline_recommendation_link = paste0('http://people-like-you.com/recommendation-declined.html?source=preferrer_id_',preference_user_id,'recommended_id_',matching_user_id,'-no'),
#     photo_url = paste0('https://peoplelikeyouuserprofilephotos.s3.us-east-2.amazonaws.com/people/',matching_user_id,'.jpg'),
#     Subject = sprintf('Hey %s, we think you might like %s', preferrer_demo_first_name, matching_demo_first_name),
#     body = paste0("'",email_body_header,sprintf(email_modular_content,preferrer_demo_first_name,matching_demo_first_name,photo_url,matching_demo_first_name,accept_recommendation_link,decline_recommendation_link,matching_demo_first_name,prompt_unified,"'"))),
#   select(To,Bcc,From,Subject,gm_html_body) %>%
#   head(5)
