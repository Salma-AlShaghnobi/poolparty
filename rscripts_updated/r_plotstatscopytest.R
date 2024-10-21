#!bin/R
 suppressMessages(require(reshape))
 suppressMessages(require(fBasics))
 suppressMessages(require(ggplot2))
 suppressMessages(require(RColorBrewer))
 suppressMessages(require(sparseMatrixStats))

#Get info for bash script
args <- commandArgs()
name <- args[6]
outdir <- args[7]

print(str(outdir))
print(str(name))

outname <- sub('\\..*', '', name)

infile <- read.delim(name , header= F, sep = " ")
infile <- infile[,colSums(is.na(infile))<nrow(infile)]
print(str(infile))
  #Get summary information
  	 summary <- infile[ which(infile$V1=='SUMMARY' | infile$V1=='COMB_TOT_BP' | infile$V1=='COMB_TOT_PROP'), ]
 	 	if (nrow(summary) < 2) stop ("SUMMARY information not present, there is something wrong with the input file")
	 summary <- summary[,-1]
 	 namez <- paste0(outname, "_summary.txt")
  	 write.table(summary, namez , sep = " ", col.names = F, row.names = F, quote =F)
  	 summary <- as.data.frame(summary)
  	 print("R ALERT: Summary Written")
print(str(summary))
  #Get genome sizes in basepairs - may get NAs, don't worry
  gsize = as.numeric(as.character(summary[1:2,5]))
  asize =gsize[2]
  gsize = gsize[1]
  
  print(str(gsize),str(asize))
  #make rounding function
  mround <- function(x,base){ 
    base*round(x/base) 
  } 
  
  #make a variety of color ramp for  graphs
  	colfunc1 <- colorRampPalette(c("darkred", "darkgreen"))
  	colfunc2 <- colorRampPalette(c("darkred", "darkblue"))
  	colfunc3 <- colorRampPalette(c("orange", "darkblue"))
  	colfunc4 <- colorRampPalette(c("darkgreen", "red", "darkblue", "orange", "purple", "yellow", "blue", "red", "green"))
  	colfunc5 <- colorRampPalette(c("gold", "darkblue", "red", "orange", "green"))
 	colfunc6 <- colorRampPalette(c("green", "darkgreen"))
 	colfunc7 <- colorRampPalette(c("red", "darkred"))
  	colfunc8 <- colorRampPalette(c("blue", "darkblue"))
  	colfunc9 <- colorRampPalette(c("yellow", "orange"))
  	colfunc10 <- colorRampPalette(c("white", "black"))
  	colfunc11 <- colorRampPalette(c("white", "gray", "black"))
  
  #Total mean coverage for populations 
  	tma <-   infile[ which(infile$V1=='TMA'), ]
  	print(str(tma))
  		tma<- tma[1:3]
  		  	print(str(tma))
 	tms <-  infile[ which(infile$V1=='TMS'), ]
  	tma$V4 <- tms$V3
  	  	print(str(tma))
  	tma <- tma[,-1]
  	  	print(str(tma))
  	colnames(tma) <- c("Population", "Mean_Coverage", "Stdev")
  	  	print(str(tma))
  	tma$Mean_Coverage <- as.numeric(as.character(tma$Mean_Coverage))
  	  	print(str(tma))
 	tma$Stdev <- as.numeric(as.character(tma$Stdev))
 	  	print(str(tma))	
  	tma$Population <- as.numeric(as.character(tma$Population))
  	tma <- tma[order(tma$Population),]
  	print(str(tma))

  	if (nrow(tma) < 1) stop ("Mean coverage information not present; something is wrong with input file")


 	if (nrow(tma) > 1) {
  		meanr <- mean(tma$Mean_Coverage)
   		stdr <- stdev(tma$Mean_Coverage)
    		sumr <- data.frame("Mean", meanr,stdr)
    		colnames(sumr) <- c("Population", "Mean_Coverage", "Stdev")
   		tma <- rbind(tma,sumr)
 	 }
  	print(str(sumr))
  	  	print(str(tma))
	  pnumz <- as.numeric(nrow(tms))
 	  tma$Population <- factor(tma$Population, levels = unique(tma$Population))
  		# Check if it's a vector and not a matrix 
if (is.vector(tma$Mean_Coverage) && !is.matrix(tma$Mean_Coverage)) { 
# Convert vector to a column matrix (n rows, 1 column) 
tma_mean_coverage  <- matrix(tma$Mean_Coverage, ncol = 1) 
tma_stdev <- matrix(tma$Stdev, ncol = 1) 
} else { 
tma_mean_coverage  <- tma$Mean_Coverage
tma_stdev <- tma$Stdev
}

		#Custom ticking - get ticks based on scale 
  			scalehigh <- colMaxs(tma_mean_coverage)+colMaxs(tma_stdev)
 			scalelow <- colMins(tma_mean_coverage)-colMaxs(tma_stdev)
  			diff <- scalehigh - scalelow

  		##TICK ADJUST##
 			 if (diff > 0 && diff < .05) {
   				 bey =.0001
   				 scalez <- scaley <- mround(scalehigh,bey)
    				scaley <- mround(scalez, bey)
  			}
     			if (diff > 0.05 && diff < .15) {
   				 bey =.005
    				scalez <- scaley <- mround(scalehigh,bey)
   				 scaley <- mround(scalez, bey)
  			}
   			if (diff > .15 && diff < .25) {
   				 bey =.01
    				scalez <- scaley <- mround(scalehigh,bey)
   				scaley <- mround(scalez, bey)
  			}
 			if (diff > .25 && diff < .5) {
   				 bey =.025
   				 scalez <- scaley <- mround(scalehigh,bey)
    				scaley <- mround(scalez, bey)
  			}
     			if (diff > .5 && diff < 1.05) {
    				bey =.05
   				scalez <- scaley <- mround(scalehigh,bey)
   				scaley <- mround(scalez, bey)
  			}
   			if (diff > 1.05 && diff < 2.5) {
  				bey =.15
    				scalez <- scaley <- mround(scalehigh,bey)
    				scaley <- mround(scalez, bey)
  			}
    			if (diff > 2.5 && diff < 5) {
    				bey =.25
    				scalez <- scaley <- mround(scalehigh,bey)
    				scaley <- mround(scalez, bey)
  			}
  			if (diff > 5 && diff < 10) {
    				bey =.5
    				scalez <- scaley <- mround(scalehigh,bey)
    				scaley <- mround(scalez, bey)
  			}
  			if (diff > 10 && diff < 20) {
    				bey = 1
    				scalez <- scaley <- mround(scalehigh,bey)
    				scaley <- mround(scalez, bey)
  			}
  			if (diff > 20 && diff < 40) {
    				bey =2
    				scalez <- scaley <- mround(scalehigh,bey)
    				scaley <- mround(scalez, bey)
  			}
  			if (diff > 40 && diff < 80) {
    				bey =5
    				scalez <- scaley <- mround(scalehigh,bey)
    				scaley <- mround(scalez, bey)
  			}
  			if (diff > 80 && diff < 100) {
    				bey =5
    				scalez <- scaley <- mround(scalehigh,bey)
    				scaley <- mround(scalez, bey)
  			}
  			if (diff > 100 && diff < 150) {
    				bey =10
    				scalez <- scaley <- mround(scalehigh,bey)
    				scaley <- mround(scalez, bey)
  			}
  			if (diff > 150 && diff < 200) {
    				bey =15
    				scalez <- scaley <- mround(scalehigh,bey)
    				scaley <- mround(scalez, bey)
  			}
  			if (diff > 200 && diff < 400) {
    				bey =50
    				scalez <- scaley <- mround(scalehigh,bey)
    				scaley <- mround(scalez, bey)
  			}
  			if (diff > 400) {
    				bey =100
    				scalez <- scaley <- mround(scalehigh,bey)
    				scaley <- mround(scalez, bey)
  			}
  		##TICK ADJUST DONE##
print(tma)

	#plot
  	q <- ggplot(tma, aes(x = Population, y = Mean_Coverage, fill = Population)) + 
   	 geom_bar(stat = "identity", width =.9, colour ="black", linewidth =.25)  +
    	geom_errorbar(aes(ymin=Mean_Coverage-Stdev,ymax=Mean_Coverage+Stdev), width=.2, linewidth = .25, position=position_dodge(.9))
  
  	p <- q + labs(title= "Mean Depth of Coverage", x= "Library", y = "Mean Depth of Coverage (X)") + 
   	 theme(
     	 legend.position="none",
      	axis.ticks.x=element_blank(),  panel.grid.major = element_blank(), panel.grid.minor = element_blank(),  panel.background = element_blank(),
      	panel.border = element_rect(colour = "black", fill=NA, linewidth=.25)) +
    
    	scale_fill_manual(values= c(rep("darkblue",pnumz), "darkgreen")) +
    	# scale_fill_manual( values= colfunc1(nrow(tma))) +
    	geom_hline(yintercept=0)
  
 	 if (scalehigh != scalelow){
    		r <- p + scale_y_continuous(breaks=seq(0,scalez,bey))
  	}
  
 	 if (scalehigh == scalelow){
   		 r <- p 
  	}	
  	namez <- paste0(outname, "_mean_coverage.pdf")
    	savePlot <- function(r) {
   	pdf(namez, width=10, height=6)
   	print(r) 
    	invisible(dev.off())
  	}
  	savePlot(r)
  
  print("R ALERT: Mean Coverage Stats Complete")

