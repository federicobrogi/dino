###########################################
# R CODE TO PERFORM REGRESSION ADJUSTMENT #
###########################################

library(tidyverse)
library(wooldridge)
data("jtrain2")

y <- "re78"    #outcome: 1 variable
x <- c("re74", "re75", "age", "agesq", "nodegree")   # covariates
w <- "train"   # treatment: 1 variable

JTRAIN2_W1 <- jtrain2 %>% filter(train==1)
JTRAIN2_W0 <- jtrain2 %>% filter(train==0)

fmla <- as.formula(paste(y, "~", paste(x, collapse= "+")))

lm1<-lm(fmla,data=JTRAIN2_W1)
y1_x <-predict(lm1,type="response",jtrain2)

lm0<-lm(fmla,data=JTRAIN2_W0)
y0_x <-predict(lm0,type="response",jtrain2)

ATE<- mean (y1_x - y0_x)  #AVERAGE TREATEMENT EFFECT    .4035484
POmean <- mean(y0_x)      #AVERAGE TREATEMENT EFFECT ON NON TREATED  4.598974
