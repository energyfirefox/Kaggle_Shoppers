library(RJDBC)
vDriver = JDBC(driverClass="com.vertica.jdbc.Driver", classPath="/home/akornil/vertica/vertica-jdbc-7.0.1-0.jar")
vertica = dbConnect(vDriver, "jdbc:vertica://192.168.240.94:5433/Shoppers", "dbadmin", "vertica7")

###
# queries for testsert:

main_q <- "select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer;"

### all time 

q1 <- "select T1.id, count(*) all_purchases_q, count(distinct(category)) diff_category_q, count(distinct(company)) diff_company_q, count(distinct(brand)) diff_brand_q from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id group by T1.id;"

# same company:

q2 <- "select T1.id, count(*) same_company_q, count(distinct(category)) diff_category_same_company, count(distinct(brand)) diff_brand_same_company from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercompany = T2.company group by T1.id;"

# same brand:

q3 <- "select T1.id, count(*) same_brand_q, count(distinct(category)) diff_category_same_brand, count(distinct(company)) diff_company_same_brand from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand group by T1.id;"

# same category

q4 <- "select T1.id, count(*) same_category_q, count(distinct(brand)) diff_brand_same_category, count(distinct(company)) diff_company_same_category from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category group by T1.id;"

# same company + category + brand

q5 <- "select T1.id, count(*) same_category_company_brand_q from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company group by T1.id;"

# 1 month before

q6 <- "select T1.id, count(*) all_purchases_q_30, count(distinct(category)) diff_category_q_30, count(distinct(company)) diff_company_q_30, count(distinct(brand)) diff_brand_q_30 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerdate - T2.transdate < 30 group by T1.id;"

q7 <- "select T1.id, count(*) same_company_q_30, count(distinct(category)) diff_category_same_company_30, count(distinct(brand)) diff_brand_same_company_30 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 30 group by T1.id;"

q8 <- "select T1.id, count(*) same_category_q_30, count(distinct(brand)) diff_brand_same_category_30, count(distinct(company)) diff_company_same_category_30 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerdate - T2.transdate < 30 group by T1.id;"


q9 <- "select T1.id, count(*) same_brand_q_30, count(distinct(category)) diff_category_same_brand_q_30, count(distinct(company)) diff_company_same_brand_q_30 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand and T1.offerdate - T2.transdate < 30  group by T1.id;"

q10 <- "select T1.id, count(*) same_category_company_brand_q_30 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 30 group by T1.id;"

# 2 month _before

q11 <- "select T1.id, count(*) all_purchases_q_60, count(distinct(category)) diff_category_q_60, count(distinct(company)) diff_company_q_60, count(distinct(brand)) diff_brand_q_60 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerdate - T2.transdate < 60 group by T1.id;"

q12 <- "select T1.id, count(*) same_company_q_60, count(distinct(category)) diff_category_same_company_60, count(distinct(brand)) diff_brand_same_company_60 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 60 group by T1.id;"

q13 <- "select T1.id, count(*) same_category_q_60, count(distinct(brand)) diff_brand_same_category_60, count(distinct(company)) diff_company_same_category_60 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerdate - T2.transdate < 60 group by T1.id;"


q14 <- "select T1.id, count(*) same_brand_q_60, count(distinct(category)) diff_category_same_brand_60, count(distinct(company)) diff_company_same_brand_60 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand and T1.offerdate - T2.transdate < 60  group by T1.id;"

q15 <- "select T1.id, count(*) same_category_company_brand_q_60 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 60 group by T1.id;"

# 3 month before

q16 <- "select T1.id, count(*) all_purchases_q_90, count(distinct(category)) diff_category_q_90, count(distinct(company)) diff_company_q_90, count(distinct(brand)) diff_brand_q_90 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerdate - T2.transdate < 90 group by T1.id;"


q17 <- "select T1.id, count(*) same_company_q_90, count(distinct(category)) diff_category_same_company_90, count(distinct(brand)) diff_brand_same_company_90 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 90 group by T1.id;"

q18 <- "select T1.id, count(*) same_category_q_90, count(distinct(brand)) diff_brand_same_category_90, count(distinct(company)) diff_company_same_category_90 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerdate - T2.transdate < 90 group by T1.id;"


q19 <- "select T1.id, count(*) same_brand_q_90, count(distinct(category)) diff_category_same_brand_90, count(distinct(company)) diff_company_same_brand_90 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand and T1.offerdate - T2.transdate < 90  group by T1.id;"

q20 <- "select T1.id, count(*) same_category_company_brand_q_90 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 90 group by T1.id;"

# half a year

q21 <- "select T1.id, count(*) all_purchases_q_180, count(distinct(category)) diff_category_q_180, count(distinct(company)) diff_company_q_180, count(distinct(brand)) diff_brand_q_180 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerdate - T2.transdate < 180 group by T1.id;"


q22 <- "select T1.id, count(*) same_company_q_180, count(distinct(category)) diff_category_same_company_180, count(distinct(brand)) diff_brand_same_company_180 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 180 group by T1.id;"

q23 <- "select T1.id, count(*) same_category_q_180, count(distinct(brand)) diff_brand_same_category_180, count(distinct(company)) diff_company_same_category_180 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerdate - T2.transdate < 180 group by T1.id;"


q24 <- "select T1.id, count(*) same_brand_q_180, count(distinct(category)) diff_category_same_brand_180, count(distinct(company)) diff_company_same_brand_180 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand and T1.offerdate - T2.transdate < 180  group by T1.id;"

q25 <- "select T1.id, count(*) same_category_company_brand_q_180 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 180 group by T1.id;"

# returnings:

q26 <- "select T1.id, count(*) all_returnings, count(distinct(category)) diff_returning_category, count(distinct(company)) diff_returning_company, count(distinct(brand)) diff_returning_brand from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T2.purchaseamount <= 0 group by T1.id;"

q27 <- "select T1.id, count(*) same_brand_returnings_30, count(distinct(category)) diff_category_same_brand_returnings_30, count(distinct(company)) diff_company_same_brand_retrurnings_30 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand  and T2.purchaseamount <= 0 and T1.offerdate - T2.transdate < 30  group by T1.id;"

q28 <- "select T1.id, count(*) same_brand_returnings_60, count(distinct(category)) diff_category_same_brand_returnings_60, count(distinct(company)) diff_company_same_brand_retrurnings_60 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand  and T2.purchaseamount <= 0 and T1.offerdate - T2.transdate < 60  group by T1.id;"

q29 <- "select T1.id, count(*) same_brand_returnings_90, count(distinct(category)) diff_category_same_brand_returnings_90, count(distinct(company)) diff_company_same_brand_retrurnings_90 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offerbrand = T2.brand  and T2.purchaseamount <= 0 and T1.offerdate - T2.transdate < 90  group by T1.id;"

q30 <- "select T1.id, count(*) same_category_company_brand_returnings from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T2.purchaseamount <= 0  group by T1.id;"

q31 <- "select T1.id, count(*) same_category_company_brand_returnings_30 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 30  and T2.purchaseamount <= 0  group by T1.id;"

q32 <- "select T1.id, count(*) same_category_company_brand_returnings_60 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 60  and T2.purchaseamount <= 0  group by T1.id;"

q33 <- "select T1.id, count(*) same_category_company_brand_returnings_90 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 90  and T2.purchaseamount <= 0  group by T1.id;"

q34 <- "select T1.id, count(*) same_category_company_brand_returnings_180 from 
(select id, category offercategory, company offercompany, brand offerbrand, quantity offerquantity, offervalue, offerdate from testHistory A, offers B where A.offer = B.offer) T1,
transactions T2 where T1.id = T2.id and T1.offercategory = T2.category and T1.offerbrand = T2.brand and T1.offercompany = T2.company  and T1.offerdate - T2.transdate < 180  and T2.purchaseamount <= 0  group by T1.id;"

main_part <- dbGetQuery(vertica, main_q)


part1 <- dbGetQuery(vertica, q1)



full_testset <- merge(main_part, part1,by="id", all.x=TRUE)
names(full_testset)


vector_queries <- c(q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16, q17, q18, q19, q20, q21, q22, q23, q24, q25, q26, q27, q28, q29, q30, q31, q32, q33, q34)


merge_n_sets <- function(n1, n2){
  for (i in n1:n2){    
    part <-  dbGetQuery(vertica, vector_queries[i])
    print(names(part))
    full_testset <- merge(full_testset, part, by = "id", all.x = TRUE)
    print(names(full_testset))
  }
  return(full_testset)
}
# 
# merge_n_sets(5, 34)
full_testset <- merge_n_sets(2, 34)



full_testset[is.na(full_testset)] <- 0


write.csv(full_testset, file="complete_test.csv", row.names=FALSE)
