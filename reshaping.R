### reshaping trainset:

trainset <- read.csv("enrich_train.csv")
test_set <- read.csv("enrich_test.csv")

str(trainset)


fullset <- rbind(trainset[,-c(5,6)], test_set)
str(fullset)


conv_quant <- function(input_vector){
  output_vector <- cut(input_vector, breaks=quantile(input_vector))
  levels(output_vector) <- c("1", "2", "3", "4")
  return(output_vector)
}

quantile(fullset$diff_chain)

new_full <- data.frame(fullset$id)

# quantilizing part
new_full$category <- conv_quant(fullset$category)
new_full$company <- conv_quant(fullset$company)
new_full$brand <- conv_quant(fullset$brand)
new_full$purchases <- conv_quant(fullset$purchases)
new_full$returnings <- conv_quant(fullset$returnings)
new_full$deals <- conv_quant(fullset$deals_amount)
new_full$diff_company <- conv_quant(fullset$diff_company)
new_full$diff_category <- conv_quant(fullset$diff_category)
new_full$diff_brand <- conv_quant(fullset$diff_brand)
new_full$diff_dept <- conv_quant(fullset$diff_dept)

# binary part:
new_full$company_purchases <- fullset$company_purchases
new_full$company_purchases[new_full$company_purchases > 1] <- 1

new_full$category_purchases <- fullset$category_purchases
new_full$category_purchases[new_full$category_purchases > 1] <- 1

new_full$brand_purchases <- fullset$brand_purchases
new_full$brand_purchases[new_full$brand_purchases > 1] <- 1

new_full$company_returnings <- fullset$company_returnings_amount
new_full$company_returnings[new_full$company_returnings > 1] <- 1

new_full$brand_returnings <- fullset$brand_returnings_amount
new_full$brand_returnings[new_full$brand_returnings > 1] <- 1

new_full$company_brand_category_returnings <- fullset$company_brand_category_returnings_amount
new_full$company_brand_category_returnings[new_full$company_brand_category_returnings > 1] <- 1

new_full$company_deals <- fullset$company_deals
fullset$company_deals[fullset$company_deals > 1] <- 1

new_full$brand_deals <- fullset$brand_deals
new_full$brand_deals[new_full$brand_deals > 1] <-1

new_full$company_brand_category_deals <- fullset$company_brand_category_deals_amount 
new_full$company_brand_category_deals[new_full$company_brand_category_deals > 1] <- 1

new_full$company_brand_category_purchases <- fullset$train_comp_brand_cat.cat_comp_brand_sum
new_full$company_brand_category_purchases[new_full$company_brand_category_purchases > 1] <- 1

new_full$diff_chain <- fullset$diff_chain
new_full$diff_chain[new_full$diff_chain != 1] <- 0

str(new_full)
colnames(new_full)[1] <- "id"
colnames(new_full)

# split again inot test and train:
train_reshaped <- new_full[1:nrow(trainset), ]
train_reshaped$repeater <- trainset$repeater
train_reshaped$repeattrips <- trainset$repeattrips

test_reshaped <- new_full[(nrow(trainset) +1):nrow(new_full), ]

write.csv(train_reshaped, "reshaped_train3.csv")
write.csv(test_reshaped, "reshaped_test3.csv")
