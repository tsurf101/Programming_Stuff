# Lab 1: Principal Compenants Anlaysis 

states <- row.names(USArrests)
states

names(USArrests)

# Apply() funciton allows us to apply a function in this case mena() to each row and column of the data set
# second input doneates whether we wish to compute the meanof the rows ->> 1, or the columns --> 2 
apply(USArrests, 2, var)

# It is critical to standardize the variable to have mean zero and s.d. 1 before perorming PCA 
# BY DEFAULT prcomp() centers the variables to have mean zero 
# Scale=TRUE allows you to scale the variables to have standard deviation 1 

# Do principal components analusis using the prcomp() function
pr.out <- prcomp(USArrests, scale=TRUE)

names(pr.out)

#center and sacle components correspond to the means and s.d. respectively. 
pr.out$center
pr.out$scale

# The rotation matrix provides the Principal component loadings, each column of pr.out$rotation contains the corresponding principal component loading vector 
pr.out$rotation

# We see that there is 4 distinct principal components 

# We don't have to mutiply the data by the principal component loading vectors in order to obtain the principal component score vectors. 
# It's already built in. 
dim(pr.out$x)
# Make sure to pass through scale=- to ensure that the arrows are scaled to represent the loadings 
biplot(pr.out, scale=0)

# Principal components are only unique up to a sgin change
pr.out$rotation=-pr.out$rotation
pr.out$x=-pr.out$x
biplot(pr.out, scale=0)

# display each respective s.d.
pr.out$sdev

# displaying variance by squaring each s.d. term below 
pr.var=pr.out$sdev^2
pr.var

pve <- pr.var/sum(pr.var)
pve

plot(pve, xlab="Principal Component", ylab="Proportion of Variance Explained", ylim=c(0,1), type="b")

plot(cumsum(pve), xlab="Principal Component", ylab="Cumultive Proportion of Variance Explained", ylim=c(0,1), type="b")

# Background, cumsum() computes the cum. sum of the elements of a numeric vector 
a <- c(1,2,8, -3)
cumsum(a)



