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

# with food rate
store_num = aggregate(data, by=list(postcode=data$postcode), FUN=length)

scooter = read.csv("data/scooter.csv")
tax = read.csv("data/tax.csv")


store_mean = aggregate(data, by=list(postcode=data$postcode), FUN=mean)
store_mean = store_mean[, -2]
store_mean = store_mean[store_num[, 2] > 10,]
store_merge = merge(scooter, as.data.frame(store_mean), by="postcode")
store_merge = merge(store_merge, tax, by="postcode")
png("result/income_vs_price.png")
plot(food_mean ~ 綜合所得總額, data=store_merge)

