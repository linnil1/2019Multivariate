# data
cr = as.numeric(strsplit(".48 40.53 2.19 .55 .74 .66 .93 .37 .22", " ")[[1]])
st = as.numeric(strsplit("12.57 73.68 11.13 20.03 20.29 .78 4.64 .43 1.08", " ")[[1]])
data = data.frame(cr, st)
n = nrow(data)
p = ncol(data)
m = colMeans(data)
inv_v = solve(var(data))

# calculate distance
d = t(apply(data, 1, function(x) x - m))
dis = diag(d %*% inv_v %*% t(d))
dis
X11()
par(mfrow=c(1,2))
qqplot(qchisq(ppoints(500), df=p), dis,
       main = expression("Q-Q plot for" ~~ {chi^2}[nu == 2]), xlab="Chi-squared", ylab="sample", asp=1)
qqline(dis, distribution=function(x) qchisq(x, df=p), asp=1)

"Remove outline index=2"
data = data[c(-2),]
data
n = nrow(data)
p = ncol(data)
m = colMeans(data)
inv_v = solve(var(data))

# calculate distance
d = t(apply(data, 1, function(x) x - m))
dis = diag(d %*% inv_v %*% t(d))
dis
qqplot(qchisq(ppoints(500), df=p), dis,
       main = expression("(Outliner Removed)Q-Q plot for" ~~ {chi^2}[nu == 2]), xlab="Chi-squared", ylab="sample", asp=1)
qqline(dis, distribution=function(x) qchisq(x, df=p), asp=1)
while(names(dev.cur()) !='null device') Sys.sleep(1)
