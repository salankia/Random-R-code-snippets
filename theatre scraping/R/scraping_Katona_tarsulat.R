library(rvest)
library(plyr)

url <- "http://katonajozsefszinhaz.hu/eloadasok/repertoar"
webpage <- read_html(url)

eloadasok_html <- html_nodes(webpage, '#contents-news a')
eloadasok_cim <- html_text(eloadasok_html)

eloadasok_link <- lapply(eloadasok_html, function(mini_url){
  url_char <- as.character(mini_url)
  print(url_char)
  
  if(strsplit(url_char, split = "\">", fixed = T)[[1]][2] != "</a>" &
     strsplit(url_char, split = "\">", fixed = T)[[1]][2] != "\n  <br />\n</a>") {
    gsub(pattern = "<a href=\"",replacement = "http://katonajozsefszinhaz.hu",
         strsplit(url_char, split = "\">", fixed = T)[[1]][1])  
  } else {NA}
})

actors <- lapply(eloadasok_link, function(url_extended){
  if(!is.na(url_extended)){
    print(url_extended)
    play_webpage <- read_html(url_extended)
    actors_and_directors_html <- html_nodes(play_webpage, ".cell-left-wide-highlighted a")
    html_text(actors_and_directors_html)  
  } else {character(0)}
})

actors_graph <- data.frame(from = character(0),
                           to = character(0),
                           title = character(0))

lapply(seq(from = 1, to = length(eloadasok_cim)), function(i){
  print(i)
  if(length(actors[[i]]) >= 2) {
    actors_graph <<- rbind(actors_graph,
                           cbind(as.data.frame(t(combn(x = actors[[i]], m = 2, simplify = T))),
                                 eloadasok_cim[i]))  
  }
  T
})

colnames(actors_graph) <- c("from", "to", "title")
 
aggregated_actors_graph <- ddply(actors_graph, .variables = c("from", "to"), .fun = function(df){
  print(unique(df[, c(1, 2)]))
  data.frame(from = unique(df$from),
             to = unique(df$to),
             width = length(df$title),
             plays = paste(df$title, collapse = ", "))
})

graph <- graph_from_data_frame(aggregated_actors_graph)
V(graph)$Label <- unique(c(as.character(aggregated_actors_graph$from),
                           as.character(aggregated_actors_graph$to)))
V(graph)$Popularity <- degree(graph, mode = 'all')
E(graph)$Width <- aggregated_actors_graph$width

ggraph(graph, layout = 'lgl') + 
  geom_edge_link(aes(alpha = Width)) + 
  geom_node_text(aes(label = Label, size = Popularity), repel = T)
