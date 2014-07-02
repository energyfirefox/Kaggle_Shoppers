# main idea:
# for every user find n similar users from training set.

# 1. select users_id from transactions:

library(RJDBC)
vDriver = JDBC(driverClass="com.vertica.jdbc.Driver", classPath="/home/akornil/vertica/vertica-jdbc-7.0.1-0.jar")
vertica = dbConnect(vDriver, "jdbc:vertica://192.168.240.94:5433/Shoppers", "dbadmin", "vertica7")

users_ids <- "select distinct(id) from transactions;"
ids_df  <- dbGetQuery(vertica, users_ids)
ids <- ids_df$id
head(ids)

# for every user in  ids get her transactions as vector "category + company + brand" and "brand"
getCategoryCompanyBrand <- function(userID){
  qet_query <- paste("select category, company, brand from transactions where id =", 
                     userID, 
                     " and transdate > (select max(transdate)-180   from transactions where id =",
                     userID,
                     ") group by company, category, brand;", sep ="")

  transactions_df <- dbGetQuery(vertica, qet_query)
  return(paste(transactions_df$category, "_", transactions_df$company, "_", transactions_df$brand, sep =""))
}


getBrand <- function(userID){
  qet_query <- paste("select distinct(brand) from transactions where id =",
                     userID,
                     "and transdate > (select max(transdate)-180   from transactions where id =",
                     userID,
                     ");")
  
  transactions_df <- dbGetQuery(vertica, qet_query)
  print(length(transactions_df$brand))
  return(as.character(transactions_df$brand))  
}


Sys.time()
list_cat_comp_brand <- sapply(ids, getCategoryCompanyBrand)
Sys.time()
save(list_cat_comp_brand, file="knn_data/list_cat_comp_brand.rda")

rm(list_cat_comp_brand)


t1 <- Sys.time()
list_brand <- sapply(ids, getBrand)
t2 <- Sys.time()
save(list_brand, file="knn_data/list_brand.rda")
load("knn_data/list_brand.rda")
names(list_brand) <- ids



tanimoto_similarity <- function(user1_ratings, user2_ratings){  
  common_items <- length(intersect(user1_ratings, user2_ratings))
  all_items <- length(union(user1_ratings, user2_ratings))
  similarity <- 0
  if (all_items > 0){
    similarity <- common_items/all_items
  }  
  return(similarity)  
}

head(ids)

tanimoto_similarity(list_brand[["86246"]], list_brand[["86252"]])
# 
# get_NN_users <- function(customerID, list_brand, similarity_function, neighbours=5){
#   customerID <- as.character(customerID)
#   current_ratings <- list_brand[[customerID]]
#   users_similarity <- sapply(list_brand, tanimoto_similarity, user2_ratings = current_ratings) 
#   recommendations <- data.frame(rec_names=names(users_similarity[1:neighbours]), rec_sim=users_similarity[1:neighbours])
#   recommendations$rec_names <- as.character(recommendations$rec_names)
#   min_ind <- which(recommendations$rec_sim == min(recommendations$rec_sim))
#   current_min <- min(recommendations$rec_sim)
# #   print(current_min)
# 
#   for (i in (neighbours+1):length(list_brand)){
#     if (as.numeric(users_similarity[i]) > current_min){      
#       recommendations$rec_names[min_ind] <- names(users_similarity)[i]
#       recommendations$rec_sim[min_ind] <- as.numeric(users_similarity[i])
#       current_min <- min(recommendations$rec_sim)
#     }
#   }
#   return(recommendations)
# }

get_NN_users <- function(customerID, list_brand, similarity_function, neighbours=5){
  customerID <- as.character(customerID)
  current_ratings <- list_brand[[customerID]]
  users_similarity <- sapply(list_brand, tanimoto_similarity, user2_ratings = current_ratings) 
  recommendations <- names(sort(users_similarity, decreasing=T)[2:(neighbours+1)])
  return(recommendations)
}

customerID <- "86246"

get_NN_users("86246", list_brand, similarity_function = tanimoto_similarity, 30)
system.time(recs <- get_NN_users("86246", list_brand, similarity_function = tanimoto_similarity, 30))


  


library(multicore)

part1 <- ids[1:100000]
part2 <- ids[100001:200000]
part3 <- ids[200001:311541]

mclapply(ids[1:10], get_NN_users, list_brand=list_brand, similarity_function = tanimoto_similarity, neighbours=30, mc.cores = 4)

Sys.time()
rec_part1 <- mclapply(part1, get_NN_users, list_brand=list_brand, similarity_function = tanimoto_similarity, neighbours=30, mc.cores = 4)
Sys.time()

# getCategoryCompanyBrand <- function(userID){
#   qet_query <- paste("select category, company, brand from transactions where id =", 
#                      userID, 
#                      " and transdate > (select max(transdate)-60   from transactions where id =",
#                      userID,
#                      ") group by company, category, brand;", sep ="")
#   
#   transactions_df <- dbGetQuery(vertica, qet_query)
#   return(paste(transactions_df$category, "_", transactions_df$company, "_", transactions_df$brand, sep =""))
# }
# 
# 
# getBrand <- function(userID){
#   qet_query <- paste("select distinct(brand) from transactions where id =",
#                      userID,
#                      "and transdate > (select max(transdate)-60   from transactions where id =",
#                      userID,
#                      ");")
#   
#   transactions_df <- dbGetQuery(vertica, qet_query)
#   print(length(transactions_df))
#   return(as.character(transactions_df$brand))  
# }
# 
# 
# Sys.time()
# list_cat_comp_brand <- sapply(ids, getCategoryCompanyBrand)
# Sys.time()
# save(list_cat_comp_brand, file="knn_data/list_cat_comp_brand_60.rda")
# 
# rm(list_cat_comp_brand)
