# read
data = read.csv("plasma.dat", header=T, sep="")
data1 = subset(data, group=="I")[, 2:4]
data2 = subset(data, group=="II")[, 2:4]

# Original
p = 3
n1 = nrow(data1)
n2 = nrow(data2)
m1 = colMeans(data1)
m2 = colMeans(data2)
v1 = var(data1)
v2 = var(data2)
vpool = (n1 * v1 + n2 * v2) / (n1 + n2)

# x[i+1] - x[i]
dp = 2
ddata1 = data1[, 2:3] - data1[, 1:2]
ddata2 = data2[, 2:3] - data2[, 1:2]
dm1 = colMeans(ddata1)
dm2 = colMeans(ddata2)
dv1 = var(ddata1)
dv2 = var(ddata2)
dvpool = (n1 * dv1 + n2 * dv2) / (n1 + n2)

# f test
t2_para = (n1 * n2) / (n1 + n2) * (dm1 - dm2) %*% solve(dvpool) %*% (dm1 - dm2)
f_para = (n1 + n2 - dp -1) / dp / (n1 + n2 - 2) * t2_para
fcrit_d = qf(.95, dp, n1 + n2 - dp - 1)
print("t2")
print(t2_para)
print("f")
print(f_para)
print("f critical")
print(fcrit_d)

# plot two groups
png("q3_1.png")
plot(as.matrix(m1), type="l", ylim=c(0, 200))
lines(m2, type="l", add=T)
dev.off()
