library(h2o)
library(tidyverse)

h2o.init()
train <- read_csv("data/train.csv")
test <- read_csv("data/test.csv")
train <- train[, c(2:48)]
test <- test[, c(2:48)]

y <- "day_category"
x <- setdiff(names(train), y)

train$day_category <- as.factor(train$day_category)
test$day_category <- as.factor(test$day_category)
train <- as.h2o(train)
test <- as.h2o(test)

aml <- h2o.automl(x = x, y = y,
                  training_frame = train,
                  leaderboard_frame = test,
                  max_runtime_secs = 60)
aml@leaderboard
aml@leader

train$predicted <- h2o.predict(aml@leader, train)[, 1]
test$predicted <- h2o.predict(aml@leader, test)[, 1]

h2o.table(train$day_category, train$predicted)
h2o.table(test$day_category, test$predicted)

train_pred <- as.data.frame(train)
test_pred <- as.data.frame(test)

train_old <- read_csv("data/train.csv")
test_old <- read_csv("data/test.csv")

train_pred$title <- train_old$title
test_pred$title <- test_old$title

write.csv(train_pred, "data/train_pred.csv", row.names = F)
write.csv(test_pred, "data/test_pred.csv", row.names = F)

