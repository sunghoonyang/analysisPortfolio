#food world cup analysis
library(readr)
library(ggplot2)
foodData <- read.csv('/Users/Abraxas/Documents/analysisPortfolio/foodWorldCup/pythonCleaned.csv')
foodData <- data.frame(foodData)
colnames(foodData)[c(1, 2, 3, 6, 48)] = c("ID", "Culinary Knowledge", "Culinary Skills", "Australia", "Census Location")
#amend the ascii error in the levels for Culinary Skills
levels(foodData[, "Culinary Skills"]) <- c("High", "None", "Low", "Moderate")

#following for loop achieves three things
# 1. complete totalScore vector which has the total score of each cuisine
# 2. complete noAnswer which counts the number of people who did not answer
foodData <- foodData[,-1]
max = 0
totalScore <- vector(mode = "numeric", length = 40)
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
totalScore
country_names <- names(foodData)[3:42]
for (name in country_names) {
  levels(foodData[,name]) <- c(0, 1, 2, 3, 4, 5, NA)
}
#change the household.income level to the right order
foodData[, "Household.Income"] <- relevel(foodData[, "Household.Income"], "$150,000+")
foodData[, "Household.Income"] <- relevel(foodData[, "Household.Income"], "$50,000 - $99,999")
foodData[, "Household.Income"] <- relevel(foodData[, "Household.Income"], "$25,000 - $49,999")
foodData[, "Household.Income"] <- relevel(foodData[, "Household.Income"], "$0 - $24,999")
foodData[, "Household.Income"] <- relevel(foodData[, "Household.Income"], "")
#I will make a "dashboard"-ish ranking with totalScore and noAnswer, as well as the ranking
tot_scores_country = data.frame(country_names, totalScore)
tot_scores_country["rank"] = rank(-tot_scores_country$totalScore, ties.method = "first")
tot_scores_country <- tot_scores_country[order(tot_scores_country$rank),]
no_answer <- data.frame(country_names, noAnswer)
ranking <- merge(tot_scores_country, no_answer, by = "country_names")
ranking <- ranking[order(ranking$rank),]
ranking_raw<- ggplot(ranking, aes(totalScore, noAnswer)) +
  geom_jitter() + geom_text(aes(label=country_names),hjust=0, vjust=0)
#Mexico Italy and States being the highest scoring cuisine makes you wonder about
#the evenness of the data. lets take a look at the sample population's regional backgounr
#what to do tomorrow: see if you can segment the data by culinary skills, area,and income blahbal

#mean from the people who did rate the food
mean_vals <- vector(mode = "numeric", length = 40)
mean_vals <- totalScore / (1282 - noAnswer)
mean_ranking <- data.frame(country = country_names, unknownness = noAnswer, average_score = mean_vals)
mean_jitter_national <- ggplot(mean_ranking, aes(mean_vals, noAnswer)) + geom_jitter() + geom_text(aes(label=country_names),hjust=0, vjust=0)
