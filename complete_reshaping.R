train <- read.csv("complete_train.csv")
test <- read.csv("complete_test.csv")

train$offerdate <- as.character(train$offerdate)
train$offerdate <- as.Date(train$offerdate)


colnames(train)

reshaping_q_names1 <- c("all_purchases_q", "diff_category_q",  "diff_company_q", "diff_brand_q", "all_purchases_q_30", "diff_category_q_30",
                        "diff_company_q_30", "diff_brand_q_30","all_purchases_q_60", "diff_category_q_60",
                        "diff_company_q_60", "diff_brand_q_60", "all_purchases_q_90", "diff_category_q_90",
                        "diff_company_q_90", "diff_brand_q_90", "all_purchases_q_180", "diff_category_q_180",
                        "diff_company_q_180", "diff_brand_q_180")

reshaping_b1_names <- c("same_company_q", "diff_brand_same_company", "same_brand_q.x", "diff_category_same_company", "diff_brand_same_company", "same_brand_q.x", "diff_category_same_brand.x",
                       "diff_company_same_brand.x", "same_category_q.x", "diff_brand_same_category.x", "diff_company_same_category.x",
                       "same_category_company_brand_q", "same_company_q_30", "diff_category_same_company_30", "diff_brand_same_company_30",
                       "same_category_q.y", "diff_category_same_brand.y", "diff_company_same_brand.y", "same_category_company_brand_q_30",
                       "same_company_q_60", "diff_category_same_company_60", "diff_brand_same_company_60", "same_category_q_60",
                       "diff_brand_same_category_60", "diff_company_same_category_60", "same_brand_q_60", "diff_category_same_brand_60",
                       "diff_company_same_brand_60")




                    
fullset_q <- rbind(train[ ,reshaping_q_names1], test[ ,reshaping_q_names1])                
fullset_b <- rbind(train[ ,reshaping_b1_names], test[ ,reshaping_b1_names])


fullset_q[,1]
fullset_b[,1]

conv_quant <- function(input_vector){
  output_vector <- cut2(input_vector, g=4)
  levels(output_vector) <- c("0", "1", "2", "3")
  return(output_vector)
}

binarization <- function(input_vector){
  input_vector[input_vector > 1] <- 1
  return(input_vector)
}



conv_quant(fullset_q[,1])
binarization(fullset_b[,1])

reshaped_fullset_q <- data.frame(apply(fullset_q, 2, conv_quant))
reshaped_fullset_b <- data.frame(apply(fullset_b, 2, binarization))

reshaped_train <- train[, c("id", "repeater", "offervalue", "offerdate")]
reshaped_train <- cbind(reshaped_train, reshaped_fullset_q[1:nrow(train), ], reshaped_fullset_b[1:nrow(train), ])

reshaped_test <- test[,  c("id", "offervalue", "offerdate")]
reshaped_test <- cbind(reshaped_test, reshaped_fullset_q[(nrow(train)+1):nrow(fullset_b), ], reshaped_fullset_b[(nrow(train)+1):nrow(fullset_b), ])

write.csv(reshaped_train, "reshaped_comp_train.csv", row.names=FALSE)
write.csv(reshaped_test, "reshaped_comp_test.csv", row.names=FALSE)
str(train)

library(Hmisc)


str(train)

summary(train$same_company_q)


### train set: 
# offerdates in March + April, 109341:


### cv_set:
# offerdates from 20-04, 50716 :

## testset dates range:
# 2013-05-01: 2013-07-31
head(train$offerdate)
train_cut <- train[train$offerdate < '2013-04-20', ]
cv <- train[train$offerdate >= '2013-04-20', ]

colnames(train)
abandoned_vals <- c("offercategory", "offercompany", "offerbrand", "offerquantity", "offerdate")

train_cut <- train_cut[ ,-c(3:8)]
cv <- cv[ ,-c(3:8)]

str(train_cut)

plot(density(train_cut$all_purchases_q))

library(Hmisc)
library(ggplot2)

p <- ggplot(train, aes(id, repeater, col = cut2(train$all_purchases_q , g=4)))
p + geom_point()

table(cut2(train$all_purchases_q,g=4))
summary(train_cut$all_purchases_q)


        
library(caret)





featurePlot(train_cut[,-c(1,2)], train_cut$repeater)

preProc <- preProcess(train_cut[,-c(1,2)], method = "pca", thresh = 0.9)
preProc$numComp

train_cut$repeater <- as.factor(train_cut$repeater)

model_short <- train(repeater ~., data = train_cut[, -c(1)], preProcess="pca", method ="glm")
model_full <- train(repeater ~., data = train_cut[, -c(1)],  method ="glm")

summary(model_short)
summary(model_full)

non_pca <- predict(model_full, newdata=cv[,-c(1,2)])
pca <- predict(model_short, newdata=cv[,-c(1,2)])
head(non_pca)

non_pca <- predict(model_full, newdata=test[,-c(1:7)])
pca <- predict(model_short,  newdata=test[,-c(1:7)])

confusionMatrix(non_pca, as.factor(cv$repeater))
confusionMatrix(pca, as.factor(cv$repeater))

write.table(cbind("id", "repeatProbability"), 'pca.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",")
write.table(cbind(test$id, pca), 'pca.csv', quote=FALSE, col.names=FALSE, row.names=FALSE, sep = ",", append=TRUE)
