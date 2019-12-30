#cluster
store=read.csv("data/ubereat_1201.csv", header=TRUE, sep=",")
store = store[store$postcode>=100 & store$postcode<200, ]
store=store[apply(store,1,function(x) !any(is.na(x))), ] #remove NA row
store=store[store$rate_num!=0,]
DATA=store[,c("food_mean","rate")]
food_med=median(DATA$food_mean)
rate_med=median(DATA$rate)
store$class=NA
store$class[store$food_mean>=food_med & store$rate>=rate_med]="high"
store$class[store$food_mean< food_med & store$rate< rate_med]="low"
store$class[store$food_mean< food_med & store$rate>=rate_med]="cp"
store$class[store$food_mean>=food_med & store$rate< rate_med]="bad"

write.csv(store,"data/uber_all4class.csv")

png("result/4class_median.png")
plot(store$food_mean,store$rate,col=factor(store$class),xlab="食物平均價格",ylab="商家評價",main="Cluster",pch=1)
legend(x="bottomright",legend=c("bad","cp","high","low"),col=1:4,pch=16)
dev.off()

#HC
d=dist(as.matrix(DATA)) 
hc=hclust(d) 
plot(hc)
rect.hclust(hc,k=3,border="red")
cut=cutree(hc, k=5)
png("result/4class_hclust.png")
plot(DATA,col=cut)
dev.off()

#k means
cl=kmeans(DATA,center=4,nstart=1)
png("result/4class_kmean.png")
plot(DATA, col=cl$cluster,main="k means")
points(cl$centers, col=1:6, pch=8)
dev.off()

# k-means normalized
DATA = scale(DATA)
cl=kmeans(DATA,center=4,nstart=1)
png("result/4class_kmean_norm.png")
plot(DATA, col=cl$cluster,main="k means")
points(cl$centers, col=1:6, pch=8)
dev.off()

# hclust normalized
d=dist(as.matrix(DATA)) 
hc=hclust(d) 
plot(hc)
rect.hclust(hc,k=3,border="red")
cut=cutree(hc, k=5)
png("result/4class_hclust_norm.png")
plot(DATA,col=cut)
dev.off()
