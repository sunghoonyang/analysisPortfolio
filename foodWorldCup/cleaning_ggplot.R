#food world cup analysis
library(readr)
library(ggplot2)
foodData <- read.csv('/Users/Abraxas/Documents/analysisPortfolio/foodWorldCup/data/pythonCleaned.csv')
foodData <- data.frame(foodData)
#correct non-ascii strings
colnames(foodData)[c(1, 2, 3, 6, 48)] = c("ID", "Culinary Knowledge", "Culinary Skills", "Australia", "Census Location")
#amend the ascii error in the levels for Culinary Skills
levels(foodData[, "Culinary Skills"]) <- c("", "Low", "Moderate", "High")
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
png(paste0("/Users/Abraxas/Documents/analysisPortfolio/foodWorldCup/img/", "total_raw", ".png"))
print(ranking_raw)
dev.off()
#Mexico Italy and States being the highest scoring cuisine makes you wonder about the evenness of the data.
#lets take a look at unknownness-weighted scores (mean from the people who did rate the food)
mean_vals <- vector(mode = "numeric", length = 40)
mean_vals <- totalScore / (1282 - noAnswer)
mean_ranking <- data.frame(country = country_names, unknownness = noAnswer, average_score = mean_vals)
mean_jitter_national <- ggplot(mean_ranking, aes(mean_vals, noAnswer)) + geom_jitter() + geom_text(aes(label=country_names),hjust=0, vjust=0)
png(paste0("/Users/Abraxas/Documents/analysisPortfolio/foodWorldCup/img/", "total_mean", ".png"))
print(mean_jitter_national)
dev.off()
x-test-raw <- chisq.test(ranking[,2:3])
x-test-mean <- chisq.test(mean_ranking[,2:3])
#positive association between reknownness and mean score.... At this point I'm starting to think this is 
#"American perception of world cuisine" as opposed to food world cup. Let's try segmenting the data
#lets see if if the people who have reported the highest culinary skills have answered differently
#Segmentation method - pass in new_dt, which is segmented subset!!
segment_food <- function (new_dt) {
  scoreBoard <- vector(mode = "numeric", length = 40)
  unknownness <- vector(mode = "numeric", length = 40)
  for (j in (seq(from = 1, to = nrow(new_dt)))) {
    for (i in (seq(from = 1, to = ncol(new_dt)))) {
      #treatment of the country score section
      if (i >= 3 & i <= 42) {
        if (is.na(new_dt[j, i])) {
          naIsZero = 0
          unknownness[i - 2] <- unknownness[i - 2] + 1
        }  
        else {
          naIsZero <- as.numeric(as.character(new_dt[j, i]))
        }      
        scoreBoard[i - 2] <- scoreBoard[i - 2] + naIsZero
      }
    }
  }
  df <- data.frame(country.name = country_names, total.score = scoreBoard, unknownness = unknownness)
  raw_jitter <- ggplot(df, aes(total.score, unknownness)) + geom_jitter() + geom_text(aes(label=country_names),hjust=0, vjust=0)
  mean_vals <- scoreBoard / (nrow(new_dt) - unknownness)
  mean_df <- data.frame(country = country_names, unknownness = unknownness, average_score = mean_vals)
  mean_jitter <- ggplot(mean_df, aes(average_score, unknownness)) + geom_jitter() + geom_text(aes(label=country_names),hjust=0, vjust=0)
  rv <- list(raw_jitter, mean_jitter)
  return(rv)
}
##############
#Segmentation#
##############
#connoisseur def : reported knowledge is advanced
connoisseur <- subset(foodData, foodData[,1] == "Advanced") 
plots <- segment_food(connoisseur)
#rich def : reported income is >$100,000
rich <- subset(foodData, foodData[,45] %in% c("$100,000 - $149,999", "$150,000+"))
plots <- append(plots, segment_food(rich))
#chef def : reported skill is high
chef <- subset(foodData, foodData[,2] == "High") #turns out no one marked oneself "Advanced"
plots <- append(plots, segment_food(chef))
gg_names <- c("con_raw", "con_av", "rich_raw","rich_av", "chef_raw", "chef_av")
for (i in 1:6) {
  png(paste0("/Users/Abraxas/Documents/analysisPortfolio/foodWorldCup/img/", gg_names[i], ".png"))
  print(plots[i])
  dev.off()
}

