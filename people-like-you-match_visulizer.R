#I want to graph some stuff:
## I want to create a graph of how well cameron matchs with eveyone in the population
library(png)

img <- png::readPNG("people-like-you-logo.png")
g_pic <- grid::rasterGrob(img, interpolate=TRUE)


# Overall Personal Distribution -------------------------------------------
male_users_preference %>%
  filter(preference_user_id=='uid00000119')%>%
  ggplot(aes(difference)) + geom_histogram(position = "identity", alpha = 0.7,binwidth = 10) +
  # scale_x_continuous(breaks=c(min(difference),max(difference))) +
  # scale_y_continuous(breaks=c(min(n),max(n))) + 
  # scale_x_continuous(expand = expand_scale(mult = 0)) +
  scale_y_continuous(expand = expansion(mult = 0)) +
  scale_x_continuous(expand = expansion(mult = 0)) +
  labs(
    title = "Your Estimated Compatability with Potential Matches",
    subtitle = paste0("Keep in mind this is with a small dataset!"),
    x = "Compatability Range",
    y = "Number of Potential Matches",
    caption = paste0("Matches via People-Like-You.com")
  ) +
  theme(
    text = element_text(family = "Roboto"),
    plot.margin = unit(rep(1, 4), "cm"),
    plot.title = element_text(size = 20, 
                              face = "bold",
                              margin = margin(b = 10)),
    plot.subtitle = element_text(size = 17, 
                                 margin = margin(b = 25)),
    plot.caption = element_text(size = 12,
                                margin = margin(t = 15)),
    panel.grid.major = element_line(color = "#DAE1E7"),
    panel.background = element_blank(),
    axis.text = element_text(size = 12),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.ticks.x = element_blank(),
    axis.title = element_text (size = 15),
    axis.line = element_line(),
    axis.title.y = element_text(margin = margin(r = 10),
                                hjust = 0.5),
    axis.title.x = element_text(margin = margin(t = 10),
                                hjust = 0.5)
  ) #+ annotation_custom(g_pic, xmin=-60, xmax=0, ymin=10, ymax=6)



# Bi-factor Represenation -------------------------------------------------
this_related_to_the_rest <- male_users_preference %>%
  filter(preference_user_id=='uid00000119')%>%
  filter(matching_user_id=='uid00000115')
  

# Radar -------------------------------------------------------------------
# male_users_preference %>% 
#   filter(preference_user_id=='uid00000023') %>%
#   select(starts_with("diff_value")) %>%
#   tail(5) %>% 
#   mutate_at(vars(everything()),rescale) %>% View()
#   ggradar()



# Lolipop chart -----------------------------------------------------------
male_users_preference %>% 
  filter(preference_user_id=='uid00000023') %>%
  select(starts_with("diff_value")) %>%
  slice(1) %>% pivot_longer(everything()) %>%
  ggplot(aes(x=name, y=value)) +
  geom_segment(aes(x=name, xend=name, y=0, yend=value), color="grey") +
  geom_point( color="#ff4500", size=4) +
  theme_light() +
  scale_y_discrete(labels=c("Below Expectations", "Slightly Below Expectations", "Meets Expectations","Exceeds Expectations"))+
labs(
  title = "Vectors (lol) of compatability",
  subtitle = paste0("How well this potential match meets your expectations"),
  x = "Values",
  y = "Their reality vs your expectations",
  caption = paste0("Matches via People-Like-You.com")
) +
  theme(
    panel.grid.major.x = element_blank(),
    panel.border = element_blank(),
    axis.ticks.x = element_blank(),
    
  ) 


male_users_preference %>%
  filter(preference_user_id=='uid00000023')%>%
  # ggplot(aes(x=difference_values,y=difference_attributes)) + geom_jitter(width = .04,height = .01, size = 3,alpha=.5) +
  ggplot(aes(x=difference_values,y=difference_attributes)) + geom_count() +
  geom_point(aes(x=this_related_to_the_rest$difference_values,this_related_to_the_rest$difference_attributes),color="red", size = 4) +
  scale_y_continuous(expand = expansion(mult = 0)) +
  scale_x_continuous(expand = expansion(mult = 0))
  
  labs(
    title = "Your Estimated Compatability with Potential Matches",
    subtitle = paste0("Keep in mind this is with a small dataset!"),
    x = "Compatability Range",
    y = "Number of Potential Matches",
    caption = paste0("Matches via People-Like-You.com")
  ) +
  theme(
    text = element_text(family = "Roboto"),
    plot.margin = unit(rep(1, 4), "cm"),
    plot.title = element_text(size = 20, 
                              face = "bold",
                              margin = margin(b = 10)),
    plot.subtitle = element_text(size = 17, 
                                 margin = margin(b = 25)),
    plot.caption = element_text(size = 12,
                                margin = margin(t = 15)),
    panel.grid.major = element_line(color = "#DAE1E7"),
    panel.background = element_blank(),
    axis.text = element_text(size = 12),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.ticks.x = element_blank(),
    axis.title = element_text (size = 15),
    axis.line = element_line(),
    axis.title.y = element_text(margin = margin(r = 10),
                                hjust = 0.5),
    axis.title.x = element_text(margin = margin(t = 10),
                                hjust = 0.5)
  )

