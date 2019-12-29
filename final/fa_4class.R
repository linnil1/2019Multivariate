library(psych)
library(mltools)
library(data.table)

data = read.csv("data/all4class.csv", header=T)
data = data[ , !(names(data) %in% c("X", "X100", "X104", "X105", "X106", "X110", "X114", "X115", "X116", 
                                    "post_length", "name", "postcode",  "food_num_sum", "rate_num_sum", "cost_all"))]
# data = factor(data)
# data["class"] = factor(data["class"])
data = one_hot(data.table(data))
data

f <- fa(cov(data), nfactors=3)
print(f$loadings, cutoff=0.5)
summary(f)
