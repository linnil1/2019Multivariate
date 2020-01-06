
data = read.csv("./strength.dat", header=T, sep="\t")
head(data)
X = data[, c("X1", "X2", "X3", "X4")]
Y = data[, c("Y1", "Y2", "Y3", "Y4")]

library(CCA)
result <-cc(X,Y)
barplot(result$cor)
# plt.cc(result)
"Correlation"
result$cor
"X loadings"
result$xcoef
"Y loadings"
result$ycoef


nx = as.matrix(X) %*% result$xcoef[, 1]
ny = as.matrix(Y) %*% result$ycoef[, 1]
n = data.frame(nx, ny)
fit = lm(ny ~ nx, n)
summary(fit)


plot(nx, ny)



n = nrow(data)
dimx = ncol(X)
dimy = ncol(Y)
# Bartlett's test statistic as given by Equation 10.3
test =  -( n - 0.5 * (dimx + dimy + 3) ) * log(1 - result$cor[1])
# Computing p-value
test_p = pchisq(test, df=dimx + dimy - 1 + 1, lower.tail=FALSE)
test_p
