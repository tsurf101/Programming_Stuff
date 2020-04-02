# Chapter 8 - Tree Based Methods Pratice Lab

library(tree)
library(ISLR)
attach(Carseats)

# Our problem is that Sales is a contioues variable so translate this into a binary variable by doing the following
High = ifelse(Sales <=8, "No", "Yes")

# Using data.frame() in order to merge high data with rest of the Carseats data
Carseats = data.frame(Carseats,High)

# fitting model below, 
# We fit a classification treet in order to predict High using all variables but Sales
tree.carseats = tree(High~.-Sales, Carseats)

summary(tree.carseats)

# Misclassifcation error rate = training error rate 
plot(tree.carseats)
text(tree.carseats,pretty=0)

# Shows the breakdown below 
tree.carseats

# We need to calc the test error 
set.seed(2)
train=sample(1:nrow(Carseats), 200)
Carseats.test=Carseats[-train,]
High.test = High[-train]
tree.carseats = tree(High~.-Sales, Carseats, subset=train)
tree.pred = predict(tree.carseats, Carseats.test, type="class")
results_table <- table(tree.pred, High.test)
results_table

(results_table[1,1] + results_table[2,2]) / 200

# consider whether prunning the tree might lead to improved results. 
# cv.tree() performs CV in order to determine the optimal level of tree complexity 
# FUN=prune.misclass , this argument tells us that we want to use the classificatione error rate to guide the CV and prunning process
# ^ Rather than the default which is deviance

set.seed(3)
cv.carseats = cv.tree(tree.carseats, FUN=prune.misclass)

names(cv.carseats)


# This will give us the # of terminal nodes of each tree considered (size)
# Error rate.....
# Value of cost-complexity parameter used 

# You will see that dev corresponds to the CV-error rate in this instance.
cv.carseats

# Above you'll see that the 9 node has the lowest cross-validation error rate 

par(mfrow=c(1,2))
plot(cv.carseats$size, cv.carseats$dev, type="b", main="Error rate as a function of size")
plot(cv.carseats$k, cv.carseats$dev, type="b", main="Error rate as a function of k")

# We now apply prune.misclass() in order to prune the tree in order to obtatin the 9-node tree which we saw in the output above
prune.carseats = prune.misclass(tree.carseats, best=9)
plot(prune.carseats)
text(prune.carseats, pretty=0)

# We have to test this prunned model on a test data set. Use predict() for this 
tree.pred = predict(prune.carseats, Carseats.test, type="class")
results_table_2 <- table(tree.pred, High.test)

(results_table_2[1,1] + results_table_2[2,2]) / 200 # How many are correctly classified? 

# In the end prunning improved our number 

# iF we increase the value of best, we obtain a larger pruuned treet with lower classification accuracy 
prune.carseats = prune.misclass(tree.carseats, best=15)
plot(prune.carseats)
text(prune.carseats, pretty=0)
tree.pred=predict(prune.carseats, Carseats.test, type="class")

table3 <- table(tree.pred, High.test)
(table3[1,1] + table3[2,2]) / 200 # How many are correctly classified? 


# ----------- Fitting Regression Trees ---------------------- 
library(MASS)
set.seed(1)
train = sample(1:nrow(Boston), nrow(Boston)/2)
tree.boston = tree(medv~., Boston, subset=train)
summary(tree.boston)

# In regression, the deviance is simply the sum of squared errors for the tree

plot(tree.boston)
text(tree.boston, pretty=0)

# Check if pruning improves performance...
cv.boston = cv.tree(tree.boston)
plot(cv.boston$size, cv.boston$dev, type="b") # You will see the most complex tree selected by CV

prune.boston=prune.tree(tree.boston, best = 5)
plot(prune.boston)
text(prune.boston, pretty=0)

# We are sticking with the CV results and use the unprunned tree to make predictions on the test set s
yhat = predict(tree.boston, newdata=Boston[-train,])
boston.test = Boston[-train, "medv"]
plot(yhat, boston.test)
abline(0,1)
mean((yhat-boston.test)^2)

# ----------- Bagging and Random Forests---------------------- 

# Bagging is simply a special case of a random forect with m=p
# randomforest() function can be used to perform both random forests and bagging

# First we do bagging...
library(randomForest)
set.seed(1)

#mtry means that all 13 predictors should be considers for each split of the tree, in order words BAGGING
bag.boston = randomForest(medv~., data=Boston, subset=train, mtry=13, importance=TRUE)
bag.boston

# So how well does a bagged model perform on the test set? 
yhat.bag = predict(bag.boston, newdata=Boston[-train,])
plot(yhat.bag, boston.test)
abline(0,1)

mean((yhat.bag-boston.test)^2) # Test MSE

# we could change the number of trees grown using the ntree argument
bag.boston = randomForest(medv~., data=Boston, subset=train, mtry=13, ntree=25)
yhat.bag = predict(bag.boston, newdata=Boston[-train,])
mean((yhat.bag-boston.test)^2)


# ****** by default, randomForest() uses p/3 variables when building a random forest of regression trees, and sqrt(p) varaibles when building a random forest of classification trees

set.seed(1)
rf.boston = randomForest(medv~., data=Boston, subset=train, mtry=6, importance=TRUE)
yhat.rf = predict(rf.boston, newdata = Boston[-train,])
mean((yhat.rf - boston.test)^2) # Test MSE indicates that random forests yields an improvement over bagging 

# importance() function tells us the importance of each variable
importance(rf.boston)

# Plot of importance measures 
varImpPlot(rf.boston)

# ---------- Boosting -----------------
# we use gmb for boosting 
# use gauassian distribution b/c this is a regression problem 
library(gbm)
set.seed(1)
boost.boston <- gbm(medv~., data=Boston[train,], distribution="gaussian", n.trees=5000, interaction.depth=4)

summary(boost.boston)

# partial dependdence plots illustrate the marginal effect of the selected variables on the response afte integrating out the other varaibles

par(mfrow=c(1,2))
plot(boost.boston, i="rm")
plot(boost.boston, i="lstat")

# Use boosted model to predict medv on the test set,

yhat.boost <- predict(boost.boston, newdata=Boston[-train,], n.trees=5000)
mean((yhat.boost - boston.test)^2)

# now we try boosting with a shkrinkage parameter 
boost.boston <- gbm(medv~., data=Boston[train,], distribution = "gaussian", n.trees=5000, interaction.depth=4, shrinkage=0.2, verbose=F)
yhat.boost <- predict(boost.boston, newdata=Boston[-train,], n.trees=5000)
mean((yhat.boost - boston.test)^2) # Slightly lower test MSE 





