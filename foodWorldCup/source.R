library(readr)
library(ggplot2)
foodData <- read.csv('/Users/Abraxas/Documents/analysisPortfolio/foodWorldCup/data/r_cleaned.csv')
foodData <- data.frame(foodData)
##national scores with respect to the income leve, culinary knowledge/skills, AND area
skills <- vector(mode = "numeric", length = 40)
knowledge <- vector(mode = "numeric", length = 40)
area <- vector(mode = "numeric", length = 40)
noAnswer <- vector(mode = "numeric", length = 40)
for (j in (seq(from = 1, to = nrow(foodData)))) {
  nullValue = 0
  for (i in (seq(from = 1, to = ncol(foodData)))) {
    #treatment of the country score section
    if (i >= 3 & i <= 42) {
      if (foodData[j, i] == "N/A" | foodData[j, i] ==  "") {
        naIsZero = 0
        noAnswer[i - 2] <- noAnswer[i - 2] + 1
      }  
      else {
        naIsZero = as.numeric(as.character(foodData[j, i]))
      }      
      totalScore[i - 2] <- totalScore[i - 2] + naIsZero
    }
    if (foodData[j, i] == "N/A" | foodData[j, i] ==  "") nullValue <- nullValue + 1
  }
  if (nullValue > 40) foodData <- foodData[-j,]
  if (max < nullValue) max <- nullValue
}