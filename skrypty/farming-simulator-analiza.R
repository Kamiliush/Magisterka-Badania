install.packages("dplyr")
install.packages("ggplot2")
install.packages("tidyverse")
library(dplyr)
library(ggplot2)
library(tidyverse)

farmingSimulatorBase <- read.csv(file = './dane/farming-simulator/bazowy.csv',sep = ';')
farmingSimulatorDLSSQuality <- read.csv(file = './dane/farming-simulator/dlss-jakosc.csv',sep = ';')
farmingSimulatorDLSSBalance <- read.csv(file = './dane/farming-simulator/dlss-balans.csv',sep = ';')
farmingSimulatorDLSSPerformance <- read.csv(file = './dane/farming-simulator/dlss-wydajnosc.csv',sep = ';')
farmingSimulatorFSRQuality <- read.csv(file = './dane/farming-simulator/fsr-jakosc.csv',sep = ';')
farmingSimulatorFSRBalance <- read.csv(file = './dane/farming-simulator/fsr-balans.csv',sep = ';')
farmingSimulatorFSRPerformance <- read.csv(file = './dane/farming-simulator/fsr-wydajnosc.csv',sep = ';')

#"Datetime GPU.temperature GPU.usage FB.usage Memory.usage Core.clock Power 
#CPU.temperature CPU.usage CPU.clock RAM.usage Framerate Frametime Framerate.Avg"

farmingSimulatorBase <- tibble::rowid_to_column(farmingSimulatorBase, "Second")
farmingSimulatorDLSSQuality <- tibble::rowid_to_column(farmingSimulatorDLSSQuality, "Second")
farmingSimulatorDLSSBalance <- tibble::rowid_to_column(farmingSimulatorDLSSBalance, "Second")
farmingSimulatorDLSSPerformance <- tibble::rowid_to_column(farmingSimulatorDLSSPerformance, "Second")
farmingSimulatorFSRQuality <- tibble::rowid_to_column(farmingSimulatorFSRQuality, "Second")
farmingSimulatorFSRBalance <- tibble::rowid_to_column(farmingSimulatorFSRBalance, "Second")
farmingSimulatorFSRPerformance <- tibble::rowid_to_column(farmingSimulatorFSRPerformance, "Second")



farmingSimulatorBase$Dataset <- "Base"
farmingSimulatorDLSSQuality$Dataset <- "DLSS Quality"
farmingSimulatorDLSSBalance$Dataset <- "DLSS Balance"
farmingSimulatorDLSSPerformance$Dataset <- "DLSS Performance"
farmingSimulatorFSRQuality$Dataset <- "FSR Quality"
farmingSimulatorFSRBalance$Dataset <- "FSR Balance"
farmingSimulatorFSRPerformance$Dataset <- "FSR Performance"

farmingSimulatorCombinedData <- rbind(farmingSimulatorBase, farmingSimulatorDLSSQuality, farmingSimulatorDLSSBalance, 
                       farmingSimulatorDLSSPerformance,farmingSimulatorFSRQuality, 
                       farmingSimulatorFSRBalance, farmingSimulatorFSRPerformance)

write.table(farmingSimulatorCombinedData, file = "farming-simulator-combined-data.csv", 
            row.names = FALSE, dec = ".", sep = ";", quote = FALSE)

ggplot(data = farmingSimulatorCombinedData, aes(x = Second, y = Framerate, color = Dataset)) +
  geom_line(linewidth = 0.8) +
  labs(title = "Framerate Comparison - Farming Simulator 22",
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

ccf_result <- ccf(farmingSimulatorDLSSQuality$Framerate, farmingSimulatorFSRQuality$Framerate)

plot(ccf_result, type = 'h')
