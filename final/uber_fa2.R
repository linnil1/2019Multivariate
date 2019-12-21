library(psych)
library(mltools)
library(data.table)

# read and select column
data = read.csv("data/ubereat_1201.csv", header=T)
data = data[data[, "postcode"] < 200,]

data[,"category"] = as.factor(data[,"category"])
data[,"city"] = as.factor(data[,"city"])
data[,"money"] = as.factor(data[,"money"])
data[,"postcode"] = as.factor(data[,"postcode"])
cname = c("category", "food_mean", "food_num", "food_q1", "food_q2", "food_q3",
          "food_var", "money", "rate", "rate_num", "postcode")


print(cname)
data = data[, cname]
data = one_hot(data.table(data))
# head(data)

cname = colnames(data)
cname = cname[colSums(data) != 0]
data = as.data.frame(data)[, c(cname)]

# factor analysis
f <- fa(data, nfactors=7)
print(f$loadings, cutoff=0.25)
