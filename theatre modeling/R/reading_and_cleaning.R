library(tidyverse)
library(readr)

files_to_read <- list.files("../theatre scraping/", pattern = "_2.csv", full.names = T)
(files_to_read)

inputs_train <- lapply(files_to_read, function(filename){
  print(filename)
  input <- read_csv(filename)
  input <- input %>% 
    filter(!is.na(date)) %>% 
    filter(grepl("prilis", date))
  input$log_date <- substring(filename, 21, 33)
  input
})

aggregated_train <- bind_rows(inputs_train)
write.csv(aggregated_train, file = "data/aggregated_train.csv", row.names = F)

inputs_tests <- lapply(files_to_read, function(filename){
  print(filename)
  input <- read_csv(filename)
  input <- input %>% 
    filter(!is.na(date)) %>% 
    filter(grepl("nius", date))
  if(length(input$date) > 0){
    input$log_date <- substring(filename, 21, 33)  
    return(input)
  } else {
    return(cbind(input, data.frame(log_date = character(0))))
  }
})

aggregated_tests <- bind_rows(inputs_tests)
write.csv(aggregated_tests, file = "data/aggregated_test.csv", row.names = F)

