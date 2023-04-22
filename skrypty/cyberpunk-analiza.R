#install.packages("dplyr")
#install.packages("ggplot2")
#install.packages("tidyverse")
#library(dplyr)
#library(ggplot2)
#library(tidyverse)

cyberpunkBase <- read.csv(file = './dane/cyberpunk/bazowy.csv',sep = ';')
cyberpunkDLSSQuality <- read.csv(file = './dane/cyberpunk/dlss-jakosc.csv',sep = ';')
cyberpunkDLSSBalance <- read.csv(file = './dane/cyberpunk/dlss-balans.csv',sep = ';')
cyberpunkDLSSPerformance <- read.csv(file = './dane/cyberpunk/dlss-wydajnosc.csv',sep = ';')
cyberpunkFSRQuality <- read.csv(file = './dane/cyberpunk/fsr-jakosc.csv',sep = ';')
cyberpunkFSRBalance <- read.csv(file = './dane/cyberpunk/fsr-balans.csv',sep = ';')
cyberpunkFSRPerformance <- read.csv(file = './dane/cyberpunk/fsr-wydajnosc.csv',sep = ';')

# "Datetime GPU.temperature GPU.usage FB.usage Memory.usage Core.clock Power 
# CPU.temperature CPU.usage CPU.clock RAM.usage Framerate Frametime Framerate.Avg"

cyberpunkBase <- tibble::rowid_to_column(cyberpunkBase, "Second")
cyberpunkDLSSQuality <- tibble::rowid_to_column(cyberpunkDLSSQuality, "Second")
cyberpunkDLSSBalance <- tibble::rowid_to_column(cyberpunkDLSSBalance, "Second")
cyberpunkDLSSPerformance <- tibble::rowid_to_column(cyberpunkDLSSPerformance, "Second")
cyberpunkFSRQuality <- tibble::rowid_to_column(cyberpunkFSRQuality, "Second")
cyberpunkFSRBalance <- tibble::rowid_to_column(cyberpunkFSRBalance, "Second")
cyberpunkFSRPerformance <- tibble::rowid_to_column(cyberpunkFSRPerformance, "Second")



cyberpunkBase$Dataset <- "Base"
cyberpunkDLSSQuality$Dataset <- "DLSS Quality"
cyberpunkDLSSBalance$Dataset <- "DLSS Balance"
cyberpunkDLSSPerformance$Dataset <- "DLSS Performance"
cyberpunkFSRQuality$Dataset <- "FSR Quality"
cyberpunkFSRBalance$Dataset <- "FSR Balance"
cyberpunkFSRPerformance$Dataset <- "FSR Performance"

# colnames(cyberpunkBase)
# colnames(cyberpunkDLSSQuality)
# colnames(cyberpunkDLSSBalance)
# colnames(cyberpunkDLSSPerformance)
# colnames(cyberpunkFSRQuality)
# colnames(cyberpunkFSRBalance)
# colnames(cyberpunkFSRPerformance)

combined_data <- rbind(cyberpunkBase, cyberpunkDLSSQuality, cyberpunkDLSSBalance, cyberpunkDLSSPerformance,
                       cyberpunkFSRQuality, cyberpunkFSRBalance, cyberpunkFSRPerformance)

# write.csv(combined_data, file = "combined_data.csv", row.names = FALSE, sep = ';')
write.table(combined_data, file = "cyberpunk-combined-data.csv", row.names = FALSE, dec = ".", sep = ";", quote = FALSE)

ggplot(data = combined_data, aes(x = Second, y = Framerate, color = Dataset)) +
  geom_line() +
  labs(title = "Framerate Comparison",
       x = "Time (s)",
       y = "Framerate") +
  theme_minimal() +
  scale_color_manual(values = c("Base" = "blue", 
                                "DLSS Quality" = "red", 
                                "DLSS Balance" = "green", 
                                "DLSS Performance" = "purple",
                                "FSR Quality" = "orange",
                                "FSR Balance" = "cyan",
                                "FSR Performance" = "yellow")) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 11),
        plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
  )
