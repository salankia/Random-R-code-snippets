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

## Merging the two together:
artists_full <- unique(c(unlist(artists1), unlist(artists2)))
plays_and_actors <- matrix(data = 0, nrow = length(eloadasok_cim),
                           ncol = length(artists_full))
colnames(plays_and_actors) <- artists_full
rownames(plays_and_actors) <- eloadasok_cim


