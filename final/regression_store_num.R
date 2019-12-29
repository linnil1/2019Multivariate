data = read.csv("data/all_merged.csv")
fit = lm(store_num ~ income, data=data)
png("result/Regression_income_store_num.png")
plot(data[, "income"], data[, "store_num"])
abline(fit)

summary(fit)
