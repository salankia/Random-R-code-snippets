#Loading the rvest package
library('rvest')

#Specifying the url for desired website to be scrapped
url <- 'http://www.imdb.com/search/title?count=100&release_date=2016,2016&title_type=feature'

#Reading the HTML code from the website
webpage <- read_html(url)

rank_data_html <- html_nodes(webpage,'.text-primary')
rank_data <- html_text(rank_data_html)

title_data_html <- html_nodes(webpage,'.lister-item-header a')
title_data <- html_text(title_data_html)


url <- "http://katonajozsefszinhaz.hu/jegyek"
webpage <- read_html(url)

############
## scrape the idopont
############

title_data_html <- html_nodes(webpage, '#eloadasok a')
title_data <- html_text(title_data_html)



html_text(html_node(webpage, '.button-gray'))
html_text(html_node(webpage, 'td > a'))

html_text(html_node(webpage, 'td:nth-child(1)'))
html_text(html_node(webpage, 'td:nth-child(2)'))
html_text(html_node(webpage, 'td:nth-child(3)'))
html_text(html_node(webpage, 'td:nth-child(4)'))

html_text(html_node(webpage, 'tr:nth-child(1) td'))
html_text(html_node(webpage, 'tr:nth-child(2) td'))
html_text(html_node(webpage, 'tr:nth-child(3) td'))
html_text(html_node(webpage, 'tr:nth-child(4) td'))
html_text(html_node(webpage, 'tr:nth-child(94) td'))
html_text(html_node(webpage, 'tr:nth-child(162) td'))

html_text(html_node(webpage, 'tr:nth-child(1) td:nth-child(2)'))
html_text(html_node(webpage, 'tr:nth-child(2) td:nth-child(2)'))
html_text(html_node(webpage, 'tr:nth-child(3) td:nth-child(2)'))

html_text(html_nodes(webpage, '#eloadasok a'))
html_text(html_node(webpage, '#eloadasok td > a'))

html_text(html_node(webpage, 'tr:nth-child(1) :nth-child(4)'))
html_text(html_node(webpage, 'tr:nth-child(2) :nth-child(4)'))
html_text(html_node(webpage, 'tr td:nth-child(4)'))

html_text(html_node(webpage, 'td:nth-child(4) :nth-child(1)'))



