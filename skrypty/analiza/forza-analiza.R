library(dplyr)
library(ggplot2)
library(tidyverse)
library(Cairo)
CairoWin()

forzaBase <- read.csv(file = './dane/forza/bazowy.csv',sep = ';')

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

forzaBase$Dataset <- "Bazowy"
forzaDLSSQuality$Dataset <- "DLSS Jakość"
forzaDLSSBalance$Dataset <- "DLSS Balans"
forzaDLSSPerformance$Dataset <- "DLSS Wydajność"
forzaFSRQuality$Dataset <- "FSR Jakość"
forzaFSRBalance$Dataset <- "FSR Balans"
forzaFSRPerformance$Dataset <- "FSR Wydajność"


# colnames(forzaBase)
# colnames(forzaDLSSQuality)
# colnames(forzaDLSSBalance)
# colnames(forzaDLSSPerformance)
# colnames(forzaFSRQuality)
# colnames(forzaFSRBalance)
# colnames(forzaFSRPerformance)

forza_combined_data <- rbind(forzaBase, forzaDLSSQuality, forzaDLSSBalance, forzaDLSSPerformance, forzaFSRQuality, forzaFSRBalance, forzaFSRPerformance)


write.table(forza_combined_data, file = "forza-combined-data.csv", 
            row.names = FALSE, dec = ".", sep = ";", quote = FALSE)

g <- ggplot(data = forza_combined_data, aes(x = Second, y = Framerate, color = Dataset)) +
  geom_line(linewidth = 0.2) +
  labs(title = "Porównanie liczby klatek na sekundę - Forza",
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
  scale_x_continuous(breaks = seq(0, 250, 10)) + # skalowanie osi x od 0 do 250 co 50
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 8), #zmniejsza czcionkę w legendzie
        plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        legend.position="bottom") # przenosi legendę na dół

ggsave(g, filename = './eksporty/FPS/forza.png', dpi = 300, type = 'cairo',
       width = 8, height = 4, units = 'in', bg = 'white')


ccf_result <- ccf(forzaDLSSPerformance$Framerate, forzaFSRQuality$Framerate) #-4
ccf_result <- ccf(forzaDLSSPerformance$Framerate, forzaFSRPerformance$Framerate) #-5
ccf_result <- ccf(forzaDLSSPerformance$Framerate, forzaFSRBalance$Framerate) #-5
ccf_result <- ccf(forzaDLSSPerformance$Framerate, forzaDLSSQuality$Framerate) #-4
ccf_result <- ccf(forzaDLSSPerformance$Framerate, forzaBase$Framerate) #-4
ccf_result <- ccf(forzaDLSSPerformance$Framerate, forzaDLSSBalance$Framerate) #-5


ccf_result <- ccf(forzaDLSSPerformance$Framerate, forzaFSRQuality$Framerate, plot = FALSE)
p <- autoplot(ccf_result, 
              main = "Korelacja krzyżowa pomiędzy DLSS Wydajność a FSR Jakość",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/forza_dlss_performance_fsr_quality.png', p, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(forzaDLSSPerformance$Framerate, forzaFSRPerformance$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy DLSS Wydajność a FSR Wydajność",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/forza_dlss_performance_fsr_performance.png', p, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(forzaDLSSPerformance$Framerate, forzaFSRBalance$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy DLSS Wydajność a FSR Balans",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/forza_dlss_performance_fsr_balance.png', p, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(forzaDLSSPerformance$Framerate, forzaDLSSQuality$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy DLSS Wydajność a DLSS Jakość",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/forza_dlss_performance_dlss_quality.png', p, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(forzaDLSSPerformance$Framerate, forzaBase$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy DLSS Wydajność a Bazowy",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/forza_dlss_performance_base.png', p, width = 10, height = 6, dpi = 300)


ccf_result <- ccf(forzaDLSSPerformance$Framerate, forzaDLSSBalance$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy DLSS Wydajność a DLSS Balans",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/forza_dlss_performance_dlss_balance.png', p, width = 10, height = 6, dpi = 300)



