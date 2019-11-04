data = read.csv("pulpfiber.dat", header=T, sep="")

# lm
fit1 = lm(Y1 ~ X1 + X2 + X3 + X4, data)
fit2 = lm(Y2 ~ X1 + X2 + X3 + X4, data)
fit3 = lm(Y3 ~ X1 + X2 + X3 + X4, data)
fit4 = lm(Y4 ~ X1 + X2 + X3 + X4, data)
summary(fit1)
summary(fit2)
summary(fit3)
summary(fit4)

# print interval
print(predict(fit3, newdata=data.frame(X1=0.33, X2=45.5, X3=220,375, X4=1.01), interval = "confidence", level = 0.95))

