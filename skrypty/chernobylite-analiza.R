install.packages("dplyr")
install.packages("ggplot2")
library(dplyr)
library(ggplot2)

chernobyliteBase <- read.csv(file = './dane/chernobylite/bazowy.csv',sep = ';')
chernobyliteDLSSQuality <- read.csv(file = './dane/chernobylite/dlss-jakosc.csv',sep = ';')
chernobyliteDLSSBalance <- read.csv(file = './dane/chernobylite/dlss-balans.csv',sep = ';')
chernobyliteDLSSPerformance <- read.csv(file = './dane/chernobylite/dlss-jakosc.csv',sep = ';')
chernobyliteFSRQuality <- read.csv(file = './dane/chernobylite/fsr-jakosc.csv',sep = ';')
chernobyliteFSRBalance <- read.csv(file = './dane/chernobylite/fsr-balans.csv',sep = ';')
chernobyliteFSRPerformance <- read.csv(file = './dane/chernobylite/fsr-wydajnosc.csv',sep = ';')

"Datetime GPU.temperature GPU.usage FB.usage Memory.usage Core.clock Power 
CPU.temperature CPU.usage CPU.clock RAM.usage Framerate Frametime Framerate.Avg"


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
write.table(combined_data, file = "combined_data.csv", row.names = FALSE, dec = ".", sep = ";", quote = FALSE)

ggplot(data = combined_data, aes(x = Datetime, y = Framerate, color = Dataset)) +
  geom_line() +
  labs(title = "Framerate Comparison",
       x = "Datetime",
       y = "Framerate") +
  theme_minimal() +
  scale_color_manual(values = c("Base" = "blue", 
                                "DLSS Quality" = "red", 
                                "DLSS Balance" = "green", 
                                "DLSS Performance" = "purple",
                                "FSR Quality" = "orange",
                                "FSR Balance" = "brown",
                                "FSR Performance" = "pink")) +
  theme(legend.title = element_blank())



