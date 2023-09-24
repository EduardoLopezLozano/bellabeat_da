---
title: "Script_R"
author: "Eduardo Lopez"
date: "22 de septiembre de 2023"
---

```{r Charge libraries}
library(tidyverse)
library(skimr)
library(janitor)
```

```{r charge data frame}
fitness_survey <- read_csv("D:/p_coursera/1_p/fitness_analysis.csv", show_col_types = FALSE)
head(fitness_survey)
```
We create a new data frame just with the gender Female, because it's the data of our interest.
```{r filter data frame}
filter_fs <- fitness_survey %>%
    filter(gender == 'Female') %>%
  select(age, exc_importance, fitness_level, exc_frequency, barrier_exc_1, exc_type_1,
         balance_diet, healthy, purch_fitness_equipment, exc_motivation_1)
```
In this part we agroup the females by age, so we obtained the percentege of purchase by age.
```{r Analysis of purchase equipment and graphic}
 percentege_equipment <- filter_fs %>%
  group_by(age) %>%
  count(purch_fitness_equipment) %>%
  transmute(purch_fitness_equipment, percentege = round((n/sum(n))*100,2)) 

graph_1 <- ggplot(percentege_equipment, aes(x = age, y = percentege, fill = purch_fitness_equipment, colour = purch_fitness_equipment)) +
  geom_bar(stat = "identity", position = "fill", alpha = 0.5) +
  labs(x = "Age", y = "Percentage", fill="Purchase?", colour="Purchase?") +
  geom_text(aes(label=percentege), position = position_fill(vjust = 0.5), show.legend = FALSE, color="black") +
  ggtitle("Percentage of Purchase Equipment by Age", subtitle = "Percentage of purchase made by women according age") +
  theme(axis.text.y=element_blank())

#ggsave("percentage_of_purchase_equipment_by_age.png",  width = 6, height = 4.5)

print(graph_1)
```
We filter the data to obtain the sum of the females for each activity.
```{r Analysis of percentege type exercise and graphic}
percentege_type_exc <- filter_fs %>%
  group_by(exc_type_1) %>%
  count(exc_type_1) %>%
  mutate(exc_type_1 = ifelse(n < 9, "Others", exc_type_1)) %>%
  group_by(exc_type_1) %>%
  summarise(n = sum(n))
  
graph_2 <- ggplot(percentege_type_exc, aes(x="",y=n, fill=exc_type_1, colour=exc_type_1)) +
  geom_bar(stat = "identity", position = "fill", alpha = 0.5) +
  coord_polar("y",start=0) +
  labs(fill="Activity", colour="Activity") +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        panel.border = element_blank(),
        panel.grid = element_blank(),
        axis.ticks = element_blank(),
        axis.text.x=element_blank())+
  ggtitle("Preferred Exercise by Women", subtitle = "Number of woman by activity of 284 women") +
  geom_text(aes(label=n), position = position_fill(vjust = 0.5), show.legend = FALSE, color="black") +
  scale_fill_discrete(limits = c("Walking or jogging", "I don't really exercise", "Gym", "Yoga", "Zumba dance", "Others")) +
  scale_colour_discrete(limits = c("Walking or jogging", "I don't really exercise", "Gym", "Yoga", "Zumba dance", "Others"))
  
#ggsave("preferred_exercise_by_women.png", width = 5, height = 5)

print(graph_2)
```

