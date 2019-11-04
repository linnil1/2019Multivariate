data = read.csv("spam.dat", header=T, sep=" ")

# stepwise
forward_aic = step(lm(Y ~ 1, data), paste("~", paste(colnames(data)[1:57], collapse="+")), data=data, direction="forward")
backward_aic = step(lm(Y ~ ., data), data=data, direction="forward")
print("Show stepwise result")
summary(forward_aic)
summary(backward_aic)

# separate data
n = nrow(data)
n13 = n %/% 3
data_train = data[1:n13 * 2,]
data_test  = data[(n13*2+1):n,]

# normalize data
mean_train = colMeans(data_train)
var_train = sqrt(diag(var(data_train)))
norm_train = t((t(data_train) - mean_train) / var_train)

# Calculate regression with different alpha
library("glmnet")
loss = c()
for (i in 0:10) {
    fit = cv.glmnet(as.matrix(norm_train[,1:57]), as.matrix(norm_train[,58]), alpha=i / 10)
    print("alpha")
    print(i)
    print("min lambda")
    print(fit$lambda.min)
    print("min loss")
    print(fit$cvm[which(fit$lambda == fit$lambda.min)])
    loss = c(loss, fit$cvm[which(fit$lambda == fit$lambda.min)])
}

# Find best Index
i = which(loss == min(loss))
print("index")
print(i)

# predict
fit = cv.glmnet(as.matrix(norm_train[,1:57]), as.matrix(norm_train[,58]), alpha=i/10)
norm_test = t((t(data_test) - mean_train) / var_train)
test_y = predict(fit, s=fit$lambda.min, newx=as.matrix(norm_test[, 1:57]))
mse = mean((test_y - norm_test[, 58]) ** 2)
print("MSE")
print(mse)
