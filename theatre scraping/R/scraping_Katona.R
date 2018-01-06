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

for(i in 1:length(title_data)) {
  print(i)
  current_date <- html_text(html_node(webpage_root,
                                      paste0('tr:nth-child(', i,') td')))
  current_location <- html_text(html_node(webpage_root,
                                          paste0('tr:nth-child(', i, ') td:nth-child(2)')))
  current_title <- title_data[i]
  current_tickets <- html_text(html_node(webpage_root, paste0('tr:nth-child(',i,') :nth-child(4)')))
  
  schedule <<- rbind(large_frame,
                       data.frame(date = current_date,
                                  location = current_location,
                                  title = current_title,
                                  tickets = current_tickets))
}

############# Actors in each play ##############################################
url_list_of_playes <- "http://katonajozsefszinhaz.hu/eloadasok/repertoar"
webpage_list_of_playes <- read_html(url_list_of_playes)

plays_html <- html_nodes(webpage_list_of_playes, '#contents-news a')
plays_title <- html_text(plays_html)

plays_urls <- lapply(plays_html, function(play_url){
  play_url_char <- as.character(play_url)
  print(play_url_char)
  
  if(strsplit(play_url_char, split = "\">", fixed = T)[[1]][2] != "</a>" &
     strsplit(play_url_char, split = "\">", fixed = T)[[1]][2] != "\n  <br />\n</a>") {
    gsub(pattern = "<a href=\"",replacement = "http://katonajozsefszinhaz.hu",
         strsplit(play_url_char, split = "\">", fixed = T)[[1]][1])  
  } else {NA}
})


actors <- lapply(plays_urls, function(play_url_char){
  if(!is.na(play_url_char)){
    print(play_url_char)
    play_webpage <- read_html(play_url_char)
    actors_and_directors_html <- html_nodes(play_webpage, ".cell-left-wide-highlighted a")
    html_text(actors_and_directors_html)  
  } else {character(0)}
})

actors_cooccurrence <- data.frame(from = character(0),
                           to = character(0),
                           play_title = character(0))

lapply(seq(from = 1, to = length(plays_title)), function(i){
  print(i)
  if(length(actors[[i]]) >= 2) {
    actors_cooccurrence <<- rbind(actors_cooccurrence,
                           cbind(as.data.frame(t(combn(x = actors[[i]], m = 2, simplify = T))),
                                 plays_title[i])) 
    ## TBD: some creators appear in multiple role, like as an actor
    ## and a soundwriter, we should filter these out later
  }
  T
})

############# Getting the actors' profile picture links ########################
url_creators <- "http://katonajozsefszinhaz.hu/tarsulat"
webpage_creators <- read_html(url_creators)

creators_html <- html_nodes(webpage, '#contents-news a')
creators <- html_text(creators_html)

creators_link <- lapply(creators_html, function(creator_url){
  creator_url_char <- as.character(creator_url)
  print(creator_url_char)
  
  ## we filter down to actors and directors only
  if(grepl(pattern = "tarsulat", creator_url_char)) {
    gsub(pattern = "<a href=\"",replacement = "http://katonajozsefszinhaz.hu",
         strsplit(url_char, split = "\">", fixed = T)[[1]][1])    
  } else {NA}
})

actors_image_urls <- lapply(creators_link, function(creator_url_char){
  if(!is.na(creator_url_char)){
    print(creator_url_char)
    actor_webpage <- read_html(creator_url_char)
    local_link <- as.character(html_node(actor_webpage, "#contents-news img"))
    global_link <- gsub(pattern = "<img src=\"",
                        replacement = "http://katonajozsefszinhaz.hu",
                        x = strsplit(local_link, split = "\" alt=", fixed = T)[[1]][1],
                        fixed = T
    )
  } else {character(0)}
})
