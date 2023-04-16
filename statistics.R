library("ggplot2")

#Is mRNA produced dependent on time ?

ID1.4.5.6.7[,"Time"] <- as.factor(ID1.4.5.6.7[,"Time"])
#as.factor() function converts a column from numeric to factor
#(factor in R is also known as categorical variable)

#boxplot

ggplot(data=ID1.4.5.6.7,aes(x=Time, y=mRNA, fill=Time)) +
  geom_boxplot(varwidth=TRUE,notch = TRUE) +
  
  stat_boxplot(geom="errorbar")+
  
  labs(title="", subtitle="",x = "Time [min]",y = "mRNA")+
  guides(fill=guide_legend(title="Time [min]"))+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5))

#histogram

ggplot(data = ID1.4.5.6.7, aes(x=mRNA, group = Time, fill=Time)) + 
  geom_histogram() +  
  labs(title="", subtitle="",y="Count", x="mRNA")+
  geom_vline(xintercept = 0,lty=4,lwd=1,color="red")+
  guides(fill=guide_legend(title="Time [min]"))+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5))

#Check the normality assumptions: q-q plot

x1<-ID1.4.5.6.7[ID1.4.5.6.7$Time==0,"mRNA"]
qqnorm(x1,main="Normal qq-plot (0 min)",ylab="Empirical Quantiles"
       ,xlab="Theoretical Quantiles",pch=19,col="blue",ylim = c(-1,1))
qqline(x1,col="red",lty=4,lwd=2)
grid()

x1<-ID1.4.5.6.7[ID1.4.5.6.7$Time==120,"mRNA"]
qqnorm(x1,main="Normal qq-plot (120 min)",ylab="Empirical Quantiles"
       ,xlab="Theoretical Quantiles",pch=19,col="blue",ylim = c(-1,1))
qqline(x1,col="red",lty=4,lwd=2)
grid()

#Data have already undergone log10 transformation by scientists.

#t-test between two groups 0 min and 120 min
x1 <- ID1.4.5.6.7[ID1.4.5.6.7$Time==0,"mRNA"]
x2 <- ID1.4.5.6.7[ID1.4.5.6.7$Time==120,"mRNA"]
t.test(x1,x2)



#t-test
#The multiple testing problem for GENE
genes <- unique(ID1.4.5.6.7$Gene)
p_values <- c()
for (gene_i in genes) {
  index1 = (ID1.4.5.6.7$Time == 0) & (ID1.4.5.6.7$Gene==gene_i)
  index2 = (ID1.4.5.6.7$Time == 120) & (ID1.4.5.6.7$Gene==gene_i)
  x10 <- ID1.4.5.6.7[index1,"mRNA"]
  x11 <- ID1.4.5.6.7[index2,"mRNA"]
  if ((length(x10)>2) & (length(x11)>2)){
    t_test_i <- t.test(x10,x11)
    p_value_i <- t_test_i$p.value
    p_values <- c(p_values,p_value_i)
  }else{
    p_values <- c(p_values,NA)
  }
}
results <- data.frame(Gene=genes,pValue=p_values)
results

results <-results[! is.na(results$pValue),]
results

results[results$pValue<0.05,"Gene"]
#Therefore, out of 5 genes, 3 have a different mRNA value produced with
#The passage of time

#Multiple adjustment test
p.adjust(p_values,method = "holm")

#Person's correlation 
ID1.4.5.6.7[,"Time"] <- as.numeric(ID1.4.5.6.7[,"Time"])
corr_mRNA_Time <- cor(ID1.4.5.6.7[,"mRNA"],ID1.4.5.6.7[,"Time"])

ggplot(data=ID1.4.5.6.7, aes(x=Time,y=mRNA)) +
  geom_point(aes(col=Gene)) +
  scale_x_discrete(limits=c('0','20','40','60','120'))+
  ggtitle(paste("cor=",round(corr_mRNA_Time,digits = 4),sep=""))+
  labs(title=paste("cor=",round(corr_mRNA_Time,digits = 4)),x="Time")+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5))  

cor.test(ID1.4.5.6.7[,"mRNA"],ID1.4.5.6.7[,"Time"])

#The linear model mRNA vs Time

ggplot(data=ID1.4.5.6.7, aes(x=Time,y=mRNA)) +
  geom_point(aes(col=Gene)) +
  geom_smooth(method="lm") +  #confidence interval
  scale_x_discrete(limits=c('0','20','40','60','120'))+
  ggtitle(paste("cor=",round(corr_mRNA_Time,digits = 4),sep=""))+
  labs(title=paste("cor=",round(corr_mRNA_Time,digits = 4)),x="Time")+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5))  

lm_mRNATime <- lm(mRNA~Time, data=ID1.4.5.6.7)

summary(lm_mRNATime)

#Goodness of fit: check of the variance of the residuals
plot(lm_mRNATime)

#Levene's Test 
install.packages("car")
library(car)

ID1.4.5.6.7[,"Time"] <- as.factor(ID1.4.5.6.7[,"Time"])
leveneTest(mRNA ~ Time, data =ID1.4.5.6.7)

#Predict with the built linear model
ID1.4.5.6.7[,"Time"] <- as.numeric(ID1.4.5.6.7[,"Time"])

predict_ID1.4.5.6.7 <- predict(lm_mRNATime, ID1.4.5.6.7)

ID1.4.5.6.7$predicted_mRNA <- predict_ID1.4.5.6.7

colors <- c("data" = "Blue", "predicted_mRNA" = "red","fit"="Blue")

ggplot( data = ID1.4.5.6.7, aes(x=Time,y=mRNA,color="data")) +
  geom_point()+
  scale_x_continuous(breaks = c(0,20,40,60,120))+
  labs(title="ID-1,ID-4,ID-5,ID-6,ID-7",y="mRNA", x="Time [min]", color = "Legend") +
  scale_color_manual(values = colors)+
  geom_line(aes(x=Time,y=predicted_mRNA,color="predicted_mRNA"),lwd=1.3)+
  geom_smooth(method = "lm",aes(color="fit",lty=2),se=TRUE,lty=2)+
  scale_color_manual(values = colors)+
  guides(color = guide_legend(override.aes = list(shape = c(16, NA, NA), linetype = c("blank", "dashed", "solid"))))+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5),legend.key.width = unit(30, "points")) 

#Check if the model predicts well other 5 genes (load again the ID1.4.5.6.7 and ID1001.2.3.4)

predicted_ID1001.2.3.4 <- predict(lm_mRNATime,ID1001.2.3.4)
ID1001.2.3.4
predicted_ID1001.2.3.4

colors <- c("data" = "orange", "predicted_mRNA" = "red","fit"="Blue")

ggplot(data = ID1001.2.3.4,aes(x=Time,y=mRNA,color="data"))+
  geom_point()+
  scale_x_continuous(breaks = c(0,20,40,60,120))+
  geom_line(aes(x=Time,y=predicted_ID1001.2.3.4,color="predicted_mRNA"),lwd=1.3)+
  geom_smooth(method="lm",aes(color="fit",lty=2),se=TRUE,lty=2)+
  labs(title="Other 5 genes",y="mRNA", x="Time [min]", color = "Legend") +
  scale_color_manual(values = colors)+
  guides(color = guide_legend(override.aes = list(shape = c(16, NA,NA), linetype = c("blank","dashed", "solid"))))+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5),legend.key.width = unit(30, "points"))

#Is the mRNA produced dependent on the condition ? (Irradiated or not)

RadVsNotRadiation[,"Condition"] <- as.factor(RadVsNotRadiation[,"Condition"])

ggplot(data=RadVsNotRadiation,aes(x=Condition, y=mRNA, fill=Condition)) +
  geom_boxplot(varwidth=FALSE,notch = TRUE) +
  
  stat_boxplot(geom="errorbar")+
  
  labs(title="", subtitle="",x = "Time [min]",y = "mRNA")+
  guides(fill=guide_legend(title="Time [min]"))+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5))

#To visually show also data
ggplot() +
  geom_point(data=RadVsNotRadiation,aes(x=Condition, y=mRNA),shape=1,size=3)+
  geom_boxplot(data=RadVsNotRadiation,aes(x=Condition, y=mRNA, fill=Condition),varwidth=FALSE,notch = FALSE,alpha=0.3) +
  
  stat_boxplot()+
  scale_x_discrete(labels = c("Irradiated","Reference"))+
  
  labs(title="", subtitle="",x = "",y = "mRNA")+
  guides(fill=guide_legend(title="Condition"))+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5))

#Drop NA values from dataframe

new_df <- na.omit(RadVsNotRadiation)

#Select only irradiated rows using the subset function

Irradiated <- subset(new_df, Condition=="Irradiated")

summary(Irradiated)

#Select only reference rows using the subset function

Reference <- subset(new_df, Condition=="reference")

summary(Reference)

#Welch Two Sample t-test

x <- RadVsNotRadiation[RadVsNotRadiation$Condition=='Irradiated',"mRNA"]
y <- RadVsNotRadiation[RadVsNotRadiation$Condition=='reference',"mRNA"]
t.test(x,y)

#5 Genes

order <- c('Ref','20','40','60','120')
ggplot(data=FiveGenesRefIrr,aes(x=Time, y=mRNA, fill=Time)) +
  geom_boxplot(varwidth=TRUE,notch = TRUE) +
  
  stat_boxplot(geom="errorbar")+
  scale_x_discrete(limits=c("Ref","0","20","40","60","120")) +
  
  labs(title="DNA Repair Genes", subtitle="",x = "Time [min]",y = "mRNA")+
  guides(fill=guide_legend(title="Time [min]"))+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5))

res.aov <- aov(mRNA~Time,data=FiveGenesRefIrr)
summary(res.aov)

#DNA Repair Genes

order <- c('Ref','20','40','60','120')
ggplot(data=DNARepairGenes,aes(x=Condition, y=mRNA, fill=Condition)) +
  geom_boxplot(varwidth=TRUE,notch = TRUE) +
  
  stat_boxplot(geom="errorbar")+
  scale_x_discrete(limits=c("Ref","0","20","40","60","120")) +
  
  labs(title="DNA Repair Genes", subtitle="",x = "Time [min]",y = "mRNA")+
  guides(fill=guide_legend(title="Time [min]"))+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5))

res.aov <- aov(mRNA~Condition,data=DNARepairGenes)
summary(res.aov)

#t-test between two groups Ref and 0 min

x1 <- DNARepairGenes[DNARepairGenes$Condition =='Ref',"mRNA"]
x2 <- DNARepairGenes[DNARepairGenes$Condition==0,"mRNA"]
t.test(x1,x2)
t.test(x1,x2,alternative="greater")




#correlation coefficient between two groups of data 
#(ref and at 0 min after irradiation)

timezero <- subset(DNARepairGenes, Condition==0)
timezero[timezero == "0"] <- 1

ref <- subset(DNARepairGenes, Condition=="Ref")
ref[ref=="Ref"] <- 0

bothdfs <- rbind(ref, timezero)

bothdfs

bothdfs[,"Condition"] <- as.numeric(bothdfs[,"Condition"])

cor.test(bothdfs[,"mRNA"],bothdfs[,"Condition"])