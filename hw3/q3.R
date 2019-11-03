data = read.csv("T5_5_FBEETLES.DAT", header=F, sep="")
colnames(data) = list("Number", "group", "y1", "y2", "y3", "y4")

cols = c("y1", "y2", "y3", "y4")
p = length(cols)
data1 = subset(data, group==1)[,cols]
data2 = subset(data, group==2)[,cols]
n1 = nrow(data1)
n2 = nrow(data2)
mean1 = colMeans(data1)
mean2 = colMeans(data2)
var1 = var(data1)
var2 = var(data2)
varpool = (var1 * (n1 - 1) + var2 * (n2 - 1)) / (n1 + n2 - 2)

# parallelism
data1_d = data1[, 2:p] - data1[, 1:p-1]
data2_d = data2[, 2:p] - data2[, 1:p-1]
p_d = p - 1
mean1_d = colMeans(data1_d)
mean2_d = colMeans(data2_d)
var1_d = var(data1_d)
var2_d = var(data2_d)
varpool_d = (var1_d * (n1 - 1) + var2_d * (n2 - 1)) / (n1 + n2 - 2)
t2_d = n1 * n2 / (n1 + n2) * (mean1_d - mean2_d) %*% solve(varpool_d) %*% (mean1_d - mean2_d)
f_d = (n1 + n2 - p_d - 1) / p_d / (n1 + n2 - 2) * t2_d
fcrit_d = qf(0.95, p_d, n1 + n2 - p_d - 1)
t2_d
f_d
fcrit_d
if (f_d < fcrit_d) {
    print("Cannot Rejcet Parallelism")
} else
    print("Rejcet Parallelism")

# same level
sum1 = sum(mean1)
sum2 = sum(mean2)
sumpool = sum(varpool)
t_sum = abs(sum1 - sum2) / sqrt(sumpool * (1 / n1 + 1 / n2))
fcrit_sum = qt(1 - 0.05 / 2, n1 + n2 - 2)
if (t_sum < fcrit_sum) {
    print("Cannot Rejcet Same level effect")
} else
    print("Rejcet Same level effect")

# equal response
mean_eq = (mean1 * n1 + mean2 * n2) / (n1 + n2)
mean_eq = tail(mean_eq, p - 1) - head(mean_eq, p - 1)
t2_eq = (n1 + n2) * mean_eq %*% solve(varpool_d) %*% mean_eq
f_eq = (n1 + n2 - p) / p_d / (n1 + n2 - 2) * t2_eq
fcrit_eq = qf(0.95, p_d, n1 + n2 - 2)
if (f_eq < fcrit_eq) {
    print("Cannot Rejcet Equal response effect")
} else
    print("Rejcet Equal response effect")

X11()
plot(mean1, type="l", col="red", ylim=c(100, 300))
lines(mean2, type="l", col="green")
while(names(dev.cur()) !='null device') Sys.sleep(1)
