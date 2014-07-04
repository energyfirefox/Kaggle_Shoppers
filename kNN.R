load("knn_data/list_brand.rda")
load("knn_data/ids.rda")
names(list_brand) <-ids


tanimoto_similarity <- function(user1_ratings, user2_ratings){  
  common_items <- length(intersect(user1_ratings, user2_ratings))
  all_items <- length(union(user1_ratings, user2_ratings))
  similarity <- 0
  if (all_items > 0){
    similarity <- common_items/all_items
  }  
  return(similarity)  
}

get_NN_users <- function(customerID, list_brand, similarity_function, neighbours=5){
  customerID <- as.character(customerID)
  current_ratings <- list_brand[[customerID]]
  users_similarity <- sapply(list_brand, tanimoto_similarity, user2_ratings = current_ratings) 
  recommendations <- names(sort(users_similarity, decreasing=T)[2:(neighbours+1)])
  return(recommendations)
}

library(multicore)
#system.time(mclapply(ids[1:100], get_NN_users, list_brand=list_brand, similarity_function = tanimoto_similarity, neighbours=30, mc.cores = 4))

part1 <- ids[1:100000]
part2 <- ids[100001:200000]
part3 <- ids[200001:311541]

part2_1 <- ids[100001:120001]

recs <- mclapply(part2_1, get_NN_users, list_brand=list_brand, similarity_function = tanimoto_similarity, neighbours=30, mc.cores = 4)
rec <- data.frame(t(data.frame(recs)))
rec$user_id <- part2_1
write.csv(rec, "rec2_1.csv", row.names=FALSE)


head(ids)