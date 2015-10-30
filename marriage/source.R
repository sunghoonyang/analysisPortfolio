library(readr)
library(ggplot2)
library(vcd)
dt <- read_csv("/Users/Abraxas/documents/analysisPortfolio/marriage/data/sleeping-alone-data.csv")
###############
#Cleaning Data#
###############
#we don't need start/endDate
dt <- dt[,-1:-2]
df <- data.frame(dt)
#first row is the header row
names(df)[c(8:18)]<- df[1, 8:18]
names(df)[c(1:7,19:29)]<-c("status", "duration","freqSeperate", "youWhere", "", "partnerWhere", "","firstTime","sleeping.seperately.helps", "sleep.better.seperately", "sex.life.better", "job", "", "gender", "age", "income", "education", "location")
#and we don't need the first row
df <- df[-1,]
#replace specific answers to boolean
for (i in 1:nrow(df)) {
  for (j in c(8:18)) {
    if (df[i,j] != "") {
      df[i,j] <- TRUE
    }else {
      df[i,j] <- FALSE}
  }
}
#correcting factors
df$status[df$status == "Single, but cohabiting with a significant other" | df$status == "In a domestic partnership or civil union"] <- "in"
df$status[df$status == "Widowed" |df$status == "Separated" |df$status == "Divorced"] <- "out"
df$duration <- as.factor(df$duration)
levels(df$duration) <- c("NA", "<5", "<15", "<20", "<10", "<1", "20<")
df$duration <- factor(df$duration, levels(df$duration)[c(1,6,2,5,3,4,7)])
df$income <- as.factor(df$income)
levels(df$income) <- c("NA", "<25k", "<150k", "150k<", "<50k", "<100k")
df$income <- factor(df$income, levels(df$income)[c(1,2,5,6,3,4)])

#people who sleep with the partners seperately everyday
noSuccess <- subset(df, df[,"freqSeperate"] == "Every night" | df[,"freqSeperate"] = "A few times per week")
#count vs. their age
ggplot(noSuccess, aes(noSuccess$age)) + 
  geom_histogram() +
  ggtitle("Age distribution for people who sleep on\n seperate beds at least few times per week")
#mosaic of income vs. gender
Never <- subset(df, df[,"freqSeperate"] == "Never")
ggplot(Never, aes(Never$age)) + 
  geom_histogram() +
  ggtitle("Age distribution for people who sleep together")
