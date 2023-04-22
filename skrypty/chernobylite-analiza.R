library(dplyr)
library(ggplot2)
library(tidyverse)

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



chernobyliteBase$Dataset <- "Base"
chernobyliteDLSSQuality$Dataset <- "DLSS Quality"
chernobyliteDLSSBalance$Dataset <- "DLSS Balance"
chernobyliteDLSSPerformance$Dataset <- "DLSS Performance"
chernobyliteFSRQuality$Dataset <- "FSR Quality"
chernobyliteFSRBalance$Dataset <- "FSR Balance"
chernobyliteFSRPerformance$Dataset <- "FSR Performance"

combined_data <- rbind(chernobyliteBase, chernobyliteDLSSQuality, chernobyliteDLSSBalance, chernobyliteDLSSPerformance,
                       chernobyliteFSRQuality, chernobyliteFSRBalance, chernobyliteFSRPerformance)

# write.csv(combined_data, file = "combined_data.csv", row.names = FALSE, sep = ';')
write.table(combined_data, file = "chernobylite-combined-data.csv", row.names = FALSE, dec = ".", sep = ";", quote = FALSE)

ggplot(data = combined_data, aes(x = Second, y = Framerate, color = Dataset)) +
  geom_line(linewidth = 0.8) +
  labs(title = "Framerate Comparison - Chernobylite",
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



