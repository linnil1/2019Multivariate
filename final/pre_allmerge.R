# 去除重複資料
TP=read.csv("data/ubereat_1201.csv",header=TRUE,sep=",")
nrow(TP)
length(unique(TP$uuid))
TP_table=unique(TP)
# write.csv(TP_table,"data/ubereat_1224_TP.csv")

#算各區平均
#calculate
# TP_table=read.csv("data/ubereat_1224_TP.csv",header=TRUE,sep=",")
data=TP_table[,c("postcode","food_mean","food_num","rate","rate_num")]
TP_mean=aggregate(data,by=list(postcode=data$postcode),FUN=mean)[,-1]
store_num=aggregate(data,by=list(postcode=data$postcode),FUN=length)[,1:2]
names(store_num)=c("postcode","store_num")
money_num=table(postcode=TP_table$postcode,TP_table$money)
money_num=as.data.frame(rbind(money_num))[,1:4]
names(money_num)=c("money1","money2","money3","money4")
money_num$postcode=rownames(money_num)
Distr=merge(TP_mean,store_num,by="postcode")
Distr=merge(Distr,money_num,by="postcode")
# write.csv(Distr,"data/District.csv")

#結合各式資料
#merge other data
# Distr=read.csv("data/District.csv",header=TRUE,sep=",")
per=read.csv("data/food_percentage.csv",header=TRUE,sep=",")[-1,2:4]
names(per)=c("postcode","cost_all","cost_outside")
crash=read.csv("data/crash_num.csv",header=TRUE,sep=",")
scooter=read.csv("data/scooter.csv",header=TRUE,sep=",")[-1,]
scooter=data.frame(postcode=scooter$postcode,scooter108=scooter$X108年.10月底)
income=read.csv("data/tax.csv",header=TRUE,sep=",")
income=data.frame(postcode=income$postcode,income=income$平均數)

DATA=merge(Distr,per,by="postcode")
DATA=merge(DATA,crash,by="postcode")
DATA=merge(DATA,scooter,by="postcode")
DATA=merge(DATA,income,by="postcode")
write.csv(DATA,"data/all_merged.csv")
