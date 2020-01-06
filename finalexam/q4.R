data = read.csv("./food.dat", header=T, sep=" ")


# MA2 EM2 CA2 MA3 EM3 CA3 MA4 EM4 CA4 MA5 EM5 CA5
# I don't know how to split the sting in R so manually...
data[, "X"] = tp = c("MA", "EM", "CA", "MA", "EM", "CA", "MA", "EM", "CA", "MA", "EM", "CA")
data = cbind(data, num=c(2 ,2 ,2 ,3 ,3 ,3 ,4 ,4 ,4 ,5 ,5 ,5), MA=as.numeric(tp == "MA"), EM=as.numeric(tp == "EM"), CA=as.numeric(tp == "CA"))
data

X = data[, c("num", "MA", "EM", "CA")]
Y = data[,c("Bread", "Vegetables", "Fruit", "Meat", "Poultry", "Milk", "Wine")]

library("FactoMineR")
library("factoextra")
fit <-CA(X, Y, graph = FALSE)
print(fit)
fviz_ca_biplot(fit)
