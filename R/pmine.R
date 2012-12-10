## Frequent patterns

setMethod("pmine", signature=c(object="PSTf", data="stslist"), 
	def=function(object, data, l, pmin, pmax, lag, state, average=FALSE, output="sequences") {
	A <- alphabet(object)

	prob <- predict(object, data, decomp=TRUE)
	nbps <- rowSums(!is.na(prob))

	if (!average) { 
		prob.check <- if (!missing(pmin)) { prob>=pmin } else if (!missing(pmax)) { prob < pmax }
	} else {
		prob.check <- log(prob)
	}
	
	select.seq <- vector(mode="logical", length=nrow(data))

	sl <- max(seqlength(data))

	patterns.list <- NULL

	if (missing(lag)) { lag <- 0 }

	if (missing(l)) { l <- sl-lag }

	for (p in (1+lag):(sl-l+1)) {
		if (average) {
			tmp <- exp(rowSums(prob.check[, p:(p+l-1)], na.rm=TRUE)/nbps)
			fp <- if (!missing(pmin)) { tmp>=pmin } else if (!missing(pmax)) { tmp < pmax }
		} else {
			fp <- rowSums(prob.check[, p:(p+l-1), drop=FALSE])==l
		}
		select.seq[fp] <- TRUE
		if (output=="patterns") {
			tmp <- seqconc(data[fp,  1:(p+l-1)])
			patterns.list <- c(patterns.list, unique(tmp[!tmp %in% patterns.list]))
		}
	}

	if (output=="patterns") {
		nr <- if ("*" %in% A) { "#" } else { "*" }
		res <- seqdef(patterns.list, alphabet=A, labels=object@labels, cpal=cpal(object), nr=nr)
	} else {
		res <- unique(data[select.seq,])
	}

	return(res)
}
)




