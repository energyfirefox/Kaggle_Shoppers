library(RJDBC)
vDriver = JDBC(driverClass="com.vertica.jdbc.Driver", classPath="/home/akornil/vertica/vertica-jdbc-7.0.1-0.jar")
vertica = dbConnect(vDriver, "jdbc:vertica://192.168.240.94:5433/Shoppers", "dbadmin", "vertica7")

###
# queries for testsert:

main_q <- "select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer;"

### all time 

q1 <- "select T1.id, count(*) all_purchases_q, count(distinct(category)) diff_category_q, count(distinct(company)) diff_company_q, count(distinct(brand)) diff_brand_q from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id group by T1.id;"

# same company:

q2 <- "select T1.id, count(*) same_company_q, count(distinct(category)) diff_category_same_company, count(distinct(brand)) diff_brand_same_company from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercompany = T2.company group by T1.id;"

# same brand:

q3 <- "select T1.id, count(*) same_brand_q, count(distinct(category)) diff_category_same_brand, count(distinct(company)) diff_company_same_brand from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand group by T1.id;"

# same category

q4 <- "select T1.id, count(*) same_category_q, count(distinct(brand)) diff_brand_same_category, count(distinct(company)) diff_company_same_category from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category group by T1.id;"

# same company + category + brand

q5 <- "select T1.id, count(*) same_category_company_brand_q from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company group by T1.id;"

# 1 month before

q6 <- "select T1.id, count(*) all_purchases_q_30, count(distinct(category)) diff_category_q_30, count(distinct(company)) diff_company_q_30, count(distinct(brand)) diff_brand_q_30 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerdate - T2.transdate < 30 group by T1.id;"

q7 <- "select T1.id, count(*) same_company_q_30, count(distinct(category)) diff_category_same_company_30, count(distinct(brand)) diff_brand_same_company_30 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 30 group by T1.id;"

q8 <- "select T1.id, count(*) same_category_q_30, count(distinct(brand)) diff_brand_same_category_30, count(distinct(company)) diff_company_same_category_30 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerdate - T2.transdate < 30 group by T1.id;"


q9 <- "select T1.id, count(*) same_brand_q_30, count(distinct(category)) diff_category_same_brand_q_30, count(distinct(company)) diff_company_same_brand_q_30 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand and T1.offerdate - T2.transdate < 30  group by T1.id;"

q10 <- "select T1.id, count(*) same_category_company_brand_q_30 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 30 group by T1.id;"

# 2 month _before

q11 <- "select T1.id, count(*) all_purchases_q_60, count(distinct(category)) diff_category_q_60, count(distinct(company)) diff_company_q_60, count(distinct(brand)) diff_brand_q_60 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerdate - T2.transdate < 60 group by T1.id;"

q12 <- "select T1.id, count(*) same_company_q_60, count(distinct(category)) diff_category_same_company_60, count(distinct(brand)) diff_brand_same_company_60 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 60 group by T1.id;"

q13 <- "select T1.id, count(*) same_category_q_60, count(distinct(brand)) diff_brand_same_category_60, count(distinct(company)) diff_company_same_category_60 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerdate - T2.transdate < 60 group by T1.id;"


q14 <- "select T1.id, count(*) same_brand_q_60, count(distinct(category)) diff_category_same_brand_60, count(distinct(company)) diff_company_same_brand_60 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand and T1.offerdate - T2.transdate < 60  group by T1.id;"

q15 <- "select T1.id, count(*) same_category_company_brand_q_60 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 60 group by T1.id;"

# 3 month before

q16 <- "select T1.id, count(*) all_purchases_q_90, count(distinct(category)) diff_category_q_90, count(distinct(company)) diff_company_q_90, count(distinct(brand)) diff_brand_q_90 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerdate - T2.transdate < 90 group by T1.id;"


q17 <- "select T1.id, count(*) same_company_q_90, count(distinct(category)) diff_category_same_company_90, count(distinct(brand)) diff_brand_same_company_90 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 90 group by T1.id;"

q18 <- "select T1.id, count(*) same_category_q_90, count(distinct(brand)) diff_brand_same_category_90, count(distinct(company)) diff_company_same_category_90 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerdate - T2.transdate < 90 group by T1.id;"


q19 <- "select T1.id, count(*) same_brand_q_90, count(distinct(category)) diff_category_same_brand_90, count(distinct(company)) diff_company_same_brand_90 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand and T1.offerdate - T2.transdate < 90  group by T1.id;"

q20 <- "select T1.id, count(*) same_category_company_brand_q_90 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 90 group by T1.id;"

# half a year

q21 <- "select T1.id, count(*) all_purchases_q_180, count(distinct(category)) diff_category_q_180, count(distinct(company)) diff_company_q_180, count(distinct(brand)) diff_brand_q_180 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerdate - T2.transdate < 180 group by T1.id;"


q22 <- "select T1.id, count(*) same_company_q_180, count(distinct(category)) diff_category_same_company_180, count(distinct(brand)) diff_brand_same_company_180 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 180 group by T1.id;"

q23 <- "select T1.id, count(*) same_category_q_180, count(distinct(brand)) diff_brand_same_category_180, count(distinct(company)) diff_company_same_category_180 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerdate - T2.transdate < 180 group by T1.id;"


q24 <- "select T1.id, count(*) same_brand_q_180, count(distinct(category)) diff_category_same_brand_180, count(distinct(company)) diff_company_same_brand_180 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand and T1.offerdate - T2.transdate < 180  group by T1.id;"

q25 <- "select T1.id, count(*) same_category_company_brand_q_180 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 180 group by T1.id;"

# returnings:

q26 <- "select T1.id, count(*) all_returnings, count(distinct(category)) diff_returning_category, count(distinct(company)) diff_returning_company, count(distinct(brand)) diff_returning_brand from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T2.purchaseamount <= 0 group by T1.id;"

q27 <- "select T1.id, count(*) same_brand_returnings_30, count(distinct(category)) diff_category_same_brand_returnings_30, count(distinct(company)) diff_company_same_brand_retrurnings_30 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand  and T2.purchaseamount <= 0 and T1.offerdate - T2.transdate < 30  group by T1.id;"

q28 <- "select T1.id, count(*) same_brand_returnings_60, count(distinct(category)) diff_category_same_brand_returnings_60, count(distinct(company)) diff_company_same_brand_retrurnings_60 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand  and T2.purchaseamount <= 0 and T1.offerdate - T2.transdate < 60  group by T1.id;"

q29 <- "select T1.id, count(*) same_brand_returnings_90, count(distinct(category)) diff_category_same_brand_returnings_90, count(distinct(company)) diff_company_same_brand_retrurnings_90 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand  and T2.purchaseamount <= 0 and T1.offerdate - T2.transdate < 90  group by T1.id;"

q30 <- "select T1.id, count(*) same_category_company_brand_returnings from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T2.purchaseamount <= 0  group by T1.id;"

q31 <- "select T1.id, count(*) same_category_company_brand_returnings_30 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 30  and T2.purchaseamount <= 0  group by T1.id;"

q32 <- "select T1.id, count(*) same_category_company_brand_returnings_60 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 60  and T2.purchaseamount <= 0  group by T1.id;"

q33 <- "select T1.id, count(*) same_category_company_brand_returnings_90 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 90  and T2.purchaseamount <= 0  group by T1.id;"

q34 <- "select T1.id, count(*) same_category_company_brand_returnings_180 from 
(select id, repeater, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 180  and T2.purchaseamount <= 0  group by T1.id;"

main_part <- dbGetQuery(vertica, main_q)


part1 <- dbGetQuery(vertica, q1)



full_testset <- merge(main_part, part1,by="id", all.x=TRUE)
names(full_testset)

# merge_n_sets <- function(n1, n2){
#   for (i in n1:n2){
#     full_testset <- merge(full_testset, paste("part", i, sep=""), by = "id", all.x = TRUE)
#     print(full_testset)
#   }
# }


part2 <- dbGetQuery(vertica, q2)
full_testset <- merge(full_testset, part2, by = "id", all.x = TRUE)
names(part2)

part3 <- dbGetQuery(vertica, q3)
full_testset <- merge(full_testset, part3, by = "id", all.x = TRUE)

part4 <- dbGetQuery(vertica, q4)
full_testset <- merge(full_testset, part4, by = "id", all.x = TRUE)

part5 <- dbGetQuery(vertica, q5)
full_testset <- merge(full_testset, part5, by = "id", all.x = TRUE)

part7 <- dbGetQuery(vertica, q7)
full_testset <- merge(full_testset, part7, by = "id", all.x = TRUE)

part8 <- dbGetQuery(vertica, q8)
full_testset <- merge(full_testset, part8, by = "id", all.x = TRUE)

part9 <- dbGetQuery(vertica, q9)
full_testset <- merge(full_testset, part9, by = "id", all.x = TRUE)

part10 <- dbGetQuery(vertica, q10)
full_testset <- merge(full_testset, part10, by = "id", all.x = TRUE)

part11 <- dbGetQuery(vertica, q11)
full_testset <- merge(full_testset, part11, by = "id", all.x = TRUE)

part12 <- dbGetQuery(vertica, q12)
full_testset <- merge(full_testset, part12, by = "id", all.x = TRUE)

part13 <- dbGetQuery(vertica, q13)
full_testset <- merge(full_testset, part13, by = "id", all.x = TRUE)

part14 <- dbGetQuery(vertica, q14)
full_testset <- merge(full_testset, part14, by = "id", all.x = TRUE)

part15 <- dbGetQuery(vertica, q15)
full_testset <- merge(full_testset, part15, by = "id", all.x = TRUE)

part16 <- dbGetQuery(vertica, q16)
full_testset <- merge(full_testset, part16, by = "id", all.x = TRUE)

part17 <- dbGetQuery(vertica, q17)
full_testset <- merge(full_testset, part17, by = "id", all.x = TRUE)

part18 <- dbGetQuery(vertica, q18)
full_testset <- merge(full_testset, part18, by = "id", all.x = TRUE)

part19 <- dbGetQuery(vertica, q19)
full_testset <- merge(full_testset, part19, by = "id", all.x = TRUE)

part20 <- dbGetQuery(vertica, q20)
full_testset <- merge(full_testset, part20, by = "id", all.x = TRUE)

part21 <- dbGetQuery(vertica, q21)
full_testset <- merge(full_testset, part21, by = "id", all.x = TRUE)

part22 <- dbGetQuery(vertica, q22)
full_testset <- merge(full_testset, part22, by = "id", all.x = TRUE)

part23 <- dbGetQuery(vertica, q23)
full_testset <- merge(full_testset, part23, by = "id", all.x = TRUE)

part24 <- dbGetQuery(vertica, q24)
full_testset <- merge(full_testset, part20, by = "id", all.x = TRUE)

part25 <- dbGetQuery(vertica, q25)
full_testset <- merge(full_testset, part25, by = "id", all.x = TRUE)

part26 <- dbGetQuery(vertica, q26)
full_testset <- merge(full_testset, part26, by = "id", all.x = TRUE)

part27 <- dbGetQuery(vertica, q27)
full_testset <- merge(full_testset, part27, by = "id", all.x = TRUE)


part28 <- dbGetQuery(vertica, q28)
full_testset <- merge(full_testset, part28, by = "id", all.x = TRUE)

part29 <- dbGetQuery(vertica, q29)
full_testset <- merge(full_testset, part29, by = "id", all.x = TRUE)

part30 <- dbGetQuery(vertica, q30)
full_testset <- merge(full_testset, part30, by = "id", all.x = TRUE)

part31 <- dbGetQuery(vertica, q31)
full_testset <- merge(full_testset, part31, by = "id", all.x = TRUE)

part32 <- dbGetQuery(vertica, q32)
full_testset <- merge(full_testset, part32, by = "id", all.x = TRUE)


part33 <- dbGetQuery(vertica, q33)
full_testset <- merge(full_testset, part33, by = "id", all.x = TRUE)

part34 <- dbGetQuery(vertica, q34)
full_testset <- merge(full_testset, part34, by = "id", all.x = TRUE)


full_testset[is.na(full_testset)] <- 0
full_testset$repeater[full_testset$repeater == 'f'] <- 0
full_testset$repeater[full_testset$repeater == 't'] <- 1

write.csv(full_testset, file="complete_test.csv", row.names=FALSE)
