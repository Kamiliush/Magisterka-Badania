library(dplyr)
library(ggplot2)
library(gridExtra)

farmingSimulatorBase <- read.csv(file = './dane/farming-simulator/bazowy.csv',sep = ';')
farmingSimulatorDLSSQuality <- read.csv(file = './dane/farming-simulator/dlss-jakosc.csv',sep = ';')
farmingSimulatorDLSSBalance <- read.csv(file = './dane/farming-simulator/dlss-balans.csv',sep = ';')
farmingSimulatorDLSSPerformance <- read.csv(file = './dane/farming-simulator/dlss-wydajnosc.csv',sep = ';')
farmingSimulatorFSRQuality <- read.csv(file = './dane/farming-simulator/fsr-jakosc.csv',sep = ';')
farmingSimulatorFSRBalance <- read.csv(file = './dane/farming-simulator/fsr-balans.csv',sep = ';')
farmingSimulatorFSRPerformance <- read.csv(file = './dane/farming-simulator/fsr-wydajnosc.csv',sep = ';')

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
  labs(title = "Porównanie liczby klatek na sekundę - Farming Simulator 22",
       x = "Czas (s)",
       y = "Klatki na sekundę (FPS)") +
  theme_minimal() +
  scale_color_manual(values = c("Bazowy" = "blue", 
                                "DLSS Jakość" = "red", 
                                "DLSS Balans" = "green", 
                                "DLSS Wydajność" = "purple",
                                "FSR Jakość" = "orange",
                                "FSR Balans" = "cyan",
                                "FSR Wydajność" = "yellow")) +
  scale_x_continuous(breaks = seq(0, 250, 25)) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 12), # Zwiększenie czcionki w legendzie
        plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        legend.position="bottom") 

ggsave(g, filename = './eksporty/FPS/farming.png', dpi = 300,
       width = 8, height = 4, units = 'in', bg = 'white')
