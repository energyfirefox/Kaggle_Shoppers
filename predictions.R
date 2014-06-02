# more feateures:
library(RJDBC)

vDriver = JDBC(driverClass="com.vertica.jdbc.Driver", classPath="/home/akornil/vertica/vertica-jdbc-7.0.1-0.jar")
vertica = dbConnect(vDriver, "jdbc:vertica://192.168.240.94:5433/Shoppers", "dbadmin", "vertica7")

train_query <- "select D2.cat_comp_brand_sum from (select id, company, category, brand from trainHistory A, offers B where A.offer = B.offer) D1 LEFT OUTER JOIN
(select id, category, company, brand, sum(purchaseamount) cat_comp_brand_all, count(purchaseamount) cat_comp_brand_sum from transactions 
group by id, category, company, brand) D2 ON (D1.id = D2.id and D1.company = D2.company and D1.brand = D2.brand and D1.category = D2.category) order by D1.id;"

train_comp_brand_cat <- dbGetQuery(vertica, train_query)



# train section:
trainHistory <- read.csv("data/trainHistory.csv")
add_train_feartures <- read.csv("add_features.csv")
add_more_train <- read.csv("train_additional_features.csv")

full_train <- data.frame(cbind(trainHistory, add_train_feartures, add_more_train, train_comp_brand_cat$cat_comp_brand_sum))
full_train[(is.na(full_train))] <- 0
sum(is.na(full_train))

# convert repeater into 0:1
full_train$repeater <- as.character(full_train$repeater)
head(full_train$repeater)
full_train$repeater[full_train$repeater == 't'] <- 1
full_train$repeater[full_train$repeater == 'f'] <- 0
full_train$repeater <- as.integer(full_train$repeater)
#full_train$repeater <- as.factor(full_train$repeater)

str(full_train$repeater)
str(full_train)

# cross-validation set:

cv_size <- round(0.2*nrow(full_train))
cv_index <- sample(x=nrow(full_train), size=cv_size, replace=TRUE)

trainset <- full_train[-cv_index, ]
write.csv(trainset, "trainset.csv")
cvset <- full_train[cv_index, ]
write.csv(cvset, "cvaetr.csv")
# test section:

test_query <- "select D2.cat_comp_brand_sum from (select id, company, category, brand from testHistory A, offers B where A.offer = B.offer) D1 LEFT OUTER JOIN
(select id, category, company, brand, sum(purchaseamount) cat_comp_brand_all, count(purchaseamount) cat_comp_brand_sum from transactions 
group by id, category, company, brand) D2 ON (D1.id = D2.id and D1.company = D2.company and D1.brand = D2.brand and D1.category = D2.category) order by D1.id;"

test_comp_brand_cat <- dbGetQuery(vertica, test_query)
testHistory <- read.csv("data/testHistory.csv")
additional_test_features <- read.csv("additional_test.csv")
add_more_test <- read.csv("test_additional_features.csv")

full_Test <- data.frame(cbind(testHistory, additional_test_features, add_more_test, test_comp_brand_cat$cat_comp_brand_sum))

str(full_Test)
#### filter na in test set full:
sum(is.na(full_Test))
full_Test[(is.na(full_Test))] <- 0



## linear model testing:
str(trainset)
summary(cvset$company_category_brand_purchases)

full_lm_model <- lm(repeattrips ~ category + company + brand + amount + purchases + company_sum + company_purchases + brand_sum + brand_purchases + 
                      returnings + returnings_amount + company_returnings_sum + 
                      company_returnings_amount + brand_returnings_sum + brand_returnings_amount + company_brand_category_returnings_sum +
                      company_brand_category_returnings_amount + deals_amount  + company_deals + brand_deals + company_brand_category_deals_amount, data = trainset)
summary(full_lm_model)

predict_trips <- predict(full_lm_model, cvset)
predict_trips[predict_trips < 1] <- 0
predict_trips[predict_trips >= 1] <- 1



true_trips <- cvset$repeattrips
true_trips[true_trips < 1] <- 0
true_trips[true_trips >= 1] <- 1
table(predict_trips, true_trips)

(22295 + 633)/(22295 + 633 + 1179 + 7904)

predict_fin_trips <- predict(full_lm_model, full_Test)
predict_fin_trips[predict_fin_trips < 1] <- 0
predict_fin_trips[predict_fin_trips >=1] <- 1
table(predict_fin_trips)

write.table(cbind("id", "repeatProbability"), 'submission4.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",")
write.table(cbind(full_Test$id, predict_fin_trips), 'submission4.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",", append=TRUE)



# log regression
full_log_model <- glm(as.factor(repeater)  ~ category + company + brand + amount + purchases + company_sum + company_purchases + brand_sum + brand_purchases + 
                       returnings + returnings_amount + company_returnings_sum + train_comp_brand_cat.cat_comp_brand_sum +
                       company_returnings_amount + brand_returnings_sum + brand_returnings_amount + company_brand_category_returnings_sum +
                       company_brand_category_returnings_amount + deals_amount  + company_deals + brand_deals + company_brand_category_deals_amount, 
                      data = trainset, family = "binomial")
summary(full_log_model)

predict_fin <- predict(full_log_model, cvset, type="response")
predict_fin[predict_fin < 0.5] <- 0
predict_fin[predict_fin >= 0.5] <- 1
table(predict_fin, cvset$repeater)

# accuracy:
(21417 + 926) / (21417 + 926 + 1850 + 7818)

colnames(full_Test)[31] <- "train_comp_brand_cat.cat_comp_brand_sum"
write.csv(full_Test, "testset.csv")
predict_res <- predict(full_log_model, full_Test, type="response")
head(predict_res)
# make first submission
write.table(cbind("id", "repeatProbability"), 'submission7.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",")
write.table(cbind(full_Test$id, predict_res), 'submission7.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",", append=TRUE)


# rand_forest

library(randomForest)

rm_fit <- randomForest(factor(repeater) ~ category + company + brand + amount + purchases + company_sum + company_purchases + brand_sum + brand_purchases + 
                      returnings + returnings_amount + company_returnings_sum + 
                      company_returnings_amount + brand_returnings_sum + brand_returnings_amount + company_brand_category_returnings_sum +
                      company_brand_category_returnings_amount + deals_amount  + company_deals + brand_deals + company_brand_category_deals_amount + train_comp_brand_cat.cat_comp_brand_sum, 
                      data = trainset, importance=TRUE, ntree = 100)

last_sub <- predict(rm_fit, full_Test)
varImpPlot(rm_fit)
head(last_sub)
write.table(cbind("id", "repeatProbability"), 'submission7.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",")
write.table(cbind(full_Test$id, last_sub), 'submission7.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",", append=TRUE)


library(e1071)
sv_mod <- svm(y=factor(trainset$repeater), x=  trainset[ , c("category", "company",  "brand", "amount", "purchases", "company_sum", "company_purchases",
                                                             "brand_sum", "brand_purchases", "returnings", "returnings_amount", "company_returnings_sum", 
                "company_returnings_amount", "brand_returnings_sum", "brand_returnings_amount", "company_brand_category_returnings_sum", 
                "company_brand_category_returnings_amount", "deals_amount", "company_deals", "brand_deals", "company_brand_category_deals_amount", 
                "train_comp_brand_cat.cat_comp_brand_sum")], 
              data = trainset, kernel = "radial")

summary(sv_mod)

cv_pred <- predict(sv_mod, cvset[ , c("category", "company",  "brand", "amount", "purchases", "company_sum", "company_purchases",
                                      "brand_sum", "brand_purchases", "returnings", "returnings_amount", "company_returnings_sum", 
                                      "company_returnings_amount", "brand_returnings_sum", "brand_returnings_amount", "company_brand_category_returnings_sum", 
                                      "company_brand_category_returnings_amount", "deals_amount", "company_deals", "brand_deals", "company_brand_category_deals_amount", 
                                      "train_comp_brand_cat.cat_comp_brand_sum")])
table(cv_pred, cvset$repeater)
(23110 + 305)/(nrow(cvset))

final_pred <- predict(sv_mod, full_Test[ , c("category", "company",  "brand", "amount", "purchases", "company_sum", "company_purchases",
                                             "brand_sum", "brand_purchases", "returnings", "returnings_amount", "company_returnings_sum", 
                                             "company_returnings_amount", "brand_returnings_sum", "brand_returnings_amount", "company_brand_category_returnings_sum", 
                                             "company_brand_category_returnings_amount", "deals_amount", "company_deals", "brand_deals", "company_brand_category_deals_amount", 
                                             "train_comp_brand_cat.cat_comp_brand_sum")])
head(final_pred)
write.table(cbind("id", "repeatProbability"), 'submission_svm.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",")
write.table(cbind(full_Test$id, final_pred), 'submission_svm.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",", append=TRUE)
