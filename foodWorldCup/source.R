#food world cup analysis
library(readr)
foodData <- read.csv('/Users/Abraxas/Documents/analysisPortfolio/foodWorldCup/pythonCleaned.csv')
colnames(foodData)[c(1, 2, 3, 6, 48)] = c("ID", "Culinary Knowledge", "Culinary Skills", "Australia", "Census Location")
#amend the ascii error in the levels for Culinary Skills
levels(foodData[, "Culinary Skills"]) <- c("High", "None", "Low", "Moderate")
#delete surveyees with no datum
 ###START FROM HERE (i'm trying to delete the surveyees that do not have any value from 4 to 43)
for ()
country_names <- names(foodData)[4:43]
for (name in country_names) {
  levels(foodData[,name]) <- c(0, 1, 2, 3, 4, 5, NA)
  foodData[, name] <- as.numeric(as.character(foodData[, name]))
}
#by now all the factors are now numeric!



#make ranking


#tournament
sum(foodData[,"Korea"])