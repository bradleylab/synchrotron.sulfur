library(tidyverse)
library(fitdistrplus)

#load sector data
anvil.data <- read.table("~/Anvil_SO4conc1.txt", header = FALSE)
heart.data <- read.table("~/Heart_SO4conc1.txt", header = FALSE)
names(anvil.data) <- c("y", "x", "ppm", "roi")
names(heart.data) <- c("y", "x", "ppm", "roi")

#assign ROIs using reported values. Assign 1-9 to Heart, 10-19 to Anvil
heart.data$roi[heart.data$roi == 0] <- NA    #NA the pixels that are not part of a ROI
heart.data$roi.new <- log2(heart.data$roi) + 1  #start ROI numbering at 1
anvil.data$roi[anvil.data$roi == 0] <- NA    #NA the pixels that are not part of a ROI
anvil.data$roi.new <- log2(anvil.data$roi) + 10 #continue ROI numbering at 10

#combine datasets
heart.data$sector <- rep("heart",length(heart.data$roi))
anvil.data$sector <- rep("anvil",length(anvil.data$roi))
all.data <- rbind(heart.data, anvil.data)
roi.data <- all.data %>% filter(!is.na(roi.new))
roi.ids <- sort(unique(roi.data$roi.new))

#add component info
components <- read.csv("~/roi.components.csv", header = TRUE)
roi.data$component <- components$component[match(roi.data$roi.new, components$roi, nomatch = NA, incomparables = NULL)]

#qqnorm plots
gg.qqnorm <- ggplot(roi.data) + geom_qq(aes(sample = ppm), size = 0.5) + facet_wrap(~roi.new, scales = "free") + labs(title = "QQ Norm for each ROI")
gg.qqnorm

#boxplots
gg.boxplot <- ggplot(roi.data, aes(factor(roi.new), ppm)) + labs(title = "ppm distributions") + xlab("ROI") + ylab("ppm sulfate") + scale_fill_brewer(palette="Dark2") 
gg.boxplot <- gg.boxplot + geom_boxplot(notch = TRUE, aes(fill = factor(component)), outlier.size = 0.5)  + guides(fill=guide_legend(title="Component"))
gg.boxplot

#histograms
x.low <- -200
x.high <- 700
x.seq <- seq(x.low, x.high) 
roi.list <- split(roi.data, roi.data$roi.new) #split out datasets by ROI
roi.mle <- roi.list %>% map(safely(ml.est)) #MLE estimate w outliers excluded
#extract the summary statistics 
roi.summary.mean <- roi.mle %>% map(first) %>% map(first)
roi.summary.mean[sapply(roi.summary.mean, is.null)] <- NA
roi.summary.mean <- as.vector(unlist(roi.summary.mean))
roi.summary.sd <- roi.mle %>% map(first) %>% map(nth,2)
roi.summary.sd[sapply(roi.summary.sd, is.null)] <- NA
roi.summary.sd <- as.vector(unlist(roi.summary.sd))
roi.summary.n <- roi.mle %>% map(first) %>% map(nth,3)
roi.summary.n[sapply(roi.summary.n, is.null)] <- NA
roi.summary.n <- as.vector(unlist(roi.summary.n))
roi.summary <- cbind.data.frame(roi.summary.mean, roi.summary.sd, roi.summary.n)
colnames(roi.summary) <- c("roi.mean", "roi.sd", "roi.n")
#
dens.curves <- expand.grid(x = x.seq, roi.new = roi.ids)
dens.curves$y  <- dnorm(dens.curves$x, mean = roi.summary[dens.curves$roi.new,]$roi.mean, sd = roi.summary[dens.curves$roi.new,]$roi.sd)
gg.histograms <- ggplot(roi.data) + facet_wrap(~roi.new) 
gg.histograms <- gg.histograms + geom_histogram(aes(x = ppm, y = ..density..), binwidth = 10, fill="grey60", linetype = "blank") + labs(x = "sulfate (ppm)") + xlim(x.low, x.high) + ylim(0, 0.025)
gg.histograms <- gg.histograms + geom_line(data = dens.curves, aes(x = x, y = y), color = "red")
#
