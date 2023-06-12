library(dplyr)
library(ggplot2)
library(tidyverse)
library(Cairo)
CairoWin()

chernobyliteBase <- read.csv(file = './dane/chernobylite/bazowy.csv',sep = ';')
chernobyliteDLSSQuality <- read.csv(file = './dane/chernobylite/dlss-jakosc.csv',sep = ';')
chernobyliteDLSSBalance <- read.csv(file = './dane/chernobylite/dlss-balans.csv',sep = ';')
chernobyliteDLSSPerformance <- read.csv(file = './dane/chernobylite/dlss-wydajnosc.csv',sep = ';')
chernobyliteFSRQuality <- read.csv(file = './dane/chernobylite/fsr-jakosc.csv',sep = ';')
chernobyliteFSRBalance <- read.csv(file = './dane/chernobylite/fsr-balans.csv',sep = ';')
chernobyliteFSRPerformance <- read.csv(file = './dane/chernobylite/fsr-wydajnosc.csv',sep = ';')

"Datetime GPU.temperature GPU.usage FB.usage Memory.usage Core.clock Power 
CPU.temperature CPU.usage CPU.clock RAM.usage Framerate Frametime Framerate.Avg"

chernobyliteBase <- tibble::rowid_to_column(chernobyliteBase, "Second")
chernobyliteDLSSQuality <- tibble::rowid_to_column(chernobyliteDLSSQuality, "Second")
chernobyliteDLSSBalance <- tibble::rowid_to_column(chernobyliteDLSSBalance, "Second")
chernobyliteDLSSPerformance <- tibble::rowid_to_column(chernobyliteDLSSPerformance, "Second")
chernobyliteFSRQuality <- tibble::rowid_to_column(chernobyliteFSRQuality, "Second")
chernobyliteFSRBalance <- tibble::rowid_to_column(chernobyliteFSRBalance, "Second")
chernobyliteFSRPerformance <- tibble::rowid_to_column(chernobyliteFSRPerformance, "Second")



chernobyliteBase$Dataset <- "Bazowy"
chernobyliteDLSSQuality$Dataset <- "DLSS Jakość"
chernobyliteDLSSBalance$Dataset <- "DLSS Balans"
chernobyliteDLSSPerformance$Dataset <- "DLSS Wydajność"
chernobyliteFSRQuality$Dataset <- "FSR Jakość"
chernobyliteFSRBalance$Dataset <- "FSR Balans"
chernobyliteFSRPerformance$Dataset <- "FSR Wydajność"

combined_data <- rbind(chernobyliteBase, chernobyliteDLSSQuality, chernobyliteDLSSBalance, chernobyliteDLSSPerformance,
                       chernobyliteFSRQuality, chernobyliteFSRBalance, chernobyliteFSRPerformance)

# write.csv(combined_data, file = "combined_data.csv", row.names = FALSE, sep = ';')
write.table(combined_data, file = "chernobylite-combined-data.csv", row.names = FALSE, dec = ".", sep = ";", quote = FALSE)

g <- ggplot(data = combined_data, aes(x = Second, y = Framerate, color = Dataset)) +
  geom_line(linewidth = 0.2) +
  labs(title = "Porównanie liczby klatek na sekundę - Chernobylite",
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
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 11),
        plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        )

ggsave(g, filename = 'nhtemp_with_cairo.png', dpi = 300, type = 'cairo',
       width = 8, height = 4, units = 'in', bg = 'white')

ccf_result <- ccf(chernobyliteBase$Framerate, chernobyliteFSRQuality$Framerate) #-1
ccf_result <- ccf(chernobyliteBase$Framerate, chernobyliteFSRPerformance$Framerate) #-2 
ccf_result <- ccf(chernobyliteBase$Framerate, chernobyliteFSRBalance$Framerate) #-1
ccf_result <- ccf(chernobyliteBase$Framerate, chernobyliteDLSSQuality$Framerate) #-2
ccf_result <- ccf(chernobyliteBase$Framerate, chernobyliteDLSSPerformance$Framerate) #-1
ccf_result <- ccf(chernobyliteBase$Framerate, chernobyliteDLSSBalance$Framerate) #-1


