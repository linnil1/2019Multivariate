library(alr3)

data = read.csv("data/ubereat_1201.csv")
postcode = read.csv("data/postcode.csv")

# Taipei data
data = subset(data, postcode <= 116)[, c("postcode", "food_mean")]

scooter = read.csv("data/scooter.csv")
tax = read.csv("data/tax.csv")

store_merge = merge(data, tax, by="postcode")
fit = lm(food_mean ~ 綜合所得總額, data=store_merge)
summary(fit)
pureErrorAnova(fit)

png("result/Regression_income_mean.png")
plot(store_merge[, "綜合所得總額"], store_merge[, "food_mean"])
abline(fit)
