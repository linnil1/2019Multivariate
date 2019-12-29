mdata=read.csv("data/all_merged.csv", header=TRUE, sep=",")
data=read.csv("data/uber_all4class.csv", header=TRUE, sep=",")

mdata = mdata[, !(colnames(mdata) %in% c("X", "name"))]

# district related
# counting stores per class
c4 = c("high", "low", "cp", "bad")
new_post = setNames(data.frame(matrix(ncol=length(mdata[, "postcode"]), nrow=4)), mdata[, "postcode"])
new_post[,] = 0
for (i in 1:4) {
    sub_data = data[data[, "class"]==c4[i],]
    merge_post = as.data.frame(table(sub_data[, "postcode"]))
    new_post[i, as.integer(merge_post[,1])] = as.integer(merge_post[,-1])
}

# weighted add
mdata
new_data = as.matrix(new_post) %*% as.matrix(mdata) / rowSums(new_post)
new_data = new_data[, !(colnames(new_data) %in% c("X", "postcode"))]
new_data = cbind(new_post, new_data)
new_data["store_num"] = rowSums(new_post)
new_data["post_length"] = length(mdata[, "postcode"])
new_data["class"] = c4

# remove some unused data
new_data = new_data[, !(colnames(new_data) %in% c("X", "money1", "money2", "money3", "money4"))]
data = data[, !(colnames(data) %in% c("city", "X", "name", "category", "uuid", "money"))]

# store related
aggr = aggregate(data,by=list(data$class),FUN=mean)
aggr = aggr[order(factor(as.character(aggr$"Group.1"), levels=c4)),]
new_data[, c("food_mean_mean", "food_num_mean", "rate_mean", "rate_num_mean")] = 
    aggr[, c("food_mean", "food_num", "rate", "food_num")]
new_data[, c("food_num_sum", "rate_num_sum")] = new_data[, c("food_num_sum", "rate_num_sum")] * new_data[,"store_num"] 

new_data
write.csv(new_data,"data/all4class.csv")

