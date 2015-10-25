#########################
#police killing analysis#
#########################
library(readr)
library(ggplot2)
dt <- read.csv('/Users/Abraxas/Documents/analysisPortfolio/policeKilling/data/police_killings.csv')
#I'm going to use census tract as the geographical unit
#Things that may have association with police killings are: 
#armed?, age, gender, raceethnicity, month,day,tract, unemployment, poverty, and education (college)
#TODO: make 2~3 meaningful infographic