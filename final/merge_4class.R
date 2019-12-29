mdata=read.csv("data/all_merged.csv", header=TRUE, sep=",")
data=read.csv("data/uber_all4class.csv", header=TRUE, sep=",")

mdata = mdata[, !(colnames(mdata) %in% c("X", "name"))]

c4 = c("high", "low", "cp", "bad")
new_post = setNames(data.frame(matrix(ncol=length(mdata[, "postcode"]), nrow=4)), mdata[, "postcode"])
new_post[,] = 0
for (i in 1:4) {
    merge_post = as.data.frame(table(data[data[, "class"]==c4[i], "postcode"]))
    new_post[i, as.integer(merge_post[,1])] = as.integer(merge_post[,-1])
}

mdata
new_data = as.matrix(new_post) %*% as.matrix(mdata) / rowSums(new_post)
new_data = new_data[, !(colnames(new_data) %in% c("X", "postcode"))]
new_data = cbind(new_post, new_data)
new_data["num"] = rowSums(new_post)
new_data["post"] = length(mdata[, "postcode"])
new_data["class"] = c4
new_data
write.csv(new_data,"data/all4class.csv")

