data = read.csv("data/ubereat_1201.csv")
postcode = read.csv("data/postcode.csv")

# Taipei data
data = subset(data, postcode <= 116)[, c("postcode", "rate", "rate_num", "food_num", "food_mean")]
data_summary = aggregate(data, by=list(postcode=data$postcode), FUN=summary)

# find all postcode and it's name
codes = sort(unique(data[, "postcode"]))
district = c()
for (pcode in codes) {
    print(pcode)
    district = c(district, as.character(subset(postcode, code == pcode)$name))
}
district

# with food percentage
food = read.csv("data/food_percentage.csv")
store_num = aggregate(data, by=list(postcode=data$postcode), FUN=length)
store_num = store_num[, -2]
merge_store = merge(food, as.data.frame(store_num), by="postcode")
png("result/store_number_vs_food_precentage.png")
plot(food_num ~ 飲食費.含家外食物.占消費支出比率..., data=merge_store)

# with food rate
store_rate = aggregate(data, by=list(postcode=data$postcode), FUN=mean)
store_rate = store_rate[, -2]
merge_store = merge(food, as.data.frame(store_rate), by="postcode")
png("result/rate_vs_food_precentage.png")
plot(rate ~ 飲食費.含家外食物.占消費支出比率..., data=merge_store)
text(rate ~ 飲食費.含家外食物.占消費支出比率..., labels=rownames(district), data=merge_store, cex=0.9, font=2)

# plot
png("result/uber_rate.png", width=640, height=640)
data_rate = subset(data, rate_num > 0)
boxplot(rate ~ postcode, data=data_rate, names=district)

png("result/uber_rate_num.png", width=640, height=640)
boxplot(rate_num ~ postcode, data=data_rate, names=district)

png("result/uber_food_num.png", width=640, height=640)
boxplot(food_num ~ postcode, data=data, names=district)

png("result/uber_food_mean.png", width=640, height=640)
boxplot(food_mean ~ postcode, data=data, names=district)
head(data)
