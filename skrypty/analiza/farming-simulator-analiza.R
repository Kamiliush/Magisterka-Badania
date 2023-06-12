library(dplyr)
library(ggplot2)
library(tidyverse)
CairoWin()


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

farmingSimulatorCombinedData <- rbind(farmingSimulatorBase, farmingSimulatorDLSSQuality, farmingSimulatorDLSSBalance, 
                       farmingSimulatorDLSSPerformance,farmingSimulatorFSRQuality, 
                       farmingSimulatorFSRBalance, farmingSimulatorFSRPerformance)

write.table(farmingSimulatorCombinedData, file = "farming-simulator-combined-data.csv", 
            row.names = FALSE, dec = ".", sep = ";", quote = FALSE)


g <- ggplot(data = farmingSimulatorCombinedData, aes(x = Second, y = Framerate, color = Dataset)) +
  geom_line(linewidth = 0.2) +
  labs(title = "Porównanie liczby klatek na sekundę - Farming",
       x = "Czas (s)",
       y = "Klatki na sekundę") +
  theme_minimal() +
  scale_color_manual(values = c("Bazowy" = "blue", 
                                "DLSS Jakość" = "red", 
                                "DLSS Balans" = "green", 
                                "DLSS Wydajność" = "purple",
                                "FSR Jakość" = "orange",
                                "FSR Balans" = "cyan",
                                "FSR Wydajność" = "yellow")) +
  scale_x_continuous(breaks = seq(0, 250, 25)) + # skalowanie osi x od 0 do 250 co 50
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 8), #zmniejsza czcionkę w legendzie
        plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        legend.position="bottom") # przenosi legendę na dół

ggsave(g, filename = './eksporty/FPS/farming.png', dpi = 300, type = 'cairo',
       width = 8, height = 4, units = 'in', bg = 'white')


ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorFSRQuality$Framerate) #-9
ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorFSRPerformance$Framerate) #-3 
plot(ccf_result)
ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorFSRBalance$Framerate) #-4
ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorDLSSQuality$Framerate) #-4
ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorDLSSPerformance$Framerate) #-16
ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorDLSSBalance$Framerate) #-6


ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorFSRQuality$Framerate, plot = FALSE)
p <- autoplot(ccf_result, 
              main = "Korelacja krzyżowa pomiędzy Bazowy a FSR Jakość",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/fs22_base_fsr_quality.png', p, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorFSRPerformance$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy Bazowy a FSR Wydajność",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/fs22_base_fsr_performance.png', p, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorFSRBalance$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy Bazowy a FSR Balans",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/fs22_base_performance_fsr_balance.png', p, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorDLSSQuality$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy Bazowy a DLSS Jakość",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/fs22_base_performance_dlss_quality.png', p, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorDLSSPerformance$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy Bazowy a DLSS Wydajność",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/fs22_base_performance_dlss_performance.png', p, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(farmingSimulatorBase$Framerate, farmingSimulatorDLSSBalance$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy Bazowy a DLSS Balans",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/fs22_base_performance_dlss_balance.png', p, width = 10, height = 6, dpi = 300)
