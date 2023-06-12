library(dplyr)
library(ggplot2)
library(tidyverse)
library(coin)
CairoWin()

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



cyberpunkBase$Dataset <- "Bazowy"
cyberpunkDLSSQuality$Dataset <- "DLSS Jakość"
cyberpunkDLSSBalance$Dataset <- "DLSS Balans"
cyberpunkDLSSPerformance$Dataset <- "DLSS Wydajność"
cyberpunkFSRQuality$Dataset <- "FSR Jakość"
cyberpunkFSRBalance$Dataset <- "FSR Balans"
cyberpunkFSRPerformance$Dataset <- "FSR Wydajność"

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

g <- ggplot(data = combined_data, aes(x = Second, y = Framerate, color = Dataset)) +
  geom_line(linewidth = 0.2) +
  labs(title = "Porównanie liczby klatek na sekundę - Cyberpunk 2077",
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
  scale_x_continuous(breaks = seq(0, 250, 5)) + # skalowanie osi x od 0 do 250 co 50
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 8), #zmniejsza czcionkę w legendzie
        plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        legend.position="bottom") # przenosi legendę na dół

ggsave(g, filename = './eksporty/FPS/cyberpunk.png', dpi = 300, type = 'cairo',
       width = 8, height = 4, units = 'in', bg = 'white')

ccf_result <- ccf(cyberpunkBase$Framerate, cyberpunkFSRQuality$Framerate) #0
ccf_result <- ccf(cyberpunkBase$Framerate, cyberpunkFSRPerformance$Framerate) #0
ccf_result <- ccf(cyberpunkBase$Framerate, cyberpunkFSRBalance$Framerate) #0
ccf_result <- ccf(cyberpunkBase$Framerate, cyberpunkDLSSQuality$Framerate) #0
ccf_result <- ccf(cyberpunkBase$Framerate, cyberpunkDLSSPerformance$Framerate) #0
ccf_result <- ccf(cyberpunkBase$Framerate, cyberpunkDLSSBalance$Framerate) #-1



ccf_result <- ccf(cyberpunkBase$Framerate, cyberpunkFSRQuality$Framerate, plot = FALSE)
p <- autoplot(ccf_result, 
              main = "Korelacja krzyżowa pomiędzy Bazowy a FSR Jakość",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/cyberpunk_base_fsr_quality.png', p, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(cyberpunkBase$Framerate, cyberpunkFSRPerformance$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy Bazowy a FSR Wydajność",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/cyberpunk_base_fsr_performance.png', p, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(cyberpunkBase$Framerate, cyberpunkFSRBalance$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy Bazowy a FSR Balans",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/cyberpunk_base_performance_fsr_balance.png', p, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(cyberpunkBase$Framerate, cyberpunkDLSSQuality$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy Bazowy a DLSS Jakość",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/cyberpunk_base_performance_dlss_quality.png', p, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(cyberpunkBase$Framerate, cyberpunkDLSSPerformance$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy Bazowy a DLSS Wydajność",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/cyberpunk_base_performance_dlss_performance.png', p, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(cyberpunkBase$Framerate, cyberpunkDLSSBalance$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy Bazowy a DLSS Balans",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/cyberpunk_base_performance_dlss_balance.png', p, width = 10, height = 6, dpi = 300)

