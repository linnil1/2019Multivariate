library(psych)

# data = read.csv("data/all_merged.csv", header=T, encoding="big5")
data = read.csv("data/all_merged_A.csv", header=T)
data = data[ , !(names(data) %in% c("X", "name", "postcode", "money4", "male10811", "female10811", "food_num_mean", "rate_num_mean", "cost_all"))]
head(data)

f <- fa(cov(data), nfactors=5)
print(f$loadings, cutoff=0.35)
summary(f)

png("FA_merge.png")
plot(f)
dev.off()
