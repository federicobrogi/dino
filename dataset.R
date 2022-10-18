######## REGRESSION ADJUSTMENT Read data #######
load("JTRAIN2.Rda")
JTRAIN2<-as.data.frame(JTRAIN2)
vars <- names(JTRAIN2)

### subset 
JTRAIN2_W1 <- JTRAIN2 %>% filter(train==1) 
JTRAIN2_W0 <- JTRAIN2 %>% filter(train==0)
################################################