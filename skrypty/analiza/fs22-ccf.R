library(dplyr)
library(tidyverse)
library(gridExtra)
library(ggfortify)
library(Cairo)
Cairo()

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



farmingSimulatorBase$Dataset <- "Bazowy"
farmingSimulatorDLSSQuality$Dataset <- "DLSS Jakość"
farmingSimulatorDLSSBalance$Dataset <- "DLSS Balans"
farmingSimulatorDLSSPerformance$Dataset <- "DLSS Wydajność"
farmingSimulatorFSRQuality$Dataset <- "FSR Jakość"
farmingSimulatorFSRBalance$Dataset <- "FSR Balans"
farmingSimulatorFSRPerformance$Dataset <- "FSR Wydajność"

ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorFSRQuality$Framerate) #-9
ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorFSRPerformance$Framerate) #-3 
plot(ccf_result)
ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorFSRBalance$Framerate) #-4
ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorDLSSQuality$Framerate) #-4
ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorDLSSPerformance$Framerate) #-16
ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorDLSSBalance$Framerate) #-6



ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorFSRQuality$Framerate, plot = FALSE)
p1 <- autoplot(ccf_result, 
               main = "Korelacja krzyżowa pomiędzy Bazowy a FSR Jakość",
               ylab = "Korelacja krzyżowa",
               xlab = "Opóźnienie")
ggsave('./eksporty/ccf/fs22_base_fsr_quality.png', p1, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorFSRPerformance$Framerate, plot = FALSE)
p2 <- autoplot(ccf_result,
               main = "Korelacja krzyżowa pomiędzy Bazowy a FSR Wydajność",
               ylab = "Korelacja krzyżowa",
               xlab = "Opóźnienie")
ggsave('./eksporty/ccf/fs22_base_fsr_performance.png', p2, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorFSRBalance$Framerate, plot = FALSE)
p3 <- autoplot(ccf_result,
               main = "Korelacja krzyżowa pomiędzy Bazowy a FSR Balans",
               ylab = "Korelacja krzyżowa",
               xlab = "Opóźnienie")
ggsave('./eksporty/ccf/fs22_base_performance_fsr_balance.png', p3, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorDLSSQuality$Framerate, plot = FALSE)
p4 <- autoplot(ccf_result,
               main = "Korelacja krzyżowa pomiędzy Bazowy a DLSS Jakość",
               ylab = "Korelacja krzyżowa",
               xlab = "Opóźnienie")
ggsave('./eksporty/ccf/fs22_base_performance_dlss_quality.png', p4, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorDLSSPerformance$Framerate, plot = FALSE)
p5 <- autoplot(ccf_result,
               main = "Korelacja krzyżowa pomiędzy Bazowy a DLSS Wydajność",
               ylab = "Korelacja krzyżowa",
               xlab = "Opóźnienie")
ggsave('./eksporty/ccf/fs22_base_performance_dlss_performance.png', p5, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorDLSSBalance$Framerate, plot = FALSE)
p6 <- autoplot(ccf_result,
               main = "Korelacja krzyżowa pomiędzy Bazowy a DLSS Balans",
               ylab = "Korelacja krzyżowa",
               xlab = "Opóźnienie")
ggsave('./eksporty/ccf/fs22_base_performance_dlss_balance.png', p6, width = 10, height = 6, dpi = 300)

grid.arrange(p1, p2, p3, p4, p5, p6, nrow = 6, ncol = )
ggsave('./eksporty/ccf/combined_ccf.png', grid.arrange(p1, p2, p3, p4, p5, p6, nrow = 6, ncol = 1), 
       width = 7, height = 12, dpi = 300)