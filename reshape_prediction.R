train_full <- read.csv("reshaped_train3.csv")
train_full[is.na(train_full)] <- 0

test <- read.csv("reshaped_test3.csv")
test[is.na(test)] <- 0

ind_samp <- sample(nrow(train_full), size=0.2*nrow(train_full))

str(train_full)

train <- train_full[-ind_samp, -c(1, 2, 25)]
write.csv(train, row.names=FALSE, "reshaped_train1.csv")
cv <- train_full[ind_samp, -c(1, 2, 25)]
write.csv(cv, row.names=FALSE, "reshaped_csv1.csv")

write.csv(test[,-c(1)], row.names=FALSE, "reshaped_test1.csv")

library(FNN)
model_knn <- (0:1)[knn(train=train_full[,-c(1:3)], test=test[,-c(1, 2)], k=3, cl=factor(train_full$repeater), prob = TRUE)]
head(model_knn)
write.table(cbind("id", "repeatProbability"), 'reshape_knn3.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",")
write.table(cbind(test$testset.id, model_knn), 'reshape_knn3.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",", append=TRUE)


model_knn30 <- (0:1)[knn(train=train_full[,-c(1:3)], test=test[,-c(1, 2)], k=30, cl=factor(train_full$repeater), prob = TRUE)]
head(model_knn30)
write.table(cbind("id", "repeatProbability"), 'reshape_knn30.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",")
write.table(cbind(test$testset.id, model_knn30), 'reshape_knn30.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",", append=TRUE)

str(full_train)

length(factor(train$repeater))


str(train)
################
# log_regression

train_f <- rbind(train, cv)
log_m_cv <- glm(factor(repeater) ~., data = train, family="binomial")
log_m <- glm(factor(repeater) ~., data = train_f, family="binomial")
summary(log_m)



cv_pred <- predict(log_m_cv, cv, type="response")
head(cv_pred)

cv_pred[cv_pred < 0.5] <- 0
cv_pred[cv_pred >= 0.5] <- 1

table(cv_pred, cv$repeater)

(23712+230)/nrow(cv)

str(test)
fin_pred <-  predict(log_m, test[ ,-c(1,2)], type="response")
head(fin_pred)
write.table(cbind("id", "repeatProbability"), 'reshape3_log.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",")
write.table(cbind(test$id, fin_pred), 'reshape3_log.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",", append=TRUE)


# svm top
library("e1071")

svm_mod <- svm(repeater ~., data = train)

library(ggplot2)
p <- ggplot(train, aes(category, company, color =factor(repeater)))
p + geom_point()

library(randomForest)

rf_mod <- randomForest(factor(repeater) ~., data = train_f, importance=TRUE)
rf_predict <- predict(rf_mod, test[ ,-c(1,2)])
head(rf_predict)
write.table(cbind("id", "repeatProbability"), 'reshape2_rf.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",")
write.table(cbind(test$id, rf_predict), 'reshape2_rf.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",", append=TRUE)
