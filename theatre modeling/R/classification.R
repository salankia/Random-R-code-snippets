library(tidyverse)
library(readr)

aggregated <- read_csv("data/aggregated_train.csv")

## when was the last date it got sold out if it got already
sold_out <- aggregated %>% 
  group_by(title, log_date) %>% 
  summarise(plays = n(),
            sold_out_n = sum(tickets == "Elfogyott"))  %>% 
  mutate(sold_out_on_this_date = (plays == sold_out_n),
         log_date = as.Date(log_date))

first_sold_out <- sold_out %>% 
  group_by(title) %>% 
  summarise(first_sold_out = min(ifelse(sold_out_on_this_date,
                                        log_date,
                                        NA),
                                 na.rm = T)) %>% 
  mutate(first_sold_out = as.Date(first_sold_out, origin = "1970-01-01")) %>% 
  mutate(day_diff = first_sold_out - as.Date("2018-02-15")) %>% 
  mutate(day_category = case_when(
    day_diff == 0 ~ "0",
    day_diff >= 1 & day_diff <= 2 ~ "1-2",
    day_diff >= 3 & day_diff <= 4 ~ "3-4",
    day_diff >= 5 & day_diff <= 7 ~ "5-7",
    day_diff >= 8 & day_diff <= 30 ~ "8-30",
    day_diff >= 31 & day_diff <= 60 ~ "31-60",
    day_diff >= 61 ~ ">60"
  )) %>% 
  ungroup(title)  %>% 
  mutate(day_category = factor(day_category,
                               levels = c("0", "1-2", "3-4", "5-7",
                                          "8-30", "31-60", ">60")))
  
ggplot(first_sold_out) +
  geom_bar(aes(x = day_category)) +
  theme_bw() +
  xlab("Days until sold out") +
  ylab("Frequency")

## This is not going to work, I would just go with 1) 0 days and 2) > 0 days

first_sold_out <- first_sold_out %>% 
  mutate(day_category = forcats::fct_recode(day_category,
                                            same_day = "0",
                                            later = "1-2",
                                            later = "3-4",
                                            later = "5-7",
                                            later = "8-30",
                                            later = "31-60",
                                            later = ">60"
                                            ))

ggplot(first_sold_out) +
  geom_bar(aes(x = day_category)) +
  theme_bw() +
  xlab("Days until sold out") +
  ylab("Frequency")


write.csv(first_sold_out, file = "data/classes_train.csv", row.names = F)

aggregated <- read_csv("data/aggregated_test.csv")

## when was the last date it got sold out if it got already
sold_out <- aggregated %>% 
  group_by(title, log_date) %>% 
  summarise(plays = n(),
            sold_out_n = sum(tickets == "Elfogyott"))  %>% 
  mutate(sold_out_on_this_date = (plays == sold_out_n),
         log_date = as.Date(log_date))

first_sold_out <- sold_out %>% 
  group_by(title) %>% 
  summarise(first_sold_out = min(ifelse(sold_out_on_this_date,
                                        log_date,
                                        NA),
                                 na.rm = T)) %>% 
  mutate(first_sold_out = as.Date(first_sold_out, origin = "1970-01-01")) %>% 
  mutate(day_diff = first_sold_out - as.Date("2018-04-16")) %>% 
  mutate(day_category = case_when(
    day_diff == 0 ~ "0",
    day_diff >= 1 & day_diff <= 2 ~ "1-2",
    day_diff >= 3 & day_diff <= 4 ~ "3-4",
    day_diff >= 5 & day_diff <= 7 ~ "5-7",
    day_diff >= 8 & day_diff <= 30 ~ "8-30",
    day_diff >= 31 & day_diff <= 60 ~ "31-60",
    day_diff >= 61 ~ ">60"
  )) %>% 
  ungroup(title)  %>% 
  mutate(day_category = factor(day_category,
                               levels = c("0", "1-2", "3-4", "5-7",
                                          "8-30", "31-60", ">60")))

ggplot(first_sold_out) +
  geom_bar(aes(x = day_category)) +
  theme_bw() +
  xlab("Days until sold out") +
  ylab("Frequency")

## This is not going to work, I would just go with 1) 0 days and 2) > 0 days

first_sold_out <- first_sold_out %>% 
  mutate(day_category = forcats::fct_recode(day_category,
                                            same_day = "0",
                                            later = "1-2",
                                            later = "3-4",
                                            later = "5-7",
                                            later = "8-30",
                                            later = "31-60",
                                            later = ">60"
  ))

ggplot(first_sold_out) +
  geom_bar(aes(x = day_category)) +
  theme_bw() +
  xlab("Days until sold out") +
  ylab("Frequency")


write.csv(first_sold_out, file = "data/classes_test.csv", row.names = F)


