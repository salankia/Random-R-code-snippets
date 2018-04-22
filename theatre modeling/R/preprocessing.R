library(readr)

files_to_read <- list.files("../theatre scraping/", pattern = ".csv", full.names = T)
(files_to_read)
## unfortunately, we have to remove the "Jegyvasarlas" titles and
## shift the titles back
## 


inputs_train <- lapply(files_to_read, function(filename){
  print(filename)
  input <- read_csv(filename)
  
  input$title <- c(as.character(input$title[!grepl(pattern = "Jegyv", input$title)]),
                      rep(NA, times = sum(grepl(pattern = "Jegyv", input$title))))
  
  write.csv(input, file = paste0(filename, "_2.csv"), row.names = F)
})
