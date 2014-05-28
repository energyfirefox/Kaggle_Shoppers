library(RJDBC)


vDriver = JDBC(driverClass="com.vertica.jdbc.Driver", classPath="/home/akornil/vertica/vertica-jdbc-7.0.1-0.jar")
vertica = dbConnect(vDriver, "jdbc:vertica://192.168.240.94:5433/Shoppers", "dbadmin", "vertica7")




# chains_repeater <- dbGetQuery(vertica, "select repeater, chain, count(*) from testHistory group by chain, repeater order by chain;")
# str(chains_repeater)
# chains_repeater$chain <- as.factor(chains_repeater$chain)

# res <- vector()
get_additional_features <- function(userID){
  print(".....")
  print(userID)
  all_purchases <- dbGetQuery(vertica, paste("select count(distinct(category)) category, count(distinct(company)) company, 
                                             count(distinct(brand)) brand, sum(purchaseamount) amount, count(purchaseamount) purchases  
                                             from transactions where id =", userID, ";", sep = ''))
  
  company_purchases <- dbGetQuery(vertica, paste("select  sum(sum) company_sum, sum(count) company_purchases 
                                               from (select category, company, brand, sum(purchaseamount),
                                               count(purchaseamount)  from transactions where id =", userID,
                                                 "group by category, company, brand) A, (select category, company,
                                               brand from offers where offer in (select offer from testHistory 
                                               where id = ", userID, "))B  where A.company = B.company ;"))
  category_purchases <- dbGetQuery(vertica, paste("select  sum(sum) category_sum, sum(count) category_purchases 
                                               from (select category, company, brand, sum(purchaseamount),
                                               count(purchaseamount)  from transactions where id =", userID,
                                                  "group by category, company, brand) A, (select category, company,
                                               brand from offers where offer in (select offer from testHistory 
                                               where id = ", userID, "))B  where A.category = B.category;"))
  brand_purchases <-  dbGetQuery(vertica, paste("select  sum(sum) brand_sum, sum(count) brand_purchases 
                                               from (select category, company, brand, sum(purchaseamount),
                                               count(purchaseamount)  from transactions where id =", userID,
                                                "group by category, company, brand) A, (select category, company,
                                               brand from offers where offer in (select offer from testHistory 
                                               where id = ", userID, "))B  where A.brand = B.brand ;"))
  res <- c(all_purchases, company_purchases, category_purchases, brand_purchases)
  print("+++")
  return(res)
} 

testHistory <- dbGetQuery(vertica, "select * from testHistory;")

id_test_list <- testHistory$id

additional_test_features <- t(sapply(id_test_list, get_additional_features))
head(additional_test_features)
additional_test_features_df <- data.frame(additional_test_features)
write.table(additional_test_features, 'additional_test.csv', row.names = FALSE, sep = ",")
w
