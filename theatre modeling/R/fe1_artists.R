#Loading the rvest package
library('rvest')
library('plyr')
library('dplyr')

################################################################################
#### New plays #### 
################################################################################

url <- "http://katonajozsefszinhaz.hu/eloadasok/bemutatok"
webpage <- read_html(url)

eloadasok_html <- html_nodes(webpage, '#contents-news a')
eloadasok_cim <- html_text(eloadasok_html)

################################################################################
## 2. Feladat: hamozzuk ki az eloadasok relativ URL-jeit! ####
################################################################################

eloadasok_relativ <- c()

for(i in c(1:length(eloadasok_cim))){
  url_char <- as.character(eloadasok_html[[i]])
  url_clear <- gsub("<a href=\"", "", url_char)
  
  searched_substring <- "\">"
  searched_substring_index <- regexpr(searched_substring, url_clear, fixed = T)
  eloadasok_relativ <- c(eloadasok_relativ, substring(url_clear, first = 1, last = searched_substring_index[[1]] - 1))
}

################################################################################
## 3. Feladat: keszitsunk abszolut linkeket a relativ utak
## "http://katonajozsefszinhaz.hu/" prefixelesevel!
################################################################################

eloadasok_abszolut <- paste0("http://katonajozsefszinhaz.hu/", eloadasok_relativ)

################################################################################
## 4. Feladat: Scrape-elljuk az osszes eloadas adatlapjat es gyujtsuk ki 
## a szereploket
################################################################################

szineszek <- list()
lapply(eloadasok_abszolut, function(link){
  print(link)
  webpage <- read_html(link)
  
  eloadas_html <- html_nodes(webpage, '.cell-left-wide-highlighted a')
  szineszek[[link]] <<- html_text(eloadas_html)
})

artists1 <- szineszek
names(artists1) <- eloadasok_cim


################################################################################
#### Old plays #### 
################################################################################

url <- "http://katonajozsefszinhaz.hu/eloadasok/repertoar"
webpage <- read_html(url)

eloadasok_html <- html_nodes(webpage, '#contents-news a')
eloadasok_cim <- html_text(eloadasok_html)

################################################################################
## 2. Feladat: hamozzuk ki az eloadasok relativ URL-jeit! ####
################################################################################

eloadasok_relativ <- c()

for(i in c(1:length(eloadasok_cim))){
  url_char <- as.character(eloadasok_html[[i]])
  url_clear <- gsub("<a href=\"", "", url_char)
  
  searched_substring <- "\">"
  searched_substring_index <- regexpr(searched_substring, url_clear, fixed = T)
  eloadasok_relativ <- c(eloadasok_relativ, substring(url_clear, first = 1, last = searched_substring_index[[1]] - 1))
}

################################################################################
## 3. Feladat: keszitsunk abszolut linkeket a relativ utak
## "http://katonajozsefszinhaz.hu/" prefixelesevel!
################################################################################

eloadasok_abszolut <- paste0("http://katonajozsefszinhaz.hu/", eloadasok_relativ)

################################################################################
## 4. Feladat: Scrape-elljuk az osszes eloadas adatlapjat es gyujtsuk ki 
## a szereploket
################################################################################

szineszek <- list()
lapply(eloadasok_abszolut, function(link){
  print(link)
  webpage <- read_html(link)
  
  eloadas_html <- html_nodes(webpage, '.cell-left-wide-highlighted a')
  szineszek[[link]] <<- html_text(eloadas_html)
})

artists2 <- szineszek
names(artists2) <- eloadasok_cim

## Merging the two together:
full <- c(artists1, artists2)
artists_full <- unique(c(unlist(artists1), unlist(artists2)))

plays_and_actors <- matrix(data = 0, nrow = length(full),
                           ncol = length(artists_full))
colnames(plays_and_actors) <- artists_full
rownames(plays_and_actors) <- names(full)
##plays_and_actors <- plays_and_actors[c(1:23, 25:30, 32:40, 42:46), ]

lapply(seq(from = 1, to = length(full)),
       function(index){
         print(index)
         print(full[[index]])
           plays_and_actors[index, unlist(full[[index]][full[[index]] != ""])] <<-  1
         T
})
plays_and_actors <- as.data.frame(plays_and_actors)
plays_and_actors$title <- rownames(plays_and_actors)
plays_and_actors <- plays_and_actors %>% 
  mutate(title = gsub("á", "a", title),
         title = gsub("é", "e", title),
         title = gsub("ü", "u", title),
         title = gsub("í", "i", title),
         title = gsub("Á", "a", title),
         title = gsub("ó", "o", title),
         title = gsub("ö", "o", title),
         title = gsub("ú", "u", title),
         title = gsub("ő", "o", title),
         title = gsub("ű", "u", title)
         )

write.csv(plays_and_actors, file = "data/actors.csv", row.names = F)

