outlierKD <- function(dt, var) {
  var_name <- eval(substitute(var),eval(dt))
  na1 <- sum(is.na(var_name))
  m1 <- mean(var_name, na.rm = T)
  outlier <- boxplot.stats(var_name)$out
  mo <- mean(outlier)
  var_name <- ifelse(var_name %in% outlier, NA, var_name)
  na2 <- sum(is.na(var_name))
  m2 <- mean(var_name, na.rm = T)
  dt[as.character(substitute(var))] <- invisible(var_name)
  assign(as.character(as.list(match.call())$dt), dt, envir = .GlobalEnv)
  return(invisible(dt))
}
#modified from https://www.r-bloggers.com/identify-describe-plot-and-remove-the-outliers-from-the-dataset/


ml.est <- function(roi.in){
  require(fitdistrplus)
  roi.mod <- outlierKD(roi.in, ppm)     
  roi.mod <- roi.mod[complete.cases(roi.mod), ]                            #rm NA if outliers have been removed before function applied
  active <- roi.mod$ppm                                        #active <- Active if outliers removed      
  Active <- data.frame(active, active)                   #construct a dataframe for the MLE fit
  names(Active)[names(Active) == "active"] <- "left"
  names(Active)[names(Active) == "active.1"] <- "right"
  Active$left[Active$left == 0] <- NA
  Active.norm <- fitdistcens(Active, "norm")             #fit assuming that data are censored at 0
  out.vec <- c(Active.norm$estimate[1], Active.norm$estimate[2],length(roi.mod$ppm))
  return(out.vec)
}


bts.est <- function(x){
  resampled.means <- rep(NA,1000)
  x.stats <- rep(NA,2)
  for (i in 1:1000){
    resampled.means[i]<-mean(sample(x$ppm,200))
  }
  x.stats[1] <- mean(resampled.means)
  x.stats[2] <- sd(resampled.means)
  return(x.stats)
}

