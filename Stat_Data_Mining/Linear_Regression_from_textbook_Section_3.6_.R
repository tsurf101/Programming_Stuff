# Command + Shift + N creates a New File
# this is a test doc for Section 3.6 of the textbook starting on page 109

# ----------- Section 3.6 - Linear Regression -------------- 

library(MASS)
library(ISLR)

fix(Boston)
help("fix")
names(Boston)

?Boston # do this to figure out more about a dataset

# fitting a simple Linear Regression
lm.fit = lm(formula=medv~lstat, data=Boston)

# or can avoid data=Boston by doing this, 
attach(Boston)
# now this works, 
lm.fit=lm(medv~lstat)

# Below will give us some basic information 
lm.fit

# Use summary to get more detail about our fit
summary(lm.fit)

# Use names funciton in order to find out what other pieces of information are stored in lm.fit 
# We can use $ to extract but as also can usue coef() to access 

names(lm.fit)
coef(lm.fit)

# IN ORDER TO OBTAIN A CONFIDENCE INTERVAL for the coeffience estimates we can use the confint() command 
confint(lm.fit)

# Producing confidence itnervals and prediction intervals for the prediction of medv for a given value of lstat
predict(lm.fit, data.frame(lstat=c(5,10,15)), interval="confidence")
predict(lm.fit, data.frame(lstat=c(5,10,15)), interval="prediction")


