library(rvest)

url <- "http://katonajozsefszinhaz.hu/tarsulat"
webpage <- read_html(url)

alkotok_html <- html_nodes(webpage, '#contents-news a')
alkotok <- html_text(alkotok_html)


alkotok_link <- lapply(alkotok_html, function(mini_url){
  url_char <- as.character(mini_url)
  print(url_char)
  
  if(grepl(pattern = "tarsulat", url_char)) {
    gsub(pattern = "<a href=\"",replacement = "http://katonajozsefszinhaz.hu",
         strsplit(url_char, split = "\">", fixed = T)[[1]][1])    
  } else {NA}
  
})

actors <- lapply(alkotok_link, function(url_extended){
  if(!is.na(url_extended)){
    print(url_extended)
    actor_webpage <- read_html(url_extended)
    local_link <- as.character(html_node(actor_webpage, "#contents-news img"))
    global_link <- gsub(pattern = "<img src=\"",
                        replacement = "http://katonajozsefszinhaz.hu",
                        x = strsplit(local_link, split = "\" alt=", fixed = T)[[1]][1],
                        fixed = T
      
    )
  } else {character(0)}
})
