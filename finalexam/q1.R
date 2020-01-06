library(psych)
data = read.csv("./GRADES.dat", header=T, sep="")
head(data)
data_cor = head(data)
fa_data = principal(data_cor, nfactors=3, rotate='varimax')
print(fa_data$loading, cutoff=.5)

a = colSums(fa_data$loadings ^2)
a$sdev = colSums(fa_data$loadings ^2)
screeplot(fa_data)
abline(h=1, col="red")




