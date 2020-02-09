# Moneyball 2020: Predicting the MVP Odds part 1: Webscraping 

# Today's goal: Acquire the data we will be working with for this project

# To achieve today's goal we will be webscraping data from wikipedia so lets get to it! 



# Step one: importing the packages. 
install.packages("rvest")
install.packages("xml2")
library(xml2)
library(rvest)


# Step two: Get URL containing information you want 
# Note: strings in R must be in double quotes ("")
url = "https://en.wikipedia.org/wiki/Major_League_Baseball_Most_Valuable_Player_Award"


# Step three:
url_contents = read_html(url) # Get HTML of page 
url_contents


# Step Four: Getting the table
mvp_table_html = html_node(url_contents, xpath ='//*[@id="mw-content-text"]/div/table[4]')
mvp_table_df = html_table(mvp_table_html) # get table of html table
View(mvp_table_df)

# Building off what we did last -- looking at the mvp_table we see that the dataframe mashes together all the mvps together
# Also, notice the strange symbols in the player's names... yeah we don't want that
# https://regex101.com/

mvp_table_df$`American League winner` <- gsub("[†§^()0-9]+", "", mvp_table_df$`American League winner`)
mvp_table_df$`National League winner` <- gsub("[†§^()0-9]+", "", mvp_table_df$`National League winner`)


tail(mvp_table_df$`American League winner`)


# Notice some have some trailing white space. These are multiple time winners, but that's not relevant for our model.
#https://stat.ethz.ch/R-manual/R-devel/library/base/html/trimws.html

mvp_table_df$`American League winner` <- trimws(mvp_table_df$`American League winner`, 
                                                which = "both", whitespace = "[ \t\r\n]")
mvp_table_df$`National League winner` <- trimws(mvp_table_df$`National League winner`, 
                                                which = "both", whitespace = "[ \t\r\n]")

# Now let's seperate the AL from the NL before moving forward.
# https://bookdown.org/ndphillips/YaRrr/slicing-dataframes.html

al_mvps = mvp_table_df[,c(1:4)]
nl_mvps = mvp_table_df[,c(1,5:7)]

head(al_mvps)
head(nl_mvps)

# Notice we run into a similar issue with the teams, but we only have to remove one character
# I'll leave this as a challenge


# Looks good! Let's move on (:
# Now let's get some data on these MVPs besides their names
# https://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=y&type=8&season=2019&month=0&season1=2019&ind=0
# https://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=y&type=8&season=2018&month=0&season1=2018&ind=0&team=&rost=&age=&filter=&players=&startdate=&enddate=
# https://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=y&type=8&season=2017&month=0&season1=2017&ind=0&team=&rost=&age=&filter=&players=&startdate=&enddate=  

# Repeat steps from last week
url = "https://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=y&type=8&season=2019&month=0&season1=2019&ind=0"

url_contents = read_html(url) # Get HTML of page 
url_contents

hitting_table_html = html_node(url_contents, xpath ='//*[@id="LeaderBoard1_dg1_ctl00"]')
hitting_table = html_table(hitting_table_html) # get table of html table
View(hitting_table)

# The rows are off so let's fix that.
headers <- hitting_table[2,]
headers

# Assign the row we want to the column headers
names(hitting_table) <- headers
names(hitting_table)

# Cut out the first three rows that we don't want
hitting_table <- hitting_table[-c(1:3),]
head(hitting_table)

# Create a new variable to track the years
hitting_table$Year <- 2019

# Take a look at what our dataframe looks like now
View(hitting_table)

# Testing a single step for the loop
# url = "https://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=y&type=8&season=2018&month=0&season1=2018&ind=0&team=&rost=&age=&filter=&players=&startdate=&enddate="
# url_contents = read_html(url) # Get HTML of page 
# url_contents
# 
# 
# hitting_table_html = html_node(url_contents, xpath ='//*[@id="LeaderBoard1_dg1_ctl00"]')
# to_add = html_table(hitting_table_html) # get table of html table
# View(to_add)
# 
# to_add <- to_add[-c(1:3),]
# names(to_add) <- headers
# to_add$Year <- 2018
# 
# dim(rbind(hitting_table, to_add))

# Creating range of years to loop through
x <- 1931:2018
x

# Introducing my best friend: the for loop
# For loops make repetitive tasks extremely simple 
# https://www.datamentor.io/r-programming/for-loop/

for (year in x) {
  url = paste0("https://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=y&type=8&season=",
               year,"&month=0&season1=",
               year,"&ind=0&team=&rost=&age=&filter=&players=&startdate=&enddate=")
  url_contents = read_html(url)
  
  hitting_table_html = html_node(url_contents, xpath ='//*[@id="LeaderBoard1_dg1_ctl00"]')
  to_add = html_table(hitting_table_html)
  
  to_add <- to_add[-c(1:3),]
  names(to_add) <- headers
  to_add$Year <- year
 
  hitting_table <- rbind(hitting_table, to_add) 
}

# Let's look at our results
View(hitting_table)

# We just grabbed 2670 rows of data in what? 30 seconds??
dim(hitting_table)


# Exercise: Webscrape the pitching data.
#https://www.fangraphs.com/leaders.aspx?pos=all&stats=pit&lg=all&qual=y&type=8&season=2019&month=0&season1=2019&ind=0
#https://www.fangraphs.com/leaders.aspx?pos=all&stats=pit&lg=all&qual=y&type=8&season=2018&month=0&season1=2018&ind=0&team=&rost=&age=&filter=&players=&startdate=&enddate=