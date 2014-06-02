library(RJDBC)


vDriver = JDBC(driverClass="com.vertica.jdbc.Driver", classPath="/home/akornil/vertica/vertica-jdbc-7.0.1-0.jar")
vertica = dbConnect(vDriver, "jdbc:vertica://192.168.240.94:5433/Shoppers", "dbadmin", "vertica7")

train_query <- "select D2.cat_comp_brand_sum from (select id, company, category, brand from trainHistory A, offers B where A.offer = B.offer) D1 LEFT OUTER JOIN
(select id, category, company, brand, sum(purchaseamount) cat_comp_brand_all, count(purchaseamount) cat_comp_brand_sum from transactions 
group by id, category, company, brand) D2 ON (D1.id = D2.id and D1.company = D2.company and D1.brand = D2.brand and D1.category = D2.category) order by D1.id;"

train_comp_brand_cat <- dbGetQuery(vertica, train_query)
head(train_comp_brand_cat)
