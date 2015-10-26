#########################
#police killing analysis#
#########################
library(readr)
library(ggplot2)
dt <- read.csv('/Users/Abraxas/Documents/analysisPortfolio/policeKilling/data/police_killings.csv')
dt$namelsad <- as.numeric(substr(dt$namelsad, 14, 99))
#higher tract income may be the confounding factor, as not as many black or other races tend to live
#in the same neighborhood. So higher income tracts' crimes are committed by white. The higher the 
#unemployment and the lower the tract income level the more obvious the crimes committed by Blacks
#as opposed to other ethnicities.
f1 <- ggplot(dt, aes(dt$urate, dt$h_income, color=factor(dt$raceethnicity))) + 
  geom_point() +
  labs(x="Unemp", y="Tract Y", title="Unemployment rate vs. Tract income level") +
  theme(legend.title = element_text(colour="chocolate", size=16, face="bold")) +
  scale_color_discrete(name="Ethnicity")
#Hispanic/Latino police killings most seen in the south, black deaths are concentrated in the 
#Eastern half. White deaths are the only prevalent one throughout the states for the obvious
#reason that they form the majority of the population.
f2 <- ggplot(dt, aes(dt$longitude, dt$latitude, color=factor(dt$raceethnicity))) + 
      labs(x="", y="", title="Map of US tracked with Crimes!") +
      geom_jitter() + scale_color_discrete(name="Ethnicity") +
      theme_bw() +
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.border = element_blank(), panel.background = element_blank()) + 
      xlim(-130, -60) + ylim(20,55)
