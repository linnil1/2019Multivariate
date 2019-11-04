# read
data = read.csv("hematology.dat", sep="")
colnames(data) <- c("y1", "y2", "y3", "y4", "y5", "y6")
n = nrow(data)
mean = colMeans(data)
data_m = t(t(data) - mean)
inv_cov = solve(var(data_m))

# Calculate distance
dist = data_m %*% inv_cov * data_m
dist = apply(dist, 1, function(x) sum(x))
print("Mahalanobis distance")
print(dist)

# QQplot
print("QQPlot")
png("q1_1.png")
qqplot(qchisq(ppoints(500), df=n), dist, main="QQplot")
qqline(dist, distribution=function(x) qchisq(x, df=n), asp=1)
dev.off()

# Boxplot
png("q1_4.png")
par(mfrow = c(1, 2))
boxplot(data)
boxplot(data[-3])
dev.off()

# Box plot(Normalize)
print("Boxplot")
print("mean")
print(mean)
print("variance")
print(diag(var(data_m)))
png("q1_2.png")
boxplot(t((t(data) - mean) / sqrt(diag(var(data_m)))), main="Normalized data")
dev.off()

# Search outliner
print("Outlier")
n_out = 4
outlier = which(dist >= sort(dist)[n - n_out])
dist_noout = dist[dist < sort(dist)[n - n_out]]
n_out = length(dist_noout)

# QQplot without outlier
png("q1_3.png")
qqplot(qchisq(ppoints(500), df=n_out), dist_noout, main="QQplot without outliner")
qqline(dist_noout, distribution=function(x) qchisq(x, df=n_out), asp=1)
dev.off()

