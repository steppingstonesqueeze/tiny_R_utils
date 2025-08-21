# A nifty way of checking if packages there and if not, alert to install them

suppressPackageStartupMessages({
	  ok <- requireNamespace("ggplot2", quietly = TRUE); if (!ok) stop("Install ggplot2")
	    ok <- requireNamespace("av", quietly = TRUE); if (!ok) stop("Install av")
})
