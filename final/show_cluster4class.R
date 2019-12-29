data=read.csv("data/all4class.csv", header=TRUE, sep=",")
c4 = c("high", "cp", "low", "bad")
c4chinese = c("高價位高評分","低價位高評價","低價位低評價","高價位低評價")
data = data[order(factor(as.character(data$class), levels=c4)),]


png("result/num_4class.png")
barplot(c(data[, "store_num"]),
        col = c(3, 2, 4, 1),
        names.arg=c4chinese,
        ylab="加權個數",
        main="Number")
dev.off()


png("result/rate_num_4class.png")
barplot(c(data[, "rate_num_mean"]),
        col = c(3, 2, 4, 1),
        names.arg=c4chinese,
        ylab="加權個數",
        main="Rate number")
dev.off()


col = c("cost_all","cost_inside", "cost_outside", "crash_num" ,"scooter10810","crash_scooter","d_scooter108","income","population10811")
chinese = c("總花費","家內飲食支出","外食支出","車禍次數" ,"機車總量","機車車禍次數","機車增減個數","收入","家戶數")

png("result/bar_4class.png", width = 24, height = 16, units="in", res = 400)
par(mfrow=c(3,3))
for (i in 1:9){
  barplot(c(data[, col[i]]),
          col = c(3, 2, 4, 1),
          names.arg=c4chinese,
          ylab="加權個數",
          main=chinese[i])
}
dev.off()
