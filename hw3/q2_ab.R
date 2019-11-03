# data
cr = as.numeric(strsplit(".48 40.53 2.19 .55 .74 .66 .93 .37 .22", " ")[[1]])
st = as.numeric(strsplit("12.57 73.68 11.13 20.03 20.29 .78 4.64 .43 1.08", " ")[[1]])
data = data.frame(cr, st)
n = nrow(data)
p = ncol(data)
m = colMeans(data)
inv_v = solve(var(data))

# meshgrid
outn = 100
devx = seq(from=-20, to=20, length.out=outn)
devy = seq(from=-30, to=30, length.out=outn)
x = rep(devx, outn)
dim(x) = c(outn, outn)
x = t(x)
dim(x) = c(outn * outn)
y = rep(devy, outn)
xy = matrix(c(x, y), outn * outn)

# a
q1 = apply(xy %*% inv_v * xy, 1, sum)
q1_crit = qf(0.90, p, n - p) / ((n - p) * n / p / (n - 1))
dim(q1) = c(outn, outn)

# b
fx = x ** 2 * n / var(cr)
fy = y ** 2 * n / var(st)
q2_crit =  qf(0.90, 1, n - 1)
q2 = (fx < q2_crit) & (fy<q2_crit)
dim(q2) = c(outn, outn)

# map back
devx = devx + m[1]
devy = devy + m[2]

# X11()
png("q2_ab.png")
# q2(a) and q2(b) plot
contour(devx, devy, q1, levels=c(q1_crit), label=c("Q1"), col="Blue", xlab="cr", ylab="st")
contour(devx, devy, q2, levels=c(1),       label=c("Q2"), col="Red", add=T)
title("90% of confindence")

# q3(d)
points(.30, 10)
text(.30, 10 ,labels = " (.30, 10)", adj=0)

dev.off()
# while(names(dev.cur()) !='null device') Sys.sleep(1)
