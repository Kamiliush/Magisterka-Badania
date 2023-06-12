library(dplyr)
library(ggplot2)
library(tidyverse)
library(Cairo)
library(ggfortify)

rdrBase <- read.csv(file = './dane/rdr2/base.csv',sep = ';')
rdrDLSSQuality <- read.csv(file = './dane/rdr2/dlss-jakosc.csv',sep = ';')
rdrDLSSBalance <- read.csv(file = './dane/rdr2/dlss-balans.csv',sep = ';')
rdrDLSSPerformance <- read.csv(file = './dane/rdr2/dlss-wydajnosc.csv',sep = ';')
rdrFSRQuality <- read.csv(file = './dane/rdr2/fsr-jakosc.csv',sep = ';')
rdrFSRBalance <- read.csv(file = './dane/rdr2/fsr-balans.csv',sep = ';')
rdrFSRPerformance <- read.csv(file = './dane/rdr2/fsr-wydajnosc.csv',sep = ';')

rdrBase <- tibble::rowid_to_column(rdrBase, "Second")
rdrDLSSQuality <- tibble::rowid_to_column(rdrDLSSQuality, "Second")
rdrDLSSBalance <- tibble::rowid_to_column(rdrDLSSBalance, "Second")
rdrDLSSPerformance <- tibble::rowid_to_column(rdrDLSSPerformance, "Second")
rdrFSRQuality <- tibble::rowid_to_column(rdrFSRQuality, "Second")
rdrFSRBalance <- tibble::rowid_to_column(rdrFSRBalance, "Second")
rdrFSRPerformance <- tibble::rowid_to_column(rdrFSRPerformance, "Second")

rdrBase$Dataset <- "Bazowy"
rdrDLSSQuality$Dataset <- "DLSS Jakość"
rdrDLSSBalance$Dataset <- "DLSS Balans"
rdrDLSSPerformance$Dataset <- "DLSS Wydajność"
rdrFSRQuality$Dataset <- "FSR Jakość"
rdrFSRBalance$Dataset <- "FSR Balans"
rdrFSRPerformance$Dataset <- "FSR Wydajność"

combined_data <- rbind(rdrBase, rdrDLSSQuality, rdrDLSSBalance, rdrDLSSPerformance,
                       rdrFSRQuality, rdrFSRBalance, rdrFSRPerformance)

write.table(combined_data, file = "rdr-combined-data.csv", row.names = FALSE, dec = ".", sep = ";", quote = FALSE)

g <- ggplot(data = combined_data, aes(x = Second, y = Framerate, color = Dataset)) +
  geom_line(linewidth = 0.2) +
  labs(title = "Porównanie liczby klatek na sekundę - Red Dead Redemption 2",
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
  scale_x_continuous(breaks = seq(0, 250, 25)) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 8),
        plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        legend.position="bottom")

ggsave(g, filename = './eksporty/FPS/rdr.png', dpi = 300, type = 'cairo',
       width = 8, height = 4, units = 'in', bg = 'white')



ccf_result <- ccf(rdrDLSSQuality$Framerate, rdrFSRQuality$Framerate, plot = FALSE)
p <- autoplot(ccf_result, 
              main = "Korelacja krzyżowa pomiędzy DLSS Jakość a FSR Jakość",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/rdr_dlss_quality_fsr_quality.png', p, width = 10, height = 6, dpi = 300)

# Korelacja krzyżowa dla DLSS Jakość i FSR Wydajność
ccf_result <- ccf(rdrDLSSQuality$Framerate, rdrFSRPerformance$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy DLSS Jakość a FSR Wydajność",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/rdr_dlss_quality_fsr_performance.png', p, width = 10, height = 6, dpi = 300)

# Korelacja krzyżowa dla DLSS Jakość i FSR Balans
ccf_result <- ccf(rdrDLSSQuality$Framerate, rdrFSRBalance$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy DLSS Jakość a FSR Balans",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/rdr_dlss_quality_fsr_balance.png', p, width = 10, height = 6, dpi = 300)

# Korelacja krzyżowa dla DLSS Jakość i Bazowy
ccf_result <- ccf(rdrDLSSQuality$Framerate, rdrBase$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy DLSS Jakość a Bazowy",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/rdr_dlss_quality_base.png', p, width = 10, height = 6, dpi = 300)

# Korelacja krzyżowa dla DLSS Jakość i DLSS Wydajność
ccf_result <- ccf(rdrDLSSQuality$Framerate, rdrDLSSPerformance$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy DLSS Jakość a DLSS Wydajność",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/rdr_dlss_quality_dlss_performance.png', p, width = 10, height = 6, dpi = 300)

# Korelacja krzyżowa dla DLSS Jakość i DLSS Balans
ccf_result <- ccf(rdrDLSSQuality$Framerate, rdrDLSSBalance$Framerate, plot = FALSE)
p <- autoplot(ccf_result,
              main = "Korelacja krzyżowa pomiędzy DLSS Jakość a DLSS Balans",
              ylab = "Korelacja krzyżowa",
              xlab = "Opóźnienie")
ggsave('./eksporty/ccf/rdr_dlss_quality_dlss_balance.png', p, width = 10, height = 6, dpi = 300)

