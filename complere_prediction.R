library(caret)

# train <- read.csv("reshaped_comp_train.csv")
# test <- read.csv("reshaped_comp_test.csv")

train <- read.csv("complete_train.csv")
test <- read.csv("complete_test.csv")
train$offerdate <- as.Date(as.character(train$offerdate))


str(train)
cut_train <- train[train$offerdate < '2013-04-20', -c(1, 3:6, 8)]
cv <- train[train$offerdate >= '2013-04-20', -c(1, 3:6, 8)]

write.csv(cut_train, "cut_train.csv", row.names = FALSE)
write.csv(cv, "cv.csv", row.names = FALSE)



str(train)

cut_train$repeater <- as.factor(cut_train$repeater)

str(cut_train)

##
# model_short <- train(repeater ~., data = train[, -c(1, 3, 4, 5, 6,  8)], preProcess="pca", method ="glm")
model_short <- train(repeater ~., data = cut_train,  preProcess = c("center", "scale"), method ="glm")
model_lda <- train(repeater ~., data = cut_train,  preProcess = c("center", "scale"), method ="lda")
model_knn <- train(cut_train[,-c(1)], cut_train$repeater, method ="knn", preProcess = c("center", "scale"))



# model_rf <- train(repeater ~., data = cut_train,  preProcess = c("center", "scale"), method ="rf")

predict_cv <- predict(model_short, test)

preditc_cv2 <- predict(model_short, cv)
predict_cv1 <- predict(model_lda, cv)

confusionMatrix(cv$repeater, predict_cv1)

model_full <- train(repeater ~., data = train[, -c(1, 4)],  method ="glm")
model_rf <- train(repeater ~., data = train[, -c(1,4 )], method ="rf", prox=TRUE)
model_lda <- train(repeater ~., data = train[, -c(1,4 )], method ="lda", prox=TRUE)
model_lda

str(test)
str(train)

# pca <- predict(model_short,  newdata=test[,-c(1:5, 7)])

pca <- predict(model_lda,  newdata=test[,-c(1,3)])

head(pca)

from_h20 <- read.csv("d_l_cut.csv")

write.table(cbind("id", "repeatProbability"), 'pca.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",")
write.table(cbind(test$id, from_h20$predict), 'pca.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",", append=TRUE)
