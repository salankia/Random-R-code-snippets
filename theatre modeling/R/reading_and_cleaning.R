library(tidyverse)
library(readr)

files_to_read <- list.files("../theatre scraping/", pattern = ".csv", full.names = T)
(files_to_read)

inputs <- lapply(files_to_read, function(filename){
  print(filename)
  input <- read_csv(filename)
  input <- input %>% 
    filter(!is.na(date)) %>% 
    filter(grepl("prilis", date))
  input$log_date <- substring(filename, 21, 31)
  input
})

aggregated <- bind_rows(inputs)
write.csv(aggregated, file = "data/aggregated.csv", row.names = F)
