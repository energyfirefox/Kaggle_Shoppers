library(caret)

train <- read.csv("reshaped_comp_train.csv")
test <- read.csv("reshaped_comp_test.csv")

# train <- read.csv("complete_train.csv")
# test <- read.csv("complete_test.csv")

str(train)

featurePlot(train_cut[,-c(1,2)], train_cut$repeater)

preProc <- preProcess(train_cut[,-c(1,2)], method = "pca", thresh = 0.9)
preProc$numComp

train_cut$repeater <- as.factor(train_cut$repeater)


##
# model_short <- train(repeater ~., data = train[, -c(1, 3, 4, 5, 6,  8)], preProcess="pca", method ="glm")
model_short <- train(repeater ~., data = train[, -c(1,4 )], preProcess="pca", method ="glm")
model_full <- train(repeater ~., data = train[, -c(1, 4)],  method ="glm")
model_rf <- train(repeater ~., data = train[, -c(1,4 )], method ="rf", prox=TRUE)

str(test)
str(train)

pca <- predict(model_short,  newdata=test[,-c(1:5, 7)])

pca <- predict(model_full,  newdata=test[,-c(1,3)])
head(pca)

write.table(cbind("id", "repeatProbability"), 'pca.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",")
write.table(cbind(test$id, pca), 'pca.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",", append=TRUE)
