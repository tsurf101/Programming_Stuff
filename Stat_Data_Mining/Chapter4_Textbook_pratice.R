# Textbook praticie from Section 4.6 
# Predicting the market

#load libraries
library("tibble")
library("dplyr")
library(ISLR)

#setting working directory for this, 
setwd("/Users/thomasserafin/Serafin_Documents/Cornell/Spring_2020/Statistical_Data_Mining/Labs/")

names(Smarket) # all the variables
dim(Smarket) #dimensions
summary(Smarket)

# The cor() function produces a matrix that contains all of the pairwise correlations among the predictors in a data set
cor(Smarket[,-9]) # Doing this because the direction variable is qualitative 

# As you can see from the output there is little correlation between today's returns and previous days' returns

attach(Smarket)
plot(Volume)

# 4.6.2 Logistic Regression 
# The goal is to fit a logistic regression model in order to predict Direction using Lag1 through lag5 and Volume. 

glm.fits = glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume, data=Smarket, family=binomial)
summary(glm.fits)

coef(glm.fits) # in order to access just the coefficients for this fitted model 
summary(glm.fits)$coef # OR CAN DO THIS 
summary(glm.fits)$coef[,4]

glm.probs=predict(glm.fits, type="response")
glm.probs[1:10]
# We are going to print the 1st 10 probabilities  

# The contrasts() funciton will show us that R has created a dummy variable with 1 for Up
contrasts(Direction)

# The following 2 commands createa  vector of class predictions based on whether the predicted probability of a market incrase is greater than or less than 0.5
glm.pred = rep("Down", 1250) # This creates a vector of 1,250 Down elements
glm.pred[glm.probs>0.5] = "Up" # This transforms any element to Up for which the predicted prob of a market increase exceeds 0.5

#The table() function can be used to produce a confusion matrix in order to determine how many observatioins were correctly or incorrectly classified ******
table(glm.pred, Direction)

(507+145) / 1250

mean(glm.pred==Direction)

#Our training error is ....
1 - mean(glm.pred==Direction) # Way tooo high!! 

# Now we will sepearte our data into testing and training in order to get a better fit
train=(Year<2005) #Vector of 1,250 elements corresponding to the observations in our data set. This is a Booelean vector
Smarket.2005 = Smarket[!train,] # a submatrix of the stock market data containing only the oberservations for which train is False
dim(Smarket.2005)
Direction.2005 = Direction[!train] 

#Fit a Logisitic regresion model using only the subset of the observations that correspond to dates before 2005, using the subset argument. 
glm.fits = glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume, data=Smarket, family=binomial, subset=train)
# Predicted probabilities of the stock market going up for each of the days in our test set (days in 2005)
glm.probs=predict(glm.fits, Smarket.2005, type="response")

glm.pred = rep("Down",252)
glm.pred[glm.probs>0.5]="Up"
table(glm.pred, Direction.2005)

mean(glm.pred==Direction.2005)

mean(glm.pred!=Direction.2005) # This computes the test set error rate

# Lets try refitting using the most significant values 
glm.fits = glm(Direction~Lag1+Lag2, data=Smarket, family=binomial, subset=train)
glm.probs=predict(glm.fits, Smarket.2005, type="response")
glm.pred = rep("Down",252)
glm.pred[glm.probs>0.5]="Up"
table(glm.pred, Direction.2005)

mean(glm.pred==Direction.2005) #This shows 56% of the daily movements have been correctly predicted. 


# 4.6.5 KNN
library(class)
train.X=cbind(Lag1,Lag2)[train,] #cbind() function (column bind) binds together Lag1 and Lag2
test.X=cbind(Lag1,Lag2)[!train,]
train.Direction=Direction[train]

set.seed(1)
knn.pred=knn(train.X, test.X, train.Direction,k=1)
table(knn.pred, Direction.2005)
(43+83)/252 # Our accuracy 

# Try increasing K now .... 











