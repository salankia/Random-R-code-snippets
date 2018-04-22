library(dplyr)

########### Train ####
aggregated <- read_csv("data/aggregated_train.csv")
first_date <- unique(aggregated$log_date)[1]

first_set <- aggregated %>% 
  filter(log_date == first_date)

### number of plays, location
location_timing <- first_set %>% 
  group_by(title) %>% 
  summarise(location = unique(location),
            number_of_plays = n())

write.csv(location_timing, file = "data/location_timing_train.csv", row.names= F)

########### Test ####
aggregated <- read_csv("data/aggregated_test.csv")
first_date <- unique(aggregated$log_date)[1]

first_set <- aggregated %>% 
  filter(log_date == first_date)

### number of plays, location
location_timing <- first_set %>% 
  group_by(title) %>% 
  summarise(location = unique(location),
            number_of_plays = n()
            )

write.csv(location_timing, file = "data/location_timing_test.csv", row.names= F)

