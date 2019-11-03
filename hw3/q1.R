"
X1: P Price,
X2: M Mileage (in miles per gallone),
X8: W Weight (in pound),
X9: L Length (in inches),
X13: C Company headquarter (1 for U.S., 2 for Japan, 3 for Europe).
"
oridata = read.csv("cars.dat", sep="")
data = oridata[, c("P", "M", "W", "L", "C")]

# draftman plot
X11()
pairs(data[1:4], main="Draftman Plot of car dataset", pch=21, bg=c("red", "green3", "blue")[c(data[5])$C])
while(names(dev.cur()) !='null device') Sys.sleep(1)

# boxplot
data["CP"] = data["M"] / data["P"]
X11()
boxplot(CP~C, data=data, names=c("U.S.", "Japan", "Europe"), main="Mileage / Price", horizontal=T)
title("Mileage / Price")
while(names(dev.cur()) !='null device') Sys.sleep(1)
