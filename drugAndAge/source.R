library(readr)
library(ggplot2)
library(vcd)
dt <- read_csv("/Users/Abraxas/documents/analysisPortfolio/drugAndAge/data/drug-use-by-age.csv")
dt[dt == "-"] <- NA
gg_names <- c("alcohol", "marijuana", "cocaine", "crack", "heroin", "hallucinogen", "inhalant", "pain-reliever", "oxycotin", "tranquilizer", "stimulant", "meth", "sedative")
for (i in seq( from =1, to = length(gg_names) ) ) {
    png(paste0("/Users/Abraxas/Documents/analysisPortfolio/drugAndAge/img/", gg_names[i], ".png"))
    a <- ggplot(dt, aes(x = age, y = dt[, 1 + i * 2])) +
      geom_point(aes(size = dt[, 2 + i * 2] )) +
      geom_smooth(method = "auto", aes(group = 1)) +
      theme(plot.title = element_text(face="bold", colour="#000000", size=14)) + 
      ggtitle(paste("Age and", gg_names[i], "use by frequency\n", sep = " ")) +
      theme(axis.title.x = element_text(face="bold", colour="#000000", size=14), axis.text.x  = element_text(angle=90, vjust=0.5, size=16)) + 
      xlab("Age") +
      theme(axis.title.y = element_text(face="bold", colour="#000000", size=14), axis.text.y  = element_text(angle=90, vjust=0.5, size=16)) +
      ylab("Substance use (% of pop.)\n") +
      scale_size_continuous(guide = guide_legend(title = "Frequency"))
    print(a)
    dev.off()
}  
a <- ggplot(dt, aes(x = age, y = dt$`alcohol-use`)) +
  geom_point(aes(size = dt$`alcohol-frequency` )) +
  geom_smooth(method = "auto", aes(group = 1)) +
  theme(plot.title = element_text(face="bold", colour="#000000", size=14)) + 
  ggtitle(paste("Age and", gg_names[1], "use by frequency\n", sep = " ")) +
  theme(axis.title.x = element_text(face="bold", colour="#000000", size=14), axis.text.x  = element_text(angle=90, vjust=0.5, size=16)) + 
  xlab("Age") +
  theme(axis.title.y = element_text(face="bold", colour="#000000", size=14), axis.text.y  = element_text(angle=90, vjust=0.5, size=16)) +
  ylab("Substance use (% of pop.)\n") +
  scale_size_continuous(guide = guide_legend(title = "Frequency"))
