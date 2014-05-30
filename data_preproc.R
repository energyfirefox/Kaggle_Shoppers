library(RJDBC)


vDriver = JDBC(driverClass="com.vertica.jdbc.Driver", classPath="/home/akornil/vertica/vertica-jdbc-7.0.1-0.jar")
vertica = dbConnect(vDriver, "jdbc:vertica://192.168.240.94:5433/Shoppers", "dbadmin", "vertica7")




# chains_repeater <- dbGetQuery(vertica, "select repeater, chain, count(*) from trainHistory group by chain, repeater order by chain;")
# str(chains_repeater)
# chains_repeater$chain <- as.factor(chains_repeater$chain)

userID <- 1000
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
                                               brand from offers where offer in (select offer from trainHistory 
                                               where id = ", userID, "))B  where A.company = B.company ;"))
  category_purchases <- dbGetQuery(vertica, paste("select  sum(sum) category_sum, sum(count) category_purchases 
                                               from (select category, company, brand, sum(purchaseamount),
                                               count(purchaseamount)  from transactions where id =", userID,
                                                  "group by category, company, brand) A, (select category, company,
                                               brand from offers where offer in (select offer from trainHistory 
                                               where id = ", userID, "))B  where A.category = B.category;"))
  brand_purchases <-  dbGetQuery(vertica, paste("select  sum(sum) brand_sum, sum(count) brand_purchases 
                                               from (select category, company, brand, sum(purchaseamount),
                                               count(purchaseamount)  from transactions where id =", userID,
                                                "group by category, company, brand) A, (select category, company,
                                               brand from offers where offer in (select offer from trainHistory 
                                               where id = ", userID, "))B  where A.brand = B.brand ;"))
  res <- c(all_purchases, company_purchases, category_purchases, brand_purchases)
  print("+++")
  return(res)
} 

trainingHistory <- dbGetQuery(vertica, "select * from trainHistory;")

id_list <- trainingHistory$id

additional_features <- t(sapply(id_list, get_additional_features))
additional_features1 <- data.frame(additional_features)
head(additional_features1)
trainingHistory_full <- cbind(trainingHistory, additional_features1)
head(trainingHistory_full)
write.table(additional_features, "add_features.csv", sep = ",", row.names=FALSE)
rm(additional_features1)


