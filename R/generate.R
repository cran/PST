## Generating artifical sequences

setMethod("generate", signature=c(object="PSTf"), 
	def=function(object, l, n=1, s1, p1, method="prob", L) {

	A <- alphabet(object)
	if (missing(L)) { L <- length(object)-1 }
	stationary <- is.stationary(object)

	if (!missing(s1)) {
		n <- length(s1)
		message(" [>] user provided first position state(s)")
	} else if (!missing(p1)) {
		if (sum(p1)==1 & length(p1)==length(A)) {
			message(" [>] user provided first position probabilities")
		} else {
			stop("First position probabilities must sum to 1 and be of length |A|")
		}
	}

	debut <- Sys.time()

	seq <- matrix(nrow=n, ncol=l)

	## position 1
	if (!missing(s1)) {
		if (all(s1) %in% A) {
			seq[, 1] <- rep(s1, n/length(s1))
		} else {
			stop("s1 must be a state of the alphabet")
		}
	} else {
		if (missing(p1)) {
			if (stationary) {
				p1 <- suppressMessages(query(object, "e"))
			} else {
				p1 <- suppressMessages(query(object, "e"))[1,]
			}
		} 
		
		if (method=="pmax") {
			seq[,1] <- A[which.max(p1)]
		} else {
			seq[,1] <- sample(A, n, p1, replace=TRUE)
		}
	}

	if (is.stationary(object)) {
		context.table <- unlist(lapply(object[1:(L+1)], names))
	} else {
		message(" [>] model is non-stationary")
	}

	## position 2:l
	for (j in 2:l) {
		if (!stationary) {
			pstpos <- subtree(object, position=j)
			Lp <- min(length(pstpos)-1,L)
			context.table <- unlist(lapply(pstpos[1:(Lp+1)], names))
		}

		contexts <- apply(seq[,max(1, j-L):(j-1), drop=FALSE],1, paste, collapse="-")
		unique.contexts <- unique(contexts)
		context.idx <- match(contexts, unique.contexts)
		unmatched <- !unique.contexts %in% context.table
		
		while (sum(unmatched>0)) {
			tmp <- seqdecomp(unique.contexts[unmatched])
			if (ncol(tmp)>1) {
				unique.contexts[unmatched] <- seqconc(tmp[,2:ncol(tmp), drop=FALSE])
				unique.contexts[unique.contexts==""] <- "e"
			} else { 
				unique.contexts[unmatched] <- "e"
			}
	
			## we may have reduced the number of distinct contexts
			tmp <- unique(unique.contexts)
			unique.match <- match(unique.contexts, tmp)
			context.idx <- unique.match[context.idx]

			##
			unique.contexts <- tmp
			unmatched <- !unique.contexts %in% context.table
		}

		for (p in 1:length(unique.contexts)) {
			context <- unique.contexts[p]
			context.eq <- which(context.idx==p)
     
				if (context=="e") {
					if (!is.null(p1)) {
						tmp <- p1
					} else {
						tmp <- object[[1]][["e"]]@prob
					}
				} else {
					sd <- unlist(strsplit(context, split="-"))
					idxl <- length(sd)+1	

					if (stationary) { 
						tmp <- object[[idxl]][[context]]@prob 
					} else {
						tmp <- pstpos[[idxl]][[context]]@prob 
					}
				}

				tmp <- as.numeric(tmp)

				seq[context.eq,j] <- sample(A, length(context.eq), tmp, replace=TRUE)
		}
  	}

	seq <- seqdef(seq, alphabet=A, cpal=cpal(object), nr="#", stlab=object@labels)

	fin <- Sys.time()
	message(" [>] total time: ", format(round(fin-debut, 3)))

	return(seq)
}
)

