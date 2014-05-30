library(RJDBC)

vDriver = JDBC(driverClass="com.vertica.jdbc.Driver", classPath="/home/akornil/vertica/vertica-jdbc-7.0.1-0.jar")
vertica = dbConnect(vDriver, "jdbc:vertica://192.168.240.94:5433/Shoppers", "dbadmin", "vertica7")

get_additional_features <- function(userID){
  print(".....")
  print(userID)
  company_brand_category_purchases <-  dbGetQuery(vertica, paste("select  sum(sum) company_category_brand_sum, sum(count) company_category_brand_purchases 
                                               from (select category, company, brand, sum(purchaseamount),
                                               count(purchaseamount)  from transactions where id =", userID,
                                                "group by category, company, brand) A, (select category, company,
                                               brand from offers where offer in (select offer from testHistory 
                                               where id = ", userID, "))B  where A.brand = B.brand  and A.brand = B.brand and A.category = B.category ;"))
  
  returnings <- dbGetQuery(vertica, paste("select   count(purchaseamount) returnings, sum(purchaseamount) returnings_amount 
                                           from transactions where id =", userID, " and purchaseamount < 0;", sep = ''))
  
  company_returnings <- dbGetQuery(vertica, paste("select sum(sum) company_returnings_sum, sum(count) company_returnings_amount
                                               from (select category, company, brand, sum(purchaseamount),
                                               count(purchaseamount)  from transactions where id =", userID,
                                               "and purchaseamount < 0 group by category, company, brand) A, (select category, company,
                                               brand from offers where offer in (select offer from trainHistory 
                                               where id = ", userID, "))B  where A.company = B.company ;"))
  
  brand_returnings <- dbGetQuery(vertica, paste("select  sum(sum) brand_returnings_sum, sum(count) brand_returnings_amount
                                               from (select category, company, brand, sum(purchaseamount),
                                               count(purchaseamount)  from transactions where id =", userID,
                                               "and purchaseamount < 0 group by category, company, brand) A, (select category, company,
                                               brand from offers where offer in (select offer from trainHistory 
                                               where id = ", userID, "))B  where A.brand = B.brand;"))
  
  company_brand_category_returnings <- dbGetQuery(vertica, paste("select  sum(sum) company_brand_category_returnings_sum, sum(count) company_brand_category_returnings_amount
                                               from (select category, company, brand, sum(purchaseamount),
                                               count(purchaseamount)  from transactions where id =", userID,
                                              "and purchaseamount < 0 group by category, company, brand) A, (select category, company,
                                               brand from offers where offer in (select offer from trainHistory 
                                               where id = ", userID, "))B  where A.brand = B.brand and A.company = B.company and A.category = B.category;"))
  
  
  deals <-  dbGetQuery(vertica, paste("select   count(purchaseamount) deals_amount 
                                           from transactions where id =", userID, " and purchaseamount = 0;", sep = ''))
  
  company_deals <- dbGetQuery(vertica, paste("select sum(count) company_deals
                                              from (select category, company, brand, count(purchaseamount)  
                                              from transactions where id =", userID,
                                             "and purchaseamount = 0 group by category, company, brand) A, (select category, company,
                                               brand from offers where offer in (select offer from trainHistory 
                                               where id = ", userID, "))B  where A.company = B.company ;"))
  brand_deals <- dbGetQuery(vertica, paste("select sum(count) brand_deals
                                              from (select category, company, brand, count(purchaseamount)  
                                              from transactions where id =", userID,
                                             "and purchaseamount = 0 group by category, company, brand) A, (select category, company,
                                               brand from offers where offer in (select offer from trainHistory 
                                               where id = ", userID, "))B  where A.brand = B.brand ;"))
  company_brand_category_deals <- dbGetQuery(vertica, paste("select sum(count) company_brand_category_deals_amount
                                              from (select category, company, brand, count(purchaseamount)  
                                              from transactions where id =", userID,
                                                            "and purchaseamount = 0 group by category, company, brand) A, (select category, company,
                                               brand from offers where offer in (select offer from trainHistory 
                                               where id = ", userID, "))B  where A.brand = B.brand and A.company = B.company and A.category = B.category;"))
  

  
  res <- c(company_brand_category_purchases, returnings, company_returnings, brand_returnings,  company_brand_category_returnings,  deals, company_deals, brand_deals,   company_brand_category_deals)
  print("+++")
  return(res)
} 

get_additional_features(86252)
get_additional_features(121067977)


trainingHistory <- dbGetQuery(vertica, "select * from trainHistory;")
train_id_list <- trainingHistory$id

testHistory <- dbGetQuery(vertica, "select * from testHistory;")
test_id_list <- testHistory$id

train_additional_features <- t(sapply(train_id_list, get_additional_features))
test_additional_features <- t(sapply(test_id_list, get_additional_features))

write.table(train_additional_features, 'train_additional_features.csv', row.names = FALSE, sep = ",")

write.table(test_additional_features, 'test_additional_features.csv', row.names = FALSE, sep = ",")
