# Chapter 5.4 Lab - Cross Validation and the Bootstrap

# Textbook praticie from Section 4.6 
# Predicting the market

#load libraries
library("tibble")
library("dplyr")
library(ISLR)

#setting working directory for this, 
setwd(" set.. path... ")


# 5.3.1 The Validation Set Approach 
# Use this to estimate the test error rates 

library(ISLR)
library(boot)


set.seed(1)
train=sample(392,196) #Select a subet of 196 observations out of the original 392

#Fitting linear regression
lm.fit=lm(mpg~horsepower, data=Auto, subset = train)

attach(Auto)
mean((mpg-predict(lm.fit,Auto))[-train]^-2)

lm.fit2=lm(mpg~poly(horsepower,2), data=Auto, subset=train)
mean((mpg-predict(lm.fit2,Auto))[-train]^-2)

# 5.3.2. Leave-One-Out Cross Validation 

#LOOCV can autoamically be computed for any generalized model using the glm() and cv.glm() functions
# To do logistic regression, pass in family="binomial" into glm() but if we do glm() without family we get linear regression which is the lm() function

glm.fit=glm(mpg~horsepower, data=Auto)
coef(glm.fit)
glm.fit=glm(mpg~horsepower, data=Auto)

cv.err = cv.glm(Auto,glm.fit)  
cv.err$delta #vector containing the cross-validation results. # This is the LOOCV statistic. 

# Use a for loop to test different polys

cv.error = rep(0,5)
for (i in 1:5){
  glm.fit=glm(mpg~poly(horsepower,i), data=Auto)
  cv.error[i] = cv.glm(Auto,glm.fit)$delta[1]
  
}

# IN SUMMARY - We see a sharp drop in the estimated testMSE between the linaer and quadratic fist, but then no clear improvement from using higher-order polynomials
cv.error 


# 5.3.3 k-Fold Cross-Validation 
set.seed(17)
cv.error.10 = rep(0,10)
for (i in 1:10){
  glm.fit=glm(mpg~poly(horsepower,i), data=Auto)
  cv.error.10[i] = cv.glm(Auto, glm.fit, K=10)$delta[1]
}
cv.error.10
# We still see little evidence that using cubic or higher-order polynomial terms leads to lower test error than simply using a quadratic fit. 



