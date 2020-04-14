# Chapter 10 Pratice Lab from Textbook 

# ------ 10.5.1 K-Means Clustering -----------
set.seed(2)
x=matrix(rnorm(50*2), ncol=2)
x[1:25,1] = x[1:25, 1] + 3 
x[1:25,2] = x[1:25, 2] - 4 

# K-means clustering with K=2
km.out <- kmeans(x,2, nstart=20)

# The cluster assignments of the 50 obersearvations are contained in $cluster
km.out$cluster

# We plot the data, with each oobservation colored according to its cluster assignment
plot(x, col=(km.out$cluster+1), main="K-Means Clustering Results with K=2", xlab="", ylab="", pch=20, cex=2)

# If there were more than 2 variables then we could instead perform PCA and plot the first 2 principal score vectors 

# In real data we do not know the true number of clusters 

# ----- Another try ------------
set.seed(4)
km.out <- kmeans(x,3,nstart=20)
km.out

# ----- We compare nstarts -----------
set.seed(3)
km.out <- kmeans(x,3, nstart=1)
km.out$tot.withinss
km.out
km.out2 <- kmeans(x,3,nstart=20)
km.out2$tot.withinss

# km.out$tot.withinss is the total within-cluster sum of squares, which we seek to minimzize by performing K-means
# Always recommend a high nstart such as 20 or 50, otherwise an undersirable local opt may be obtained

# ------ 10.5.2. Hierarchical Clustering --------------
# dist () function is used to coompute the 50x50 inter-observation Euclidean distance matrix 
hc.complete <- hclust(dist(x), method="complete")
hc.complete

# Using average or single linkage instead ****** 
hc.average <-hclust(dist(x), method="average")
hc.single <- hclust(dist(x), method="single")

par(mfrow=c(1,3))
plot(hc.complete, main="Complete Linkage", xlab="", sub="", cex=0.9)
plot(hc.average, main="Average Linkage", xlab = " ", sub = " ", cex=0.9)
plot(hc.single, main="Single Linkage", xlab = " ", sub = " ", cex = 0.9)

# to determine the cluster labels for each observation associated with a given cut of the dendrogram use cutree()
cutree(hc.complete, 2)
cutree(hc.average, 2)
cutree(hc.single, 2)

cutree(hc.single, 4)

# to scale the variables before performing hierarchical clustering of the observations, we use the scale() function
xsc <- scale(x)
plot(hclust(dist(xsc), method = "complete"), main="Hierarchical Clustering with Scaled Features")

x <- matrix(rnorm(30*3), ncol=3)
dd <- as.dist(1-cor(t(x)))
plot(hclust(dd, method="complete"), main="Complete Linkage with Correlation-Based Distance", xlab="", sub=" ")




