"
X2: M Mileage (in miles per gallone),
X8: W Weight (in pound),
X11: D Displacement(incubicinches),
X13: C Company headquarter (1 for U.S., 2 for Japan, 3 for Europe).
"
oridata = read.csv("cars.dat", sep="")
data = oridata[, c("M", "W", "D", "C")]
n = nrow(data)
data$C = factor(data$C)
fit = lm(M ~ W + D + C, data)

foward_aic = step(lm(M ~ 1, data), ~ W + D + C, data=data, direction="forward")
foward_bic = step(lm(M ~ 1, data), ~ W + D + C, data=data, direction="forward", k=log(n))
backward_aic = step(fit, data=data, direction="backward")
backward_bic = step(fit, data=data, direction="backward", k=log(n))
library(leaps)
fit_allset = regsubsets(M ~ ., data=data, intercept=TRUE, method="exhaustive")

library("SignifReg")
fit_adj = add1SignifReg(lm(M ~ 1, data), criterion="r-adj")

norm_data = scale(data[,1:3])
norm_data = data.frame(norm_data)
norm_data$C1 = data$C == 1
norm_data$C2 = data$C == 2
norm_data$C3 = data$C == 3
norm_data <- model.matrix( ~ .-1, data)

library(lars)
fit_lar <- cv.lars(as.matrix(norm_data[, 2:6]), as.matrix(norm_data[, 1]) ,type="lar")
X11()
plot(fit_lar)
while(names(dev.cur()) !='null device') Sys.sleep(1)

if (FALSE){
library(glmnet)
lambdas = 10^seq(2, -4, by = -.1)
fit_lasso = cv.glmnet(as.matrix(norm_data[, 2:6]), as.matrix(norm_data[, 1]), alpha=1, lambda=lambdas)
fit_ridge = cv.glmnet(as.matrix(norm_data[, 2:6]), as.matrix(norm_data[, 1]), alpha=0, lambda=lambdas)

test_x = as.matrix(norm_data[,2:6])
test_y = as.matrix(norm_data[,1])
pred_y = predict(fit_lasso, s=fit_lasso$lambda.1se, newx=test_x)
# R2
sum((test_y - pred_y) ** 2) / sum(var(test_y) * (n - 1))
fit_lasso$glmnet.fit$dev.ratio[which(fit_lasso$glmnet.fit$lambda == fit_lasso$lambda.min)]

}
