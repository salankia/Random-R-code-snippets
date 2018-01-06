library(ggplot2)
res <- read.csv("C:/Users/Agnes/Downloads/results.csv")

base <- ggplot(res, aes(x = input, y = time))
base+ geom_point() + 
  scale_y_log10() + theme_bw() +
  stat_summary(fun.y = median,
               fun.ymin = median,
               fun.ymax = median,
               geom = "crossbar", width = 0.5)
