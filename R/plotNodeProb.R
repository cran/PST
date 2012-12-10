## Plotting probability distribution as a stacked bar

plotNodeProb <- function(x0, y0, x1, y1, prob, seglist, state, cpal, pruned, index, horiz=TRUE, axes=c("no", "no"), 
	bgcol="grey90", pruned.col="red", cex.axes=0.6, by.state=FALSE) {
	if (getOption("verbose")) {
		cat("    [-] plotNodeProb: x0=", x0, ", y0=", y0, ", x1=", x1, ", y1=", y1, "\n")
	}

	A <- colnames(prob)
	xsize <- x1-x0
	ysize <- abs(y1-y0)

	nbseg <- nrow(seglist)
	seg.lab <- rownames(seglist)
	has.segment <- rownames(seglist) %in% rownames(index)	

	if (!horiz) {
		if (!by.state) {
			rect(x0, y0, x1, y1, col=bgcol, border=NA)

			pdim <- ysize/nbseg
			ybot <- y0

			for (g in 1:nbseg) {
				ytop <- ybot+pdim

				xtmp <- x0

				if (has.segment[g]) {
					idseg <- rownames(seglist)[g]

					for (s in 1:length(A)) {
						xright <- xtmp+(prob[idseg, s]*xsize)

						rect(xtmp, ybot, xright, ytop, col=cpal[s], border=NA)
						xtmp <- xright
					}
			
					if (pruned[idseg]) {
						segments(x0, y0, x1, y1,
							col = "red", ## lty = lty, lwd = lwd
						)
					}
				}
				ybot <- ytop
			}
		} else {
			pdim <- ysize/nbseg
			ybot <- y0

			for (g in 1:nbseg) {
				ytop <- ybot+(pdim/length(A))

				xtmp <- x0
				if (has.segment[g]) {
					idseg <- rownames(seglist[g, ])

					for (s in 1:length(A)) {
						xright <- xtmp+(prob[idseg, s]*xsize)

						rect(xtmp, ybot, xright, ytop, col=cpal[s], border=NA)
						xtmp <- xright
						ytop <- ytop+(pdim/length(A))
					}
			
					if (pruned[idseg]) {
						segments(x0, y0, x1, y1,
							col = "red", ## lty = lty, lwd = lwd
						)
					}
				}
				ybot <- ytop
			}
		}
	} else {
		pdim <- xsize/nbseg
		xleft <- x0

		if (by.state) {
			stsize <- (ysize/length(A))
			ytmp <- y0

			for (s in 1:length(A)) {
				xleft <- x0
				rect(x0, ytmp, x1, ytmp-stsize, col=bgcol)
				
				for (g in 1:nbseg) {
					xright <- xleft+pdim

					if (has.segment[g]) {
						idseg <- rownames(seglist[g, ])

						ybot <- ytmp-(prob[idseg, s]*stsize)
						rect(xleft, ytmp, xright, ybot, col=cpal[s], border=NA)
						xleft <- xright
					}
				}
				ytmp <- ytmp-stsize
			}
		} else {
			rect(x0, y0, x1, y1, col=bgcol)

			for (g in 1:nbseg) {
				xright <- xleft+pdim

				ytmp <- y0
				if (has.segment[g]) {
					idseg <- rownames(seglist)[g]

					for (s in 1:length(A)) {
						ybot <- ytmp-(prob[idseg, s]*ysize)

						rect(xleft, ytmp, xright, ybot, col=cpal[s], border=NA)
						ytmp <- ybot
					}
				}
				xleft <- xright
			}
		}


		## Plotting the axes
		if (axes[1]=="bottom") {
			axe.offset <- if (nbseg>1 && any(pruned, na.rm=TRUE)) { ysize*0.3 } else {0}
			## x axis
			segments(x0, y0+(0.1*ysize)+axe.offset, x1, y0+(0.1*ysize)+axe.offset)
			segments(x0, y0+(0.1*ysize)+axe.offset, x0, y0+(0.2*ysize)+axe.offset)
			segments(x1, y0+(0.1*ysize)+axe.offset, x1, y0+(0.2*ysize)+axe.offset)
			text(x=c(x0,x1), y=y0+(0.25*ysize)+axe.offset, labels=seg.lab[c(1,nbseg)], cex=cex.axes)
		} else if (axes[1]=="top") {
			segments(x0, y1-(0.1*ysize), x1, y1-(0.1*ysize))
			segments(x0, y1-(0.1*ysize), x0, y1-(0.2*ysize))
			segments(x1, y1-(0.1*ysize), x1, y1-(0.2*ysize))
			text(x=c(x0,x1), y=y1-(0.25*ysize), labels=seg.lab[c(1,nbseg)], cex=cex.axes)
		}


		if (axes[2]=="left") {
			## y axis
			segments(x0-(0.1*xsize), y0, x0-(0.1*xsize), y1)
			segments(x0-(0.1*xsize), y0, x0-(0.15*xsize), y0)
			segments(x0-(0.1*xsize), y1, x0-(0.15*xsize), y1)
			text(x=c(x0-(0.25*xsize),x0-(0.25*xsize)), y=c(y0, y1), labels=c(0,1), cex=cex.axes, srt=90)
		} else if (axes[2]=="right") {
			segments(x1+(0.1*xsize), y0, x1+(0.1*xsize), y1)
			segments(x1+(0.1*xsize), y0, x1+(0.15*xsize), y0)
			segments(x1+(0.1*xsize), y1, x1+(0.15*xsize), y1)
			text(x=c(x1+(0.25*xsize),x1+(0.25*xsize)), y=c(y0, y1), labels=c(0,1), cex=cex.axes, srt=90)
		}

		## A bar showing the pruned and unpruned nodes
		if (nbseg>1 && any(pruned, na.rm=TRUE)) {
			rect(x0, y0+(ysize*0.1), x1, y0+(ysize*0.3), col=bgcol, border=NA)
			xleft <- x0
			for (g in 1:nbseg) {
				xright <- xleft+pdim
				if (has.segment[g] %in% rownames(prob)) {
					if (pruned[has.segment[g]]) {
						rect(xleft, y0+(ysize*0.1), xright, y0+(ysize*0.3),
							col=pruned.col, border=NA)
					} else if (!pruned[has.segment[g]]) {
						rect(xleft, y0+(ysize*0.1), xright, y0+(ysize*0.3), 
							col="green", border=NA)
					}
				}
				xleft <- xright
			}
			rect(x0, y0+(ysize*0.1), x1, y0+(ysize*0.3))
		} else if (nbseg==1 && pruned) {
			segments(x0, y0, x1, y1, col = pruned.col)
		}
	}

	rect(x0, y0, x1, y1)
}


 
