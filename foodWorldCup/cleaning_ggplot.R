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
    if (i %in% 3:42) {
      if (foodData[j, i] == "N/A" | foodData[j, i] == "") {
        naIsZero = 0
        noAnswer[i - 2] <- noAnswer[i - 2] + 1
      }  
      else {
        naIsZero = as.numeric(as.character(foodData[j, i]))
      }      
      totalScore[i - 2] <- totalScore[i - 2] + naIsZero
    }
    if (foodData[j, i] == "N/A" | foodData[j, i] == "") nullValue <- nullValue + 1
  }
  if (nullValue > 40) foodData <- foodData[-j,]
  if (max < nullValue) max <- nullValue
}
country_names <- names(foodData)[3:42]
for (name in country_names) {
  levels(foodData[,name]) <- c(0, 1, 2, 3, 4, 5, NA)
}
#change the household.income level to the right order
foodData[, 45] <- factor(foodData[,45], levels = c("", "$0 - $24,999", "$25,000 - $49,999", "$50,000 - $99,999", "$100,000 - $149,999", "$150,000+"))
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
chisq.test(ranking[,2:3])
chisq.test(mean_ranking[,2:3])
#positive association between reknownness and mean score.... At this point I'm starting to think this is 
#"American perception of world cuisine" as opposed to food world cup. Let's try segmenting the data
#lets see if if the people who have reported the highest culinary skills have answered differently

##########################
#Connoisseur Segmentation#
##########################

connoisseur <- subset(foodData, foodData[,2] == "High") #turns out no one marked oneself "Advanced"
totalScore_con <- vector(mode = "numeric", length = 40)
noAnswer_con <- vector(mode = "numeric", length = 40)
for (j in (seq(from = 1, to = nrow(connoisseur)))) {
  for (i in (seq(from = 1, to = ncol(connoisseur)))) {
    #treatment of the country score section
    if (i >= 3 & i <= 42) {
      if (is.na(connoisseur[j, i])) {
        naIsZero = 0
        noAnswer_con[i - 2] <- noAnswer_con[i - 2] + 1
      }  
      else {
        naIsZero <- as.numeric(as.character(connoisseur[j, i]))
      }      
      totalScore_con[i - 2] <- totalScore_con[i - 2] + naIsZero
    }
  }
}

foodData_con <- data.frame(country.name = country_names, totalScore = totalScore_con, unknownness = noAnswer)
jitter_raw_con<- ggplot(foodData_con, aes(totalScore, noAnswer)) + geom_jitter() + geom_text(aes(label=country_names),hjust=0, vjust=0)
mean_vals_con <- vector(mode = "numeric", length = 40)
mean_vals_con <- totalScore_con / (408 - noAnswer_con)
foodData_con_mean <- data.frame(country = country_names, unknownness = noAnswer_con, average_score = mean_vals_con)
mean_jitter_national_con <- ggplot(foodData_con_mean, aes(mean_vals_con, noAnswer_con)) + geom_jitter() + geom_text(aes(label=country_names),hjust=0, vjust=0)

#####################################
#Highest Income Bracket Segmentation#
#####################################
#definition of rich is  TRUE %in% (foodData[1, 45] == c("$100,000 - $149,999", "$150,000+"))
rich <- subset(foodData, foodData[,45] %in% c("$100,000 - $149,999", "$150,000+")) #turns out no one marked oneself "Advanced"
totalScore_rich <- vector(mode = "numeric", length = 40)
noAnswer_rich <- vector(mode = "numeric", length = 40)
for (j in (seq(from = 1, to = nrow(rich)))) {
  for (i in (seq(from = 1, to = ncol(rich)))) {
    #treatment of the country score section
    if (i >= 3 & i <= 42) {
      if (is.na(rich[j, i])) {
        naIsZero = 0
        noAnswer_rich[i - 2] <- noAnswer_rich[i - 2] + 1
      }  
      else {
        naIsZero <- as.numeric(as.character(rich[j, i]))
      }      
      totalScore_rich[i - 2] <- totalScore_rich[i - 2] + naIsZero
    }
  }
}

foodData_rich <- data.frame(country.name = country_names, totalScore = totalScore_rich, unknownness = noAnswer)
jitter_raw_rich<- ggplot(foodData_rich, aes(totalScore, noAnswer)) + geom_jitter() + geom_text(aes(label=country_names),hjust=0, vjust=0)
mean_vals_rich <- vector(mode = "numeric", length = 40)
mean_vals_rich <- totalScore_rich / (408 - noAnswer_rich)
foodData_rich_mean <- data.frame(country = country_names, unknownness = noAnswer_rich, average_score = mean_vals_rich)
mean_jitter_national_rich <- ggplot(foodData_rich_mean, aes(mean_vals_rich, noAnswer_rich)) + geom_jitter() + geom_text(aes(label=country_names),hjust=0, vjust=0)
