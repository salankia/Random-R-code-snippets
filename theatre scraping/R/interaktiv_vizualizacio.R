library(networkD3)

input <- read.csv("aggregated.csv")
input <- actors_cooccurrence


nodes <- as.data.frame(unique(c(as.character(input$from),
                                as.character(input$to))))

colnames(nodes) <- "name"

nodes <- as.data.frame(nodes[nodes$name != "" & nodes$name != "Hofra Kft.", 1])
colnames(nodes) <- "name"
nodes$id <- seq(from = 0, to = (length(nodes$name) - 1))

links <- input[, c(1, 2, 3)]
links <- merge(links, nodes, by.x = "from", by.y = "name")
colnames(links)[length(links)] <- "from_id"
links <- merge(links, nodes, by.x = "to", by.y = "name")
colnames(links)[length(links)] <- "to_id"


forceNetwork(Links = links,
             Nodes = nodes,
             Source = "from_id", Target = "to_id",
             Value = "width",
             NodeID = "name",
             Group = "id",
             opacity = 0.8, zoom = T)



#################
library('visNetwork') 
nodes <- as.data.frame(unique(c(as.character(input$from),
                                as.character(input$to))))

colnames(nodes) <- "label"
nodes <- as.data.frame(nodes[nodes$label != "" & nodes$label != "Hofra Kft.", 1])
colnames(nodes) <- "label"
nodes$label <- as.character(nodes$label)
nodes$id <- seq(from = 0, to = (length(nodes$label) - 1))
actors_image_urls$image_url <- as.character(actors_image_urls$image_url)

nodes <- merge(nodes, actors_image_urls,
               by.x = "label", by.y = "name",
               all.x = T)
nodes$image_url[is.na(nodes$image_url)] <- "http://katonajozsefszinhaz.hu/templates/2014/images/logo_2014.png"

links <- input[, c(1, 2, 3, 4)]
links <- merge(links, nodes, by.x = "from", by.y = "label")
colnames(links)[length(links)] <- "from_id"
links <- merge(links, nodes, by.x = "to", by.y = "label")
colnames(links)[length(links)] <- "to_id"

links <- links[, c(3, 5, 7)]
colnames(links) <- c("value", 
                     "from",
                     "to")


nodes$shape <- c("circularImage")
nodes$label <- "" # Node label
nodes$size <- 10 # Node size
nodes$image <- as.character(nodes$image_url)

links$value <- links$value * 0.1 # line width
links$color <- "gray"    # line color  
links$arrows <- NA # arrows: 'from', 'to', or 'middle'
links$smooth <- FALSE    # should the edges be curved?
links$shadow <- FALSE    # edge shadow

visNetwork(nodes, links, width = "100%") %>%
  visEdges(scaling = list(min = 0.1, max = 0.4))
