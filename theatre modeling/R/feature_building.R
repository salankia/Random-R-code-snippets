library(tidyverse)

classes <- read_csv("data/classes_train.csv")
classes$title <- gsub("<e9>", "e", classes$title)
classes$title = gsub("<dc>", "u", classes$title)
classes$title = gsub("<e9>", "e", classes$title)
classes$title = gsub("<fa>", "u", classes$title)
classes$title = gsub("<ed>", "i", classes$title)
classes$title = gsub("<e1>", "a", classes$title)
classes$title = gsub("<f6>", "o", classes$title)
classes$title = gsub("<f3>", "o", classes$title)
classes$title = gsub("<c1>", "a", classes$title)
(classes$title)

location_timing <- read_csv("data/location_timing_train.csv")
location_timing$title <- gsub("<e9>", "e", location_timing$title)
location_timing$title = gsub("<dc>", "u", location_timing$title)
location_timing$title = gsub("<e9>", "e", location_timing$title)
location_timing$title = gsub("<fa>", "u", location_timing$title)
location_timing$title = gsub("<ed>", "i", location_timing$title)
location_timing$title = gsub("<e1>", "a", location_timing$title)
location_timing$title = gsub("<f6>", "o", location_timing$title)
location_timing$title = gsub("<f3>", "o", location_timing$title)
location_timing$title = gsub("<c1>", "a", location_timing$title)
(location_timing$title)

artists <- read_csv("data/actors.csv")

artists$number_of_actors <- rowSums(as.matrix(artists[,
                                                      seq(from = 1, to = length(artists) - 1)]))

artists$title <- sapply(strsplit(artists$title, split = ": "), function(i){
  i[length(i)]
})


full <- classes[, c("title", "day_category")] %>% 
  left_join(location_timing) %>% 
  left_join(artists)

write.csv(full, file = "data/train.csv", row.names = F)

############ Test #####
classes <- read_csv("data/classes_test.csv")
classes$title <- gsub("<e9>", "e", classes$title)
classes$title = gsub("<dc>", "u", classes$title)
classes$title = gsub("<e9>", "e", classes$title)
classes$title = gsub("<fa>", "u", classes$title)
classes$title = gsub("<ed>", "i", classes$title)
classes$title = gsub("<e1>", "a", classes$title)
classes$title = gsub("<f6>", "o", classes$title)
classes$title = gsub("<f3>", "o", classes$title)
classes$title = gsub("<c1>", "a", classes$title)
(classes$title)

location_timing <- read_csv("data/location_timing_test.csv")
location_timing$title <- gsub("<e9>", "e", location_timing$title)
location_timing$title = gsub("<dc>", "u", location_timing$title)
location_timing$title = gsub("<e9>", "e", location_timing$title)
location_timing$title = gsub("<fa>", "u", location_timing$title)
location_timing$title = gsub("<ed>", "i", location_timing$title)
location_timing$title = gsub("<e1>", "a", location_timing$title)
location_timing$title = gsub("<f6>", "o", location_timing$title)
location_timing$title = gsub("<f3>", "o", location_timing$title)
location_timing$title = gsub("<c1>", "a", location_timing$title)
(location_timing$title)

artists <- read_csv("data/actors.csv")

artists$number_of_actors <- rowSums(as.matrix(artists[,
                                                      seq(from = 1, to = length(artists) - 1)]))

artists$title <- sapply(strsplit(artists$title, split = ": "), function(i){
  i[length(i)]
})
  

full <- classes[, c("title", "day_category")] %>% 
  left_join(location_timing) %>% 
  left_join(artists)

write.csv(full, file = "data/test.csv", row.names = F)
