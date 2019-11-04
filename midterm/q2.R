# read
data = read.csv("snow.dat", header=T, sep="")

# plot the lm result
fit = lm(x2 ~ x1, data)
summary(fit)
png("q2_1.png")
par(mfrow = c(2, 2))
plot(fit)
dev.off()

# scatterplot and regression line
png("q2_2.png")
plot(as.matrix(data["x1"]), as.matrix(data["x2"]))
lines(as.matrix(data["x1"]), as.matrix(fit$fitted.values))
dev.off()
