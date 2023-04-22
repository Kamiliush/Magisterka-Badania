#library(dplyr)
#library(ggplot2)
#library(tidyverse)

forzaBase <- read.csv(file = './dane/forza/base.csv',sep = ';')
forzaDLSSQuality <- read.csv(file = './dane/forza/dlss-jakosc.csv',sep = ';')
forzaDLSSBalance <- read.csv(file = './dane/forza/dlss-balans.csv',sep = ';')
forzaDLSSPerformance <- read.csv(file = './dane/forza/dlss-wydajnosc.csv',sep = ';')
forzaFSRQuality <- read.csv(file = './dane/forza/fsr-jakosc.csv',sep = ';')
forzaFSRBalance <- read.csv(file = './dane/forza/fsr-balans.csv',sep = ';')
forzaFSRPerformance <- read.csv(file = './dane/forza/fsr-wydajnosc.csv',sep = ';')


forzaBase <- tibble::rowid_to_column(forzaBase, "Second")
forzaDLSSQuality <- tibble::rowid_to_column(forzaDLSSQuality, "Second")
forzaDLSSBalance <- tibble::rowid_to_column(forzaDLSSBalance, "Second")
forzaDLSSPerformance <- tibble::rowid_to_column(forzaDLSSPerformance, "Second")
forzaFSRQuality <- tibble::rowid_to_column(forzaFSRQuality, "Second")
forzaFSRBalance <- tibble::rowid_to_column(forzaFSRBalance, "Second")
forzaFSRPerformance <- tibble::rowid_to_column(forzaFSRPerformance, "Second")



forzaBase$Dataset <- "Base"
forzaDLSSQuality$Dataset <- "DLSS Quality"
forzaDLSSBalance$Dataset <- "DLSS Balance"
forzaDLSSPerformance$Dataset <- "DLSS Performance"
forzaFSRQuality$Dataset <- "FSR Quality"
forzaFSRBalance$Dataset <- "FSR Balance"
forzaFSRPerformance$Dataset <- "FSR Performance"

# colnames(forzaBase)
# colnames(forzaDLSSQuality)
# colnames(forzaDLSSBalance)
# colnames(forzaDLSSPerformance)
# colnames(forzaFSRQuality)
# colnames(forzaFSRBalance)
# colnames(forzaFSRPerformance)

forza-combined-data <- rbind(forzaBase, forzaDLSSQuality, forzaDLSSBalance, forzaDLSSPerformance,
                             forzaFSRQuality, forzaFSRBalance, forzaFSRPerformance)

write.table(forza-combined-data, file = "forza-combined-data.csv", 
            row.names = FALSE, dec = ".", sep = ";", quote = FALSE)

ggplot(data = forza-combined-data, aes(x = Second, y = Framerate, color = Dataset)) +
  geom_line() +
  labs(title = "Framerate Comparison - Forza Horizon 5",
       x = "Time (s)",
       y = "Framerate") +
  theme_minimal() +
  scale_color_manual(values = c("Base" = "blue", 
                                "DLSS Quality" = "red", 
                                "DLSS Balance" = "green", 
                                "DLSS Performance" = "purple",
                                "FSR Quality" = "orange",
                                "FSR Balance" = "cyan",
                                "FSR Performance" = "darkgreen")) +
  theme(legend.title = element_blank())



########### Forza dlss jakość do poprawy!

