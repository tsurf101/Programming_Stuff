# Chapter 6 Textbook Pratice 
setwd("/Users/thomasserafin/Serafin_Documents/Cornell/Spring_2020/Statistical_Data_Mining/Labs")

# Chapter 6.5 Lab 1: Subset Selection Methods 

# Predict a baseball player's Salary on the basis of various stats from the prior year 

library(ISLR)
fix(Hitters)
names(Hitters)
dim(Hitters)
sum(is.na(Hitters$Salary))

# Removing NA terms 
Hitters <- na.omit(Hitters)
dim(Hitters)
#Checking 
sum(is.na(Hitters$Salary))

# Using the funciton regsubsets() to perform the best subset selection by identifying the best model that contains a given number of predictors 
# Using Best RSS
library(leaps)

regfit.full = regsubsets(Salary~., Hitters)
summary(regfit.full)

# Regsubsets only goes up to best 8-variables, using nvmax() to combat this.
# Trying 19 variable.
regfit.full = regsubsets(Salary~., data = Hitters, nvmax=19)
reg.summary <- summary(regfit.full)

names(reg.summary)

reg.summary$rsq # How to get the R^2 statistic 


# We are going to plot the stats 
# type="l" will telll R to connect the plotted ppoints with lines

par(mfrow=c(2,2))
plot(reg.summary$rss, xlab="Number of Variables", ylab="RSS", type='l')
plot(reg.summary$adjr2, xlab="Number of Variables", ylab="Adjusted RSq", type='l')

#points() puts point on a plot that was already created
#which.max() will tell us the max point

which.max(reg.summary$adjr2)
points(11,reg.summary$adjr2[11], col="red", cex=2, pch=20) # Plotting the max point 

# We can plot the Cp and BIC stats 
plot(reg.summary$cp, xlab="# of variables", ylab="Cp", type='l')
which.min(reg.summary$cp)
points(10,reg.summary$cp[10], col="red", cex=2, pch=20) # Plotting the max point 

which.min(reg.summary$bic)
plot(reg.summary$bic, xlab="Number of Variables", ylab="BIC", type='l')
points(6,reg.summary$bic[6], col="red", cex=2, pch=20) # Plotting the max point 

?plot.regsubsets

plot(regfit.full, scale="r2")
plot(regfit.full, scale="adjr2")
plot(regfit.full, scale="Cp")
plot(regfit.full, scale="bic")

# Looking at the coefficients associated with the 6-variable model 
coef(regfit.full,6)

# ----------------------------------------------------------------
# --------------- Forward and Backward StepWise Selection---------
# ----------------------------------------------------------------

# Pass through method="forward or method="backward" into regsubsets() to do stepwise selections 

regfit.fwd = regsubsets(Salary~., data=Hitters, nvmax=19, method="forward")
summary(regfit.fwd )

regfit.bwd = regsubsets(Salary~., data=Hitters, nvmax=19, method="backward")
summary(regfit.bwd)

coef(regfit.full,7)

coef(regfit.fwd,7)

coef(regfit.bwd,7)

# --------------------------------------------------------------------------------------------------
# ---------------  Choosing Among Models Using the Validation Set Approach and Cross-Validation--------
# ----------------------------------------------------------------------------------------------------

# Creating training and testing sets

set.seed(1)
train = sample(c(TRUE,FALSE), nrow(Hitters), rep=TRUE)
test = (!train)

# Applying regsubsets() to the training set in order to perform the best subset selection
regfit.best = regsubsets(Salary~., data=Hitters[train,], nvmax=19)

# Making model matrix 
test.mat = model.matrix(Salary~., data=Hitters[test,])

val.errors = rep(NA,19)
for(i in 1:19){
  coefi = coef(regfit.best, id=i)
  pred=test.mat[,names(coefi)]%*%coefi
  val.errors[i] = mean((Hitters$Salary[test]-pred)^2)
}

val.errors
which.min(val.errors) #Finding the best model. 
coef(regfit.best,which.min(val.errors))

# PROBLEM THERE IS NO PREDICT METHOD FOR REGSUBSETS

# You can write your own predict method as following 

predict.regsubsets = function(object, newdata, id, ...){
  form = as.formula(object$call[[2]])
  mat=model.matrix(form,newdata)
  coefi=coef(object,id=id)
  xvars = names(coefi)
  mat[,xvars]%*%coefi
}

# now trying on full data set 
regfit.best = regsubsets(Salary~., data=Hitters, nvmax=19)
coef(regfit.best,which.min(val.errors) )

# Now we choose among the models of different sizes using cross-validation
# We have to the best subset selection within each of the k training sets

k = 10
set.seed(1)
folds = sample(1:k, nrow(Hitters), replace=TRUE)
cv.errors=matrix(NA,k,19, dimnames=list(NULL, paste(1:19)))


for (j in 1:k){
  best.fit = regsubsets(Salary~., data=Hitters[folds!=j,], nvmax=19)
  for (i in 1:19){
    pred = predict(best.fit, Hitters[folds==j,],id=i)
    cv.errors[j,i] = mean((Hitters$Salary[folds==j]-pred)^2)
      
  }  
  
}


# We have a matrix which (i,j) corresponds to the test MSE for the ith cross-validation fold for the best j-variable model
# as per the notes, apply() to avg over the columns the matrix in order to obtain a vector for which the jth element is the corss-validation error for the j-variable model

mean.cv.errors = apply(cv.errors, 2, mean)
mean.cv.errors
par(mfrow=c(1,1))
plot(mean.cv.errors, type='b')

# Now do the best subset selection on the full data set 
reg.best = regsubsets(Salary~., data=Hitters, nvmax=19)
coef(reg.best,11) # "11 is the best" but could really change things up here


# ---------------------------------------------------------------
# ---------------  Lab 2: Ridge Regression and the Lasso --------
# ---------------------------------------------------------------


# we use glmnet() which uses a different syntax
x = model.matrix(Salary~., Hitters)[,-1]
y = Hitters$Salary

# ** model.matrix() automatically transforms any qualitative variables into dummy variables
# GLMNET() CAN ONLY TAKE NUMERICAL QUANTIATIVE INPUTS

# --------- Ridge Regression ----------------------

# alpho =0 ridge model and =1 lasso model. 

library("glmnet")
grid=10^seq(10,-2,length=100)
ridge.mod=glmnet(x,y, alpha=0, lambda=grid)

dim(coef(ridge.mod))
ridge.mod$lambda[50]
coef(ridge.mod)[,50]

ridge.mod$lambda[60]
coef(ridge.mod)[,60]

predict(ridge.mod, s=50, type="coefficients")[1:20,]

#Splitting into testing and training now
set.seed(1)
train = sample(1:nrow(x), nrow(x)/2)
test= (-train)
y.test=y[test]

# Now fitting ridge on training, doing MSE< and lambda =4
ridge.mod=glmnet(x[train,],y[train],alpha=0, lambda=grid, thresh=1e-12)
ridge.pred=predict(ridge.mod, s=4, newx=x[test,])
mean((ridge.pred-y.test)^2)

mean((mean(y[train])-y.test)^2)


# we can get the same result wit ha large lambda
ridge.pred=predict(ridge.mod, s=1e10, newx=x[test,])
mean((ridge.pred-y.test)^2)

#Checking benefit to performing ridge regression with lambda=4 as comapred to least squares regression. 
ridge.pred=predict(ridge.mod,s=0, newx=x[test,],exact=TRUE)
mean((ridge.pred-y.test)^-2)


# best pratice is use cross-validation to choose the tuning paramter lambda. use cv.glmnet() to do this. 
# cv.glmnet() defaults to 10. 
set.seed(1)
cv.out = cv.glmnet(x[train,],y[train],alpha=0)
plot(cv.out)
bestlam=cv.out$lambda.min
bestlam # The value of lambda that results in the smallest cross-validation error is 212. 

# What is the test MSE assocaited with the value of lambda
ridge.pred = predict(ridge.mod, s=bestlam, newx = x[test,])
mean((ridge.pred-y.test)^2)

# Because this improves our mondel we refit our ridge regression model on the full data set using the value of lambda chosen by cross-validation
out=glmnet(x,y,alpha=0)
predict(out,type="coefficients", s=bestlam)[1:20,]



# --------- Lasso Regression ----------------------


lasso.mod=glmnet(x[train,], y[train], alpha=1,lambda=grid)
plot(lasso.mod)

set.seed(1)
cv.out = cv.glmnet(x[train,],y[train],alpha=1)
plot(cv.out)
bestlam=cv.out$lambda.min
lasso.pred=predict(lasso.mod,s=bestlam,newx=x[test,])
mean((lasso.pred-y.test)^2)

out = glmnet(x,y,alpha=1,lambda=grid)
lasso.coef=predict(out,type="coefficients",s=bestlam)[1:20, ]
lasso.coef
















