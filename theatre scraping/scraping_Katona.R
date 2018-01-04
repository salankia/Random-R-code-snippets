#Loading the rvest package
library('rvest')
url <- "http://katonajozsefszinhaz.hu/jegyek"
webpage <- read_html(url)

## number of plays
title_data_html <- html_nodes(webpage, '#eloadasok a')
title_data <- html_text(title_data_html)

large_frame <- data.frame(date = character(0),
                          location = character(0),
                          title = character(0),
                          tickets = character(0))

for(i in 1:length(title_data)) {
  print(i)
  current_date <- html_text(html_node(webpage, paste0('tr:nth-child(', i,') td')))
  current_location <- html_text(html_node(webpage, paste0('tr:nth-child(', i, ') td:nth-child(2)')))
  current_title <- title_data[i]
  current_tickets <- html_text(html_node(webpage, paste0('tr:nth-child(',i,') :nth-child(4)')))
  
  large_frame <<- rbind(large_frame,
                       data.frame(date = current_date,
                                  location = current_location,
                                  title = current_title,
                                  tickets = current_tickets))
}
