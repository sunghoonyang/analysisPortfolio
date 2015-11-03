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

#mosaic_status_income.png & mosaic_status_duration
dt <- subset(df, df[, "income"] != "NA")
dt <- subset(dt, dt[, "duration"] != "NA")
dt <- drop.levels(dt) 
dt$income <- factor(dt$income, levels(dt$income)[c(2,3,4,5,1)])
mosaic(~ status + income, dt)
dt$duration <- factor(dt$duration, levels(dt$duration)[c(2,3,4,5,1)])
mosaic(~ status + duration, dt)


#making mosaics; everyNight_incomeVSgender  & Never_incomeVSgender
Never <- subset(df, df[,"freqSeperate"] == "Never")
EveryNight <- subset(df, df[,"freqSeperate"] == "Every night")
Never <- subset(Never, Never[, "gender"] != "")
Never <- subset(Never, Never[, "income"] != "NA")
EveryNight <- subset(EveryNight, EveryNight[, "gender"] != "")
EveryNight <- subset(EveryNight, EveryNight[, "income"] != "NA")
Never <- drop.levels(Never) 
EveryNight <- drop.levels(EveryNight) 
Never$income <- factor(Never$income, levels(Never$income)[c(2,3,4,5,1)])
EveryNight$income <- factor(EveryNight$income, levels(EveryNight$income)[c(2,3,4,5,1)])
mosaic(~ gender + income, Never)
mosaic(~ gender + income, EveryNight)

#df - surveys with no response
totalResponse <- subset(df, df[,"freqSeperate"] != "NA") 
totalResponse <- subset(totalResponse, totalResponse[,"age"] != "")
ggplot(totalResponse, aes(totalResponse$age, fill = totalResponse$freqSeperate)) +
  geom_bar() +
  guides(fill=guide_legend(reverse=TRUE)) +
  ggtitle("Age versus sleeping intimacy")


#TODO tomorrow: count booleans answers to the specific reasons for sleeping on seperate beds,
#and use apply to do some things