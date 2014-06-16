library(RJDBC)
vDriver = JDBC(driverClass="com.vertica.jdbc.Driver", classPath="/home/akornil/vertica/vertica-jdbc-7.0.1-0.jar")
vertica = dbConnect(vDriver, "jdbc:vertica://192.168.240.94:5433/Shoppers", "dbadmin", "vertica7")




###
# queries for trainsert:

main_q <- "select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from trainHistory A, offers B where A.offer = B.offer;"

### all time 

q1 <- "select T1.id, count(*) all_purchases_q, count(distinct(category)) diff_category_q, count(distinct(company)) diff_company_q, count(distinct(brand)) diff_brand_q from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from trainHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id group by T1.id;"

# same company:

q2 <- "select T1.id, count(*) same_company_q, count(distinct(category)) diff_category_same_company, count(distinct(brand)) diff_brand_same_company from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from trainHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercompany = T2.company group by T1.id;"

# same brand:

q3 <- "select T1.id, count(*) same_brand_q, count(distinct(category)) diff_category_same_brand, count(distinct(company)) diff_company_same_brand from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from trainHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand group by T1.id;"

# same category

q4 <- "select T1.id, count(*) same_category_q, count(distinct(brand)) diff_brand_same_category, count(distinct(company)) diff_company_same_category from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from trainHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category group by T1.id;"

# same company + category + brand

q5 <- "select T1.id, count(*) same_category_company_brand_q from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from trainHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company group by T1.id;"

# 1 month before

q6 <- "select T1.id, count(*) all_purchases_q_30, count(distinct(category)) diff_category_q_30, count(distinct(company)) diff_company_q_30, count(distinct(brand)) diff_brand_q_30 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from trainHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerdate - T2.transdate < 30 group by T1.id;"

q7 <- "select T1.id, count(*) same_company_q_30, count(distinct(category)) diff_category_same_company_30, count(distinct(brand)) diff_brand_same_company_30 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from trainHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 30 group by T1.id;"

q8 <- "select T1.id, count(*) same_category_q, count(distinct(brand)) diff_brand_same_category, count(distinct(company)) diff_company_same_category from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from trainHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerdate - T2.transdate < 30 group by T1.id;"


q9 <- "select T1.id, count(*) same_brand_q, count(distinct(category)) diff_category_same_brand, count(distinct(company)) diff_company_same_brand from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from trainHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand and T1.offerdate - T2.transdate < 30  group by T1.id;"

q10 <- "select T1.id, count(*) same_category_company_brand_q_30 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from trainHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 30 group by T1.id;"

# 2 month _before

q11 <- "select T1.id, count(*) all_purchases_q_60, count(distinct(category)) diff_category_q_60, count(distinct(company)) diff_company_q_60, count(distinct(brand)) diff_brand_q_60 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from trainHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerdate - T2.transdate < 60 group by T1.id;"

q12 <- "select T1.id, count(*) same_company_q_60, count(distinct(category)) diff_category_same_company_60, count(distinct(brand)) diff_brand_same_company_60 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from trainHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 60 group by T1.id;"

q13 <- "select T1.id, count(*) same_category_q_60, count(distinct(brand)) diff_brand_same_category_60, count(distinct(company)) diff_company_same_category_60 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from trainHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerdate - T2.transdate < 60 group by T1.id;"


q14 <- "select T1.id, count(*) same_brand_q_60, count(distinct(category)) diff_category_same_brand_60, count(distinct(company)) diff_company_same_brand_60 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from trainHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand and T1.offerdate - T2.transdate < 60  group by T1.id;"

# 3 month before

q15 <- "select T1.id, count(*) all_purchases_q_90, count(distinct(category)) diff_category_q_90, count(distinct(company)) diff_company_q_90, count(distinct(brand)) diff_brand_q_90 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from trainHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerdate - T2.transdate < 90 group by T1.id;"

# half a year

q16 <- "select T1.id, count(*) all_purchases_q_180, count(distinct(category)) diff_category_q_180, count(distinct(company)) diff_company_q_180, count(distinct(brand)) diff_brand_q_180 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from trainHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerdate - T2.transdate < 180 group by T1.id;"

main_part <- dbGetQuery(vertica, main_q)


part1 <- dbGetQuery(vertica, q1)



full_trainset <- merge(main_part, part1,by="id", all.x=TRUE)
names(full_trainset)


part2 <- dbGetQuery(vertica, q2)
full_trainset <- merge(full_trainset, part2, by = "id", all.x = TRUE)

part3 <- dbGetQuery(vertica, q3)
full_trainset <- merge(full_trainset, part3, by = "id", all.x = TRUE)

part4 <- dbGetQuery(vertica, q4)
full_trainset <- merge(full_trainset, part4, by = "id", all.x = TRUE)

part5 <- dbGetQuery(vertica, q5)
full_trainset <- merge(full_trainset, part5, by = "id", all.x = TRUE)

part6 <- dbGetQuery(vertica, q6)
full_trainset <- merge(full_trainset, part6, by = "id", all.x = TRUE)

part7 <- dbGetQuery(vertica, q7)
full_trainset <- merge(full_trainset, part7, by = "id", all.x = TRUE)

part8 <- dbGetQuery(vertica, q8)
full_trainset <- merge(full_trainset, part8, by = "id", all.x = TRUE)

part9 <- dbGetQuery(vertica, q9)
full_trainset <- merge(full_trainset, part9, by = "id", all.x = TRUE)

part10 <- dbGetQuery(vertica, q10)
full_trainset <- merge(full_trainset, part10, by = "id", all.x = TRUE)

part11 <- dbGetQuery(vertica, q11)
full_trainset <- merge(full_trainset, part11, by = "id", all.x = TRUE)

part12 <- dbGetQuery(vertica, q12)
full_trainset <- merge(full_trainset, part12, by = "id", all.x = TRUE)

part13 <- dbGetQuery(vertica, q13)
full_trainset <- merge(full_trainset, part13, by = "id", all.x = TRUE)

part14 <- dbGetQuery(vertica, q14)
full_trainset <- merge(full_trainset, part14, by = "id", all.x = TRUE)

part15 <- dbGetQuery(vertica, q15)
full_trainset <- merge(full_trainset, part15, by = "id", all.x = TRUE)

part16 <- dbGetQuery(vertica, q16)
full_trainset <- merge(full_trainset, part16, by = "id", all.x = TRUE)


full_trainset[is.na(full_trainset)] <- 0
full_trainset$repeater[full_trainset$repeater == 'f'] <- 0
full_trainset$repeater[full_trainset$repeater == 't'] <- 1

write.csv(full_trainset, file="complete_train.csv", row.names=FALSE)
