pkgname <- "PST"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('PST')

assign(".oldSearch", search(), pos = 'CheckExEnv')
cleanEx()
nameEx("PSTf-class")
### * PSTf-class

flush(stderr()); flush(stdout())

### Name: PSTf-class
### Title: Flat representation of a probabilistic suffix tree
### Aliases: PSTf-class
### Keywords: classes

### ** Examples

showClass("PSTf")



cleanEx()
nameEx("PSTr-class")
### * PSTr-class

flush(stderr()); flush(stdout())

### Name: PSTr-class
### Title: Nested representation of a probabilistic suffix tree
### Aliases: PSTr-class [[,PSTr-method
### Keywords: classes

### ** Examples

showClass("PSTr")



cleanEx()
nameEx("SRH-data")
### * SRH-data

flush(stderr()); flush(stdout())

### Name: SRH
### Title: Longitudinal data on self rated health
### Aliases: SRH SRH.seq
### Keywords: datasets

### ** Examples

## Preparing a sequence object with the SRH data set
data(SRH)

## Long state labels
state.list <- levels(SRH$p99c01)

## Sequential color palette
mycol5 <- rev(brewer.pal(5, "RdYlGn"))

## Creating the sequence object
SRH.seq <- seqdef(SRH, 5:15, alphabet=state.list, 
	states=c("G1", "G2", "M", "B2", "B1"), labels=state.list, 
	weights=SRH$wp09lp1s, right=NA, cpal=mycol5)
names(SRH.seq) <- 1999:2009



cleanEx()
nameEx("cmine")
### * cmine

flush(stderr()); flush(stdout())

### Name: cmine
### Title: Mining contexts
### Aliases: cmine cmine,PSTf-method [,cprobd.list-method
###   plot,cprobd.list,ANY-method
### Keywords: methods

### ** Examples

## Loading the SRH.seq sequence object
data(SRH)

## Learning the model
SRH.pst <- pstree(SRH.seq, nmin=30, ymin=0.001)

## Example 1: searching for all contexts yielding a probability of the 
## state G1 (very good health) of at least pmin=0.5
cm1 <- cmine(SRH.pst, pmin=0.5, state="G1")
cm1[1:10]

## Example 2: contexts associated with a high probability of 
## medium or lower self rated health 
cm2 <- cmine(SRH.pst, pmin=0.5, state=c("B1", "B2", "M"))
plot(cm2, tlim=0, main="(a) p(B1,B2,M)>0.5")



cleanEx()
nameEx("cplot")
### * cplot

flush(stderr()); flush(stdout())

### Name: cplot
### Title: Plot single nodes of a probabilistic suffix tree
### Aliases: cplot cplot,PSTf-method
### Keywords: hplot models

### ** Examples

data(s1)
s1 <- seqdef(s1)
S1 <- pstree(s1, L=3)

cplot(S1, "a-b")



cleanEx()
nameEx("cprob")
### * cprob

flush(stderr()); flush(stdout())

### Name: cprob
### Title: Empirical conditional probability distributions of order 'L'
### Aliases: cprob cprob,stslist-method
### Keywords: distribution

### ** Examples

## Example with the single sequence s1
data(s1)
s1 <- seqdef(s1)
cprob(s1, L=0, prob=FALSE)
cprob(s1, L=1, prob=TRUE)

## Preparing a sequence object with the SRH data set
data(SRH)
state.list <- levels(SRH$p99c01)
## sequential color palette
mycol5 <- rev(brewer.pal(5, "RdYlGn"))
SRH.seq <- seqdef(SRH, 5:15, alphabet=state.list, states=c("G1", "G2", "M", "B2", "B1"), 
	labels=state.list, weights=SRH$wp09lp1s, right=NA, cpal=mycol5)
names(SRH.seq) <- 1999:2009

## Example 1: 0th order: weighted and unweigthed counts
cprob(SRH.seq, L=0, prob=FALSE, weighted=FALSE)
cprob(SRH.seq, L=0, prob=FALSE, weighted=TRUE)

## Example 2: 2th order: weighted and unweigthed probability distrib.
cprob(SRH.seq, L=2, prob=TRUE, weighted=FALSE)
cprob(SRH.seq, L=2, prob=TRUE, weighted=TRUE)



cleanEx()
nameEx("generate")
### * generate

flush(stderr()); flush(stdout())

### Name: generate
### Title: Generate sequences using a probabilistic suffix tree
### Aliases: generate generate,PSTf-method
### Keywords: datagen methods

### ** Examples

data(s1)
s1.seq <- seqdef(s1)
S1 <- pstree(s1.seq, L=3)

## Generating 10 sequences
generate(S1, n=10, l=10, method="prob")

## First state is generated with p(a)=0.9 and p(b)=0.1
generate(S1, n=10, l=10, method="prob", p1=c(0.9, 0.1))



cleanEx()
nameEx("impute")
### * impute

flush(stderr()); flush(stdout())

### Name: impute
### Title: Impute missing values using a probabilistic suffix tree
### Aliases: impute impute,PSTf,stslist-method
### Keywords: models datagen

### ** Examples

## Loading the SRH.seq sequence object
data(SRH)

## working with a sub-sample of 500 sequences
## to reduce computing time
subs <- sample(nrow(SRH.seq), size=500)
SRH.sub.seq <- SRH.seq[subs,]

## Learning the model (missing state is not included)
SRH.pst.L10 <- pstree(SRH.sub.seq, nmin=2, ymin=0.001)

## Pruning
C99 <- qchisq(0.99,5-1)/2
SRH.pst.L10.C99 <- prune(SRH.pst.L10, gain="G2", C=C99)

## Imputing missing values in the SRH sequences
SRH.sub.iseq <- impute(SRH.pst.L10, SRH.sub.seq, method="prob")

## locating sequences having missing values
## in sequence object missing states are identified by '*'
have.miss <- which(rowSums(SRH.sub.seq=='*')>0)

## plotting non imputed vs imputed sequence
## (first 10 sequences in the set) 
par(mfrow=c(1,2))
seqiplot(SRH.sub.seq[have.miss,], withlegend=FALSE)
seqiplot(SRH.sub.iseq[have.miss,], withlegend=FALSE)



graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("logLik")
### * logLik

flush(stderr()); flush(stdout())

### Name: logLik
### Title: Log-Likelihood of a variable length Markov chain model
### Aliases: logLik logLik,PSTf-method
### Keywords: models

### ** Examples

## activity calendar for year 2000
## from the Swiss Household Panel
## see ?actcal
data(actcal)

## selecting individuals aged 20 to 59
actcal <- actcal[actcal$age00>=20 & actcal$age00 <60,]

## defining a sequence object
actcal.lab <- c("> 37 hours", "19-36 hours", "1-18 hours", "no work")
actcal.seq <- seqdef(actcal,13:24,labels=actcal.lab)

## building a PST
actcal.pst <- pstree(actcal.seq, nmin=2, ymin=0.001)
logLik(actcal.pst)

## Cut-offs for 5% and 1% (see ?prune)
C99 <- qchisq(0.99,4-1)/2

## pruning
actcal.pst.C99 <- prune(actcal.pst, gain="G2", C=C99)

## Comparing AIC
AIC(actcal.pst, actcal.pst.C99)



cleanEx()
nameEx("nobs")
### * nobs

flush(stderr()); flush(stdout())

### Name: nobs
### Title: Extract the number of observations to which a VLMC model is
###   fitted
### Aliases: lnobs nobs,PSTf-method
### Keywords: models

### ** Examples

data(s1)
s1.seq <- seqdef(s1)
S1 <- pstree(s1.seq, L=3)
nobs(S1)

## Self rated health sequences
## Loading the 'SRH' data frame and 'SRH.seq' sequence object
data(SRH)

## model without considering missing states
## model with max. order 2 to reduce computing time
## nobs is the same whatever L and nmin
m1 <- pstree(SRH.seq, L=2, nmin=30, ymin=0.001)
nobs(m1)

## considering missing states
m2 <- pstree(SRH.seq, L=2, nmin=30, ymin=0.001, with.missing=TRUE)
nobs(m2)



cleanEx()
nameEx("nodenames")
### * nodenames

flush(stderr()); flush(stdout())

### Name: nodenames
### Title: Retrieve the node labels of a PST
### Aliases: nodenames nodenames,PSTf-method
### Keywords: models misc

### ** Examples

data(s1)
s1 <- seqdef(s1)
S1 <- pstree(s1, L=3)

nodenames(S1, L=3)
nodenames(S1)



cleanEx()
nameEx("pdist")
### * pdist

flush(stderr()); flush(stdout())

### Name: pdist
### Title: Compute probabilistic divergence between two PST
### Aliases: pdist pdist,PSTf,PSTf-method
### Keywords: models

### ** Examples

## activity calendar for year 2000
## from the Swiss Household Panel
## see ?actcal
data(actcal)

## selecting individuals aged 20 to 59
actcal <- actcal[actcal$age00>=20 & actcal$age00 <60,]

## defining a sequence object
actcal.lab <- c("> 37 hours", "19-36 hours", "1-18 hours", "no work")
actcal.seq <- seqdef(actcal,13:24,labels=actcal.lab)

## building a PST segmented by age group
gage10 <- cut(actcal$age00, c(20,30,40,50,60), right=FALSE,
	labels=c("20-29","30-39", "40-49", "50-59"))

actcal.pstg <- pstree(actcal.seq, nmin=2, ymin=0.001, group=gage10)

## pruning
C99 <- qchisq(0.99,4-1)/2
actcal.pstg.opt <- prune(actcal.pstg, gain="G2", C=C99)

## extracting PST for age group 20-39 and 30-39
g1.pst <- subtree(actcal.pstg.opt, group=1)
g2.pst <- subtree(actcal.pstg.opt, group=2)

## generating 5000 sequences with g1.pst 
## and computing 5000 distances
dist.g1_g2 <- pdist(g1.pst, g2.pst, l=11)
hist(dist.g1_g2)

## the probabilistic distance is the mean
## of the 5000 distances
mean(dist.g1_g2)



cleanEx()
nameEx("plot-PSTr")
### * plot-PSTr

flush(stderr()); flush(stdout())

### Name: plot-PSTr
### Title: Plot a PST
### Aliases: plot,PSTf,ANY-method plot,PSTr,ANY-method
### Keywords: methods hplot

### ** Examples

data(s1)
s1 <- seqdef(s1)
S1 <- pstree(s1, L=3)
plot(S1)
plot(S1, horiz=TRUE)
plot(S1, nodePar=list(node.type="path", lab.type="prob", lab.pos=1, lab.offset=2, lab.cex=0.7), edgePar=list(type="triangle"), withlegend=FALSE)



cleanEx()
nameEx("pmine")
### * pmine

flush(stderr()); flush(stdout())

### Name: pmine
### Title: PST based pattern mining
### Aliases: pmine pmine,PSTf,stslist-method
### Keywords: misc

### ** Examples

## activity calendar for year 2000
## from the Swiss Household Panel
## see ?actcal
data(actcal)

## selecting individuals aged 20 to 59
actcal <- actcal[actcal$age00>=20 & actcal$age00 <60,]

## defining a sequence object
actcal.lab <- c("> 37 hours", "19-36 hours", "1-18 hours", "no work")
actcal.seq <- seqdef(actcal,13:24,labels=actcal.lab)

## building a PST
actcal.pst <- pstree(actcal.seq, nmin=2, ymin=0.001)

## pruning
## Cut-offs for 5% and 1% (see ?prune)
C99 <- qchisq(0.99,4-1)/2
actcal.pst.C99 <- prune(actcal.pst, gain="G2", C=C99)

## example 1
pmine(actcal.pst.C99, actcal.seq, pmin=0.4, lag=2)

## example 2: patterns of length 6 having p>=0.6
pmine(actcal.pst.C99, actcal.seq, pmin=0.6, l=6)



cleanEx()
nameEx("ppplot")
### * ppplot

flush(stderr()); flush(stdout())

### Name: ppplot
### Title: Plotting a branch of a probabilistic suffix tree
### Aliases: ppplot ppplot,PSTf-method
### Keywords: hplot

### ** Examples

data(s1)
s1.seq <- seqdef(s1)
S1 <- pstree(s1.seq, L=5, ymin=0.001)
ppplot(S1, "a-a-b-b-a", gain="G1", C=c(1.1, 1.2))



cleanEx()
nameEx("pqplot")
### * pqplot

flush(stderr()); flush(stdout())

### Name: pqplot
### Title: Prediction quality plot
### Aliases: pqplot pqplot,PSTf,stslist-method
### Keywords: methods hplot

### ** Examples

data(s1)
s1 <- seqdef(s1)
S1 <- pstree(s1, L=3)

z <- seqdef("a-b-a-a-b")
pqplot(S1, z)
pqplot(S1, z, measure="logloss", plotseq=TRUE)



cleanEx()
nameEx("predict")
### * predict

flush(stderr()); flush(stdout())

### Name: predict
### Title: Compute the probability of categorical sequences using a
###   probabilistic suffix tree
### Aliases: predict predict,PSTf-method
### Keywords: models

### ** Examples

data(s1)
s1 <- seqdef(s1)

S1 <- pstree(s1, L=3, nmin=2, ymin=0.001)
S1 <- prune(S1, gain="G1", C=1.20, delete=FALSE)

predict(S1, s1, decomp=TRUE)
predict(S1, s1)



cleanEx()
nameEx("prune")
### * prune

flush(stderr()); flush(stdout())

### Name: prune
### Title: Prune a probabilistic suffix tree
### Aliases: prune prune,PSTf-method
### Keywords: models

### ** Examples

data(s1)
s1.seq <- seqdef(s1)
S1 <- pstree(s1.seq, L=3, nmin=2, ymin=0.001)

## --
S1.p1 <- prune(S1, gain="G1", C=1.20, delete=FALSE)
summary(S1.p1)
plot(S1.p1)

## --
C95 <- qchisq(0.95,1)/2
S1.p2 <- prune(S1, gain="G2", C=C95, delete=FALSE)
plot(S1.p2)



cleanEx()
nameEx("pstree")
### * pstree

flush(stderr()); flush(stdout())

### Name: pstree
### Title: Build a probabilistic suffix tree
### Aliases: pstree pstree,stslist-method
### Keywords: models

### ** Examples

## Build a PST on one single sequence
data(s1)
s1.seq <- seqdef(s1)
s1.seq
S1 <- pstree(s1.seq, L = 3)
print(S1, digits = 3)
S1



cleanEx()
nameEx("query")
### * query

flush(stderr()); flush(stdout())

### Name: query
### Title: Retrieve counts or next symbol probability distribution
### Aliases: query query,PSTf-method round,cprobd-method
### Keywords: models

### ** Examples

data(s1)
s1 <- seqdef(s1)
S1 <- pstree(s1, L=3)
## Retrieving from the node labelled 'a-a-a'
query(S1, "a-a-a")

## The node 'a-b-b-a' is not presetnin the tree, and the next symbol
## probability is retrieved from the node labelled 'b-b-a' (the longest
## suffix
query(S1, "a-b-b-a")



cleanEx()
nameEx("s1-data")
### * s1-data

flush(stderr()); flush(stdout())

### Name: s1
### Title: Example sequence data set
### Aliases: s1
### Keywords: datasets

### ** Examples

## Loading the data
data(s1)

## Creating a state sequence object
s1.seq <- seqdef(s1)

## Building and plotting a PST
S1 <- pstree(s1.seq, L = 3)
plot(S1)



cleanEx()
nameEx("subtree")
### * subtree

flush(stderr()); flush(stdout())

### Name: subtree
### Title: Extract a subtree from a segmented PST
### Aliases: subtree subtree,PSTf-method
### Keywords: methods models

### ** Examples

## activity calendar for year 2000
## from the Swiss Household Panel
## see ?actcal
data(actcal)

## selecting individuals aged 20 to 59
actcal <- actcal[actcal$age00>=20 & actcal$age00 <60,]

## defining a sequence object
actcal.lab <- c("> 37 hours", "19-36 hours", "1-18 hours", "no work")
actcal.seq <- seqdef(actcal,13:24,labels=actcal.lab)

## building a PST segmented by age group
gage10 <- cut(actcal$age00, c(20,30,40,50,60), right=FALSE,
	labels=c("20-29","30-39", "40-49", "50-59"))

actcal.pstg <- pstree(actcal.seq, nmin=2, ymin=0.001, group=gage10)

## pruning
C99 <- qchisq(0.99,4-1)/2
actcal.pstg.opt <- prune(actcal.pstg, gain="G2", C=C99)

## extracting PST for age group 20-39 and 30-39
g1.pst <- subtree(actcal.pstg.opt, group=1)
g2.pst <- subtree(actcal.pstg.opt, group=2)

## plotting the two PST
par(mfrow=c(1,2))
plot(g1.pst, withlegend=FALSE, max.level=4, main="20-29")
plot(g2.pst, withlegend=FALSE, max.level=4, main="30-39")




graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("summary")
### * summary

flush(stderr()); flush(stdout())

### Name: summary-methods
### Title: Summary of variable length Markov chain model
### Aliases: summary,PSTf-method summary,PSTr-method
### Keywords: methods

### ** Examples

data(s1)
s1.seq <- seqdef(s1)
S1 <- pstree(s1.seq, L=3)
summary(S1)
summary(S1, max.level=2)



cleanEx()
nameEx("tune")
### * tune

flush(stderr()); flush(stdout())

### Name: tune
### Title: AIC, AICc or BIC based model selection
### Aliases: tune tune,PSTf-method
### Keywords: models

### ** Examples

## activity calendar for year 2000
## from the Swiss Household Panel
## see ?actcal
data(actcal)

## selecting individuals aged 20 to 59
actcal <- actcal[actcal$age00>=20 & actcal$age00 <60,]

## defining a sequence object
actcal.lab <- c("> 37 hours", "19-36 hours", "1-18 hours", "no work")
actcal.seq <- seqdef(actcal,13:24,labels=actcal.lab)

## building a PST
actcal.pst <- pstree(actcal.seq, nmin=2, ymin=0.001)

## Cut-offs for 5% and 1% (see ?prune)
C95 <- qchisq(0.95,4-1)/2
C99 <- qchisq(0.99,4-1)/2

## selecting the optimal PST using AIC criterion
actcal.pst.opt <- tune(actcal.pst, gain="G2", C=c(C95,C99))

## plotting the tree
plot(actcal.pst.opt)



### * <FOOTER>
###
cat("Time elapsed: ", proc.time() - get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
