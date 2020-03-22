# Chpater 7 - Non Linear Modeling Notes

library(ISLR)
attach(Wage)

# 7.8.1 - Polynomial Regression and Step Functions 

fit = lm(wage~poly(age,4), data=Wage)
coef(summary(fit))

# or can do raw=T to obtain directly 

fit2 = lm(wage~poly(age, 4, raw=T), data=Wage)
coef(summary(fit2))

# Another way to fitting is the following 
# This creates a polynomial bassi function on the fly 
fit2a = lm(wage~age+I(age^2)+I(age^3)+I(age^4), data=Wage)
coef(fit2a)

# Or we can do the same more compactily using the cbind() function. 
# use cbind() to build a matrix from a collection of vectors 

fit2b = lm(wage~cbind(age, age^2, age^3, age^4), data=Wage)
agelims = range(age) # Returns back the full range 
age.grid <- seq(from=agelims[1], to=agelims[2]) #Creating a grid of values for age at which we want predictions 
preds <- predict(fit, newdata=list(age=age.grid), se=TRUE)
se.bands <- cbind(preds$fit + 2*preds$se.fit, preds$fit - 2*preds$se.fit)

# plotting 
#mar and oma arguments allow us to control the margins of the plot 
par(mfrow=c(1,2), mar=c(4.5, 4.5, 1, 1), oma=c(0,0,4,0))
plot(age, wage, xlim=agelims, cex=.5, col="darkgrey")
title("Degree-4 Polynomial", outer=T)
lines(age.grid, preds$fit, lwd=2, col="blue")
matlines(age.grid,se.bands,lwd=1, col="blue", lty=3)

preds2 = predict(fit2, newdata=list(age=age.grid), se=TRUE)
max(abs(preds$fit-preds2$fit))

# Use anova() which performs an analysis of variance in order to test the null hypothesiss that a model M1 is sufficient to explain the data
# against the alternative hypothesis that a more comple

fit.1 = lm(wage~age, data=Wage)
fit.2 = lm(wage~poly(age,2), data=Wage)
fit.3 = lm(wage~poly(age,3), data=Wage)
fit.4 = lm(wage~poly(age,4), data=Wage)
fit.5 = lm(wage~poly(age,5), data=Wage)
anova(fit.1, fit.2, fit.3, fit.4, fit.5)

# FASTER WAY - we can do this because poly() creates orthogonal polynomials 
coef(summary(fit.5))

# The p-values are the same, and in fact the sqaure of the t-stat is equal to the F-stat from the anova() fuunction 
(-11.983)^2


# However Anova method is the best recommended 

# Another example 
fit.1 = lm(wage~education+age, data=Wage)
fit.2 = lm(wage~education+poly(age,2), data=Wage)
fit.3 = lm(wage~education+poly(age,3), data=Wage)
anova(fit.1, fit.2, fit.3)

# RECALL - As an alternative to using hypothessis tests and ANOVA, we could choose the polynomial degree using cross-validation (chp5)

fit = glm(I(wage>250)~poly(age,4), data=Wage, family=binomial)

# The wrapper I() creates a binary response varaible on the fly

preds = predict(fit, newdata=list(age=age.grid), se=T)

# Calculate confidence intervals now 

pfit = exp(preds$fit)/(1+exp(preds$fit)) # probability of fit # rearranging the equation 
se.bands.logit = cbind(preds$fit+2*preds$se.fit, preds$fit-2*preds$se.fit)
se.bands = exp(se.bands.logit)/(1+exp(se.bands.logit))

# FASTER WAY - use type="response" in predict() function as per below
preds=predict(fit, newdata = list(age = age.grid), type="response", se=T)

# Making the plot 

plot(age, I(wage>250), xlim=agelims, type="n", ylim=c(0,.2))
points(jitter(age), I((wage>250)/5), cex=0.5, pch="|", col="darkgrey")
lines(age.grid,pfit,lwd=2, col="blue")
matlines(age.grid,se.bands, lwd=1, col="blue", lty=3)

# age values corresponding to the observatiosn with wage values above 250 as gray marks on the top of the plot
# wage balues below 250 are shown as gray marks on the bottom of the plot
# we use the jitter() funciton ot jitter the age values a bit so that obsersations with the same age value do not cover each other up. "rug plot"

# Use the cut() function in order to fit a step function

table(cut(age,4)) # automatically picks our breakpoints 
fit.step = lm(wage~cut(age,4), data=Wage)
coef(summary(fit))


# 7.8.2 ------------ Splines ----------------------------

# Use splines library 
# regression splines can be fit by constructing an apprprioate matrix of basis functions 
# BS() funciton generates the entire matrix of basis function fo splien with specified set of knots 

library(splines)
fit = lm(wage~bs(age,knots=c(25,40,60)), data=Wage)
pred = predict(fit, newdata=list(age=age.grid), se=T)
plot(age,wage, col="gray")
lines(age.grid, pred$fit, lwd=2)
lines(age.grid, pred$fit +2*pred$se, lty="dashed")
lines(age.grid, pred$fit -2*pred$se, lty="dashed")

# Use the df() option to produce a spline with knots at uniform quantiles of the data 
dim(bs(age, knots=c(25,40,60)))
dim(bs(age,df=6))
attr(bs(age,df=6), "knots") # R chooses the knots here 

# Use ns() to fit a natural spline 
fit2 = lm(wage~ns(age,df=4), data=Wage)
pred2 = predict(fit2, newdata=list(age=age.grid), se=T)
lines(age.grid, pred2$fit, col="red", lwd=2)

# Fitting a smoothing spline

plot(age, wage, xlim=agelimes, cex=0.5, col="darkgrey")
title("Smoothing Spline")
fit = smooth.spline(age, wage, df=16) # fitting model here, the function dtermines which value of lambda leads to 16 DOF
fit2 = smooth.spline(age, wage, cv=TRUE) #  fitting model here, select smoothness level by CV
fit2$df
lines(fit, col="red", lwd=2)
lines(fit2, col="blue", lwd=2)
legend("topright", legend= c("16 DF", "6.8 DF"), col=c("red", "blue"), lty=1, lwd=2, cex=.8)

# to do local regression use loess() functino

plot(age, wage, xlim=agelims, cex=0.5, col="darkgrey")
title("Local Regression")
fit <- loess(wage~age, span=0.2, data=Wage)
fit2 <- loess(wage~age, span=0.5, data=Wage)
lines(age.grid, predict(fit, data.frame(age=age.grid)), col="red",lwd=2)
lines(age.grid, predict(fit2, data.frame(age=age.grid)), col="blue", lwd=2)
legend("topright", legend=c("Span=0.2", "Span=0.5"), col=c("red","blue"), lty=1, lwd=2, cex=0.8)

# The larger the span the smoothe rthe fit. 


# 7.8.3 --------- GAM Models ---------------------------------------------

# Gam is pretty much a big linear regression model 
gam1 = lm(wage~ns(year,4)+ns(age,5)+education,data=Wage)

library(gam)
#s() function is used to indicate that we want to use a smoothing spline 
gam.m3 = gam(wage~s(year,4)+s(age,5)+education, data=Wage)
par(mfrow=c(1,3))
plot(gam.m3, se=TRUE, col="blue")

plot.Gam(gam1, se=TRUE, col="red")

# Do anova() tests in order to determine which of these three models is the best
gam.m1 = gam(wage~s(age,5)+education, data=Wage)
gam.m2 = gam(wage~year+s(age,5)+education, data=Wage)
anova(gam.m1, gam.m2, gam.m3, test="F")

summary(gam.m3)

# We make a prediction on the training set 
preds = predict(gam.m2, newdata=Wage)

#Use the local regression fits as building blocks in a GAM using the lo() function s
gam.lo = gam(wage~s(year, df=4) + lo(age, span = 0.7) + education, data=Wage)
plot.Gam(gam.lo, se=TRUE, col="green")

gam.lo.i = gam(wage~lo(year, age, span=0.5)+education, data=Wage)

library(akima)
plot(gam.lo.i)

gam.lr=gam(I(wage>250)~year+s(age,df=5)+education, family=binomial, data=Wage)
par(mfrow=c(1,3))
plot(gam.lr,se=T, col="green")

# error checking........

table(education, I(wage>250))

# In summary we fit a logistic regression GAM model using all but in <HS category as per the previous output.

gam.lr.s <- gam(I(wage>250)~year+s(age,df=5) + education, family=binomial, data=Wage, subset=(education !="1. < HS Grad"))

plot(gam.lr.s, se=T, col="green")



