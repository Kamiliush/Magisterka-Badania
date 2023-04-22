library(dplyr)
library(ggplot2)
library(tidyverse)

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



rdrBase$Dataset <- "Base"
rdrDLSSQuality$Dataset <- "DLSS Quality"
rdrDLSSBalance$Dataset <- "DLSS Balance"
rdrDLSSPerformance$Dataset <- "DLSS Performance"
rdrFSRQuality$Dataset <- "FSR Quality"
rdrFSRBalance$Dataset <- "FSR Balance"
rdrFSRPerformance$Dataset <- "FSR Performance"

combined_data <- rbind(rdrBase, rdrDLSSQuality, rdrDLSSBalance, rdrDLSSPerformance,
                       rdrFSRQuality, rdrFSRBalance, rdrFSRPerformance)

# write.csv(combined_data, file = "combined_data.csv", row.names = FALSE, sep = ';')
write.table(combined_data, file = "rdr-combined-data.csv", row.names = FALSE, dec = ".", sep = ";", quote = FALSE)

ggplot(data = combined_data, aes(x = Second, y = Framerate, color = Dataset)) +
  geom_line(linewidth = 0.8) +
  labs(title = "Framerate Comparison - Red Redemption 2",
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


