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
mvp_table_html = html_node(url_contents, xpath ="//*[@id="mw-content-text"]/div/table[4]")
mvp_table_df = html_table(mvp_table_html) # get table of html table
View(mvp_table_df)
