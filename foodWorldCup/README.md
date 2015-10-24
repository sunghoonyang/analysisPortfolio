<h1>Food World Cup</h1>
Hello world! this is my sample data analysis. Data is from fivethirtyeight.com. This analysis covers 3 actions
1. Data cleaning
2. Segmentation
3. Visualisation

<h2>Python Cleaner</h2>
Python cleaner reads in the file, changes the each column's header question for the country cuisine to simply the country name. <br>
<center>"Please rate how much you like the traditional cuisine of (name)." => "(name)"</center><br>
There are 48 columns. I delete the respondent ID, So I will output csv with 47 columns with the subsequent data attached to the respective column
with cleanUp.csv.

<h2>R Clean up</h2>
I prefer to use R to do heavylifting. All the factor columns are so defined, and we substitute all the "N/A" and "" (empty vals) with factor NA
I am also deleting the respondent with 40 or more missing answers, because these are essentially incomplete surveys. 
<h2>Visualisation</h2>
<img src = "./img/total_raw.png">
<h4>Jitter graph of n = 1282</h4><br>
exhibits an obvious inverse relationship. The more reknown the cuisine is, the higher the raw score, and lower the unknownness. We can also see that there is a gap between Cuban/Vietnamese cuisines and the other cuisines in the right-bottom corner of the graph. In this region we find all the cuisines that are perhaps more familiar to Americans - Irish, Spanish to Mexican and Italian. This suggests a confounding error we may commit should we take it to the face value the observations from the graph. This is because the graph may be severly swayed by the taste-buds of Americans only. (maybe I see this as a source of error because I'm not American) Let us look at the graph where we plot unknownness vs. average score. Average score is calculated by dividing total score gained by each country by the number of respondents that gave a score to a respective cuisine.
<img src = "./img/total_mean.png">
<h4>Jitter graph (mean score) of n = 1282</h4>
The above graph shows that if we weight the total score by the number of respondents, the cuisines such as English, German, and Russian slide to the left. This is because even though Americans are rather familiar with these cuisines, they are also known to be less tasty cuisines compared to the likes of Mexican, Chinese, and Italian. The countries that stay in bottom_right corner in this graph as well are the cuisines that we may have guessed: Japanese, Greek, French, Chinese, Mexican, Italian, followed by lesser-known, yet equally high-scoring Thai and Spanish cuisines.



