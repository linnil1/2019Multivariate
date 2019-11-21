data = read.csv("pilot.dat", header=F, sep="")
colnames(data) = list("group", "y1", "y2", "y3", "y4", "y5", "y6")

pc_data = princomp(data[2:7], cor=TRUE)
summary(pc_data, loadings=TRUE)
screeplot(pc_data, type="lines")
data_4pc = scale(data[2:7]) %*% pc_data$loadings[,1:4]
daat_4pc

library(psych)
data[,2:7] = scale(data[,2:7])
data_cov = cov(data[,2:7])
pfa = principal(data_cov, nfactors=3, rotate="varimax")
pfa$loadings

data_fa = fa(data_cov, nfactors=3, rotate="varimax", fm="pa", max.iter=10000)
data_fa
data_fa$loadings

# rmarkdown::render("hw5.Rmd")
