add_train_feartures <- read.csv("add_features.csv")
additional_test_features_df_from_file <- read.csv("additional_test.csv")

str(full_Test)
trainHistory <- read.csv("data/trainHistory.csv")
testHistory <- read.csv("data/testHistory.csv")

full_train <- data.frame(cbind(add_train_feartures, trainHistory))
full_train[(is.na(full_train))] <- 0
sum(is.na(full_train))
str(full_train)



# convert repeater into 0:1
full_train$repeater <- as.character(full_train$repeater)
head(full_train$repeater)
full_train$repeater[full_train$repeater == 't'] <- 1
full_train$repeater[full_train$repeater == 'f'] <- 0
full_train$repeater <- as.integer(full_train$repeater)
#full_train$repeater <- as.factor(full_train$repeater)

str(full_train$repeater)


full_Test <- data.frame(cbind(additional_test_features_df_from_file, testHistory))

str(full_Test)
#### filter na in test set full:
sum(is.na(full_Test))
full_Test[(is.na(full_Test))] <- 0

# 
# test_set <- full_res[128045:160057, ]
# train_set <- full_res[1:128044, ]  
# 
# lm_tr <- lm(repeattrips ~ category + company + brand + amount + purchases + company_sum + company_purchases + brand_sum + brand_purchases, data = train_set)
# summary(lm_tr)
# 
# predict_test <- predict(lm_tr, test_set)
# summary(predict_test)
# predict_test[predict_test <1] <- 0
# predict_test[predict_test >=1] <- 1
# 
# table(predict_test, test_set$repeater)

## linear model for full train:
str(full_train)

# log regression
full_lm_model <- glm(as.factor(repeater) ~ category + company + brand + amount + purchases + company_sum + company_purchases + brand_sum + brand_purchases, data = full_train, family = "binomial")
summary(full_lm_model)

predict_fin <- predict(full_lm_model, full_Test, type="response")
head(predict_fin)


# linear regression
full_lm_model <- lm(repeattrips ~ category + company + brand + amount + purchases + company_sum + company_purchases + brand_sum + brand_purchases, data = full_train)
summary(full_lm_model)

predict_fin <- predict(full_lm_model, full_Test)
sc_predict <- scale(predict_fin)
summary(predict_fin)

# str(full_Test)
# predict_fin <- predict(full_lm_model, full_Test)
# head(predict_fin)
predict_fin[predict_fin < 0.9] <- 0
predict_fin[predict_fin >= 0.9] <- 1
# table(predict_fin)

# make first submission
write.table(cbind("id", "repeatProbability"), 'submission3.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",")
write.table(cbind(full_Test$id, predict_fin), 'submission3.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",", append=TRUE)


### svm model
library(e1071)
svn_model <- svm(repeater ~ category + company + brand + amount + purchases + company_sum + company_purchases + brand_sum + brand_purchases, data = full_train)
