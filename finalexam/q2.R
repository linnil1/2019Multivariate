data = read.csv("./GRADES.dat", header=T, sep="")
head(data)
d = dist(data)
#  (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC).

method = c("ward.D", "ward.D2", "single", "complete", "average", "median")

for (i in 1:length(method)) {
    dc = hclust(d, method=method[i])
    memb = cutree(dc, k = 2)
    d1 = colMeans(data[memb == 1,])
    d2 = colMeans(data[memb == 2,])
    dd = t(data.frame(d1, d2))
    dd = data.frame(dd, len=c(sum(memb == 1), sum(memb == 2)))
    print(method[i])
    print(dd)
}
# dc = hclust(d, method="complete") # 77 17
# dc = hclust(d, method="ward.D") # 81 13
# dc = hclust(d, method="ward.D2") # 77 17
# dc = hclust(d, method="single") # 93 1
# dc = hclust(d, method="average") # 76 18

