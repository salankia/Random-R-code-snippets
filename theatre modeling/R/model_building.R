library(h2o)
library(tidyverse)

classes <- read_csv("data/classes.csv")
location_timing <- read_csv("data/location_timing.csv")

full <- classes %>% 
  left_join(location_timing)

h2o.init()
train <- full[1:30, c(1, 4, 5, 6)]
test <- full[31:46, c(1, 4, 5, 6)]

y <- "day_category"
x <- setdiff(names(train), y)

train$day_category <- as.factor(train$day_category)
test$day_category <- as.factor(test$day_category)
train <- as.h2o(train)
test <- as.h2o(test)

aml <- h2o.automl(x = x, y = y,
                  training_frame = train,
                  leaderboard_frame = test,
                  max_runtime_secs = 30)
aml@leaderboard
aml@leader

train$predicted <- h2o.predict(aml@leader, train)[, 1]
test$predicted <- h2o.predict(aml@leader, test)[, 1]
