#Loading the rvest package
library('rvest')
library('plyr')
library('dplyr')

############# Schedule for February and March ##################################
url_root <- "http://katonajozsefszinhaz.hu/jegyek"
webpage_root <- read_html(url_root)

plays_html <- html_nodes(webpage_root, '#contents-news a')
plays_titles <- html_text(plays_html)

schedule <- data.frame(date = character(0),
                       location = character(0),
                       title = character(0),
                       tickets = character(0))

for(i in 1:length(plays_titles)) {
  print(i)
  current_date <- html_text(html_node(webpage_root,
                                      paste0('tr:nth-child(', i,') td')))
  current_location <- html_text(html_node(webpage_root,
                                          paste0('tr:nth-child(', i, ') td:nth-child(2)')))
  current_title <- plays_titles[i]
  current_tickets <- html_text(html_node(webpage_root, paste0('tr:nth-child(',i,') :nth-child(4)')))
  
  schedule <<- rbind(schedule,
                     data.frame(date = current_date,
                                location = current_location,
                                title = current_title,
                                tickets = current_tickets))
}

## unfortunately, we have to remove the "Jegyvasarlas" titles and
## shift the titles back
schedule$title <- c(as.character(schedule$title[schedule$title != "Jegyvásárlás"]),
                    rep(NA, times = sum(schedule$title == "Jegyvásárlás")))
write.csv(schedule, file = paste0(
  gsub(x = Sys.time(), pattern = ":|-", replacement =  ""),
  ".csv"), row.names = F)
