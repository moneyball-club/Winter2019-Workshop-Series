## ================================================================================================================ ##
## R Introduction Workshop
## Moneyball - Winter 2020
## Presented by Quilvio Hernandez
## Adopted from Skidmore College MA 276, “Sports and Statistics.”, Lab 1
## ================================================================================================================ ##

## ================ ##
## Getting Started
## ================ ##

setwd("/Users/quilviohernandez/Desktop/code/github-repos/Winter2019-Workshop-Series/Fundamentals")

# Download data to work with
download.file("http://www.openintro.org/stat/data/mlb11.RData", destfile = "mlb11.RData")
# As you can see, this commnad takes a URL and downloads it, 
# placing the results where the destfile argument tells it to
load("mlb11.RData") 
# Note this variable will showup in your workspace environment in the top right (30 rows x 12 columns)
# Objects: some loaded, some created

## ================ ##
## The Data: 2011 Baseball Statistics
## ================ ##

mlb11
# Numbers on the left aren't part of table, they're just the index
# Spreadsheet/tables are called dataframes

# Dim tells you the dimensions of your dataframe. 
# This should be the same as what shows up in the top right.
dim(mlb11)
# We'll get back to the [1] later

# names() function gives you the names of the columns (or variables)
# Aside on function: a function usually has to given "arguments"
# "arguments" are what you tell the function to operate on
# In this case, the function names takes a dataframe as an argument
# and returns the column names
names(mlb11)

# Some RStudio build-in tools
# Auto-complete
# Environment Pane
# Data Viewer
# Many more!

## ================ ##
## Some Exploration
## ================ ##

# Access a single column using the '$' operator
mlb11$runs
# Try accessing the number of hits for each team!
mlb11$hits

# Did you notice the display is different from before?
# Before we had them in columns, but now it's listed out as a vector

# head() shows first 6 rows of data
head(mlb11)

# tail() shows last 6 rows of data
tail(mlb11)

# mosaic is a package made specifically to make R more accessible to students
# by making it more logical, consistent, while emphasizing the fundamental concepts
install.packages("mosaic")
# ONLY HAVE TO INSTALL A PACKAGE ONCE
# Every time after you initiallly install a package you will simply use the library() command
library(mosaic)
# Alternatively you can use the bottom right pane
# Can also use the require() function
# https://yihui.org/en/2014/07/library-vs-require/

# R is more than a calculator, it's a graphing calculator!
# R uses the '~' often for models. It should be defined as "is a function of"
# "y ~ x" would read as "y is a function of x"

# Show runs as a function of hits with the mlb11 dataset
xyplot(runs ~ hits, data=mlb11)

# You could be wondering how you were supposed to know what arguments to input
# To read what a function does use a question mark followed by the function
?xyplot
# Where'd our beautiful plot go??? Don't worry! You can toggle between the tabs

# Question! Is there an association between runs scored and hits? How would you describe it?

# Now let's look at the number of runs scored by itself
histogram( ~ runs, data=mlb11)
bwplot( ~ runs, data=mlb11)

# How can we describe the ~distribution~ of runs scored? What is the median?


## ================ ##
## Back to R as a Calculator
## ================ ##

# Texas Rangers HR + K
210+930 

# Can add entire columns together
mlb11$homeruns + mlb11$strikeouts
# Like we said last week, vector operations are often element-wise

# Don't forget PEMDAS
4*6+2
4*(6+2)

# Logical operators are really good for finding points of interest
# Return TRUE/FALSE
# Say we wanted to find all the teams that hit more than 200 homeruns 

mlb11$homeruns > 200
# Question! How can we figure out what teams these are?

## ================ ##
## Summaries and Tables
## ================ ##

# Someone give me a guess how we find summary statistics in R?
summary(mlb11$runs)

# Can use this information to find the IQR (not super important for our purposes)
# IQR is where 50% of the data lives
734 - 629

# Can compute these numbers individually
var(~runs, data=mlb11)
median(~runs, data=mlb11)

# Another view of statistics summary
favstats(~runs, data=mlb11)

# Can't take the same approach with categorical data
# We would use a sample frequency or relative frequency distribution
# tally counts the number of times each kind of response was given
mlb11$HighHR <- mlb11$homeruns >= 200
mlb11$HighHR
# Sample Frequency
tally(~ HighHR, data=mlb11)
# Relative Frequency Distribution
tally(~ HighHR, data=mlb11, format="proportion")
# Can anyone tell me what the format="proportion" argument did?
# Divided each column by 30
# Notice we made a new variable using the "$" operator and used "<-" to assign values to it. 
# We also did this last week. 

# Now let's make a barchart with of our new variable
barchart(tally(~HighHR, data=mlb11, margins=FALSE), horizontal=FALSE)
# Notice we nested R functions here, this could just as easily been 
HR <- tally(~ HighHR, data=mlb11, margins=FALSE)
barchart(HR, horizontal=FALSE)
# Any ideas why we would want to nest functions?

# Challenges:
# Create a numerical summary for stolen_bases and wins, and compute the interquartile range for each.

# Compute the relative frequency distribution for teams with at least 90 wins. How many teams reached
# 90 wins?

# The tally command can be used to tabulate any number of variables that you provide.
# What is shown in the following table? How many teams won 90 or more games and hit at least 200
# home runs?

tally(HighW ~ HighHR, data=mlb11, format="count")

## ================ ##
## How R thinks about data
## ================ ##

# We've mentioned that dataframes are spreadsheet like objects 
# and as a result, they have spreadsheet like row-column notation
# For example, to access the 6th column of the 7th row you could do something like
mlb11[7,6]
# What's the 6th column correspond to?
names(mlb11)
# mlb11[7,6] is showing the batting average of the 7th row
# What is that team? Let's find out
mlb11[7,1]

# To see the batting average for the first 10 teams, we could do
mlb11[1:10,6]
# Recall the ":" operator is equivalent to a "-" in English such as 1-10
1:10
# We could show the first ten rows of all variables with
mlb11[1:10,]
# If you don't place an argument it'll return all
mlb11[,6]
# Batting average of all
# Alternatively (and maybe easier),
mlb11$bat_avg

# Could also use this principle to look at specific instances in column
mlb11$bat_avg[7]
# We see this is the same as mlb11[7,6]

# Exercises

# 1. Describe the center, shape, and spread of the stolen_bases variable, using an appropriate plot and
# the appropriate metrics.
# 
# 2. A coach is interested in the link between stolen_bases and runs. Show the coach a scatter plot, and
# describe the association. As you make the plot, think carefully about which of these two variables is
# the explanatory variable (and which is the response).
# 
# 3. How can you change the x and y labels on your plots? How can you add a title? Use google to guide
# you, and update your plot in Question 2.
# 
# 4. Using visual evidence, find the variable that you think seems to boast the strongest association to runs.
# Consider any continuous variables between columns 3 (at_bats) and 12 (new_obs).
# 
# 5. What is the variance in the number of strikeouts for each team during the 2011 season?
#   
# 6. Make a new variable, high_BA, to represent teams that hit for a batting average of 0.270 or more. How
# many teams fit into this group?
#   
# 7. You can use favstats to get the summary statistics within each high_BA group, and bwplot() to make
# boxplots. For example, what appears to be the link between homeruns and high_BA? Do teams with
# higher batting averages tend to hit more home runs?
#   
# 8. Repeat the code above, only using stolen bases instead of homeruns. Does there appear to be a link
# between stolen bases and high_BA?
  
# This is just a quick introduction to some fundamental R and statistics concepts.
# We'll hope to take this knowledge and apply it to our project.