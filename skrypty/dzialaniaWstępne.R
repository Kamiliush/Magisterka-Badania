install.packages("corrplot")
library(corrplot)

#sciezki do zmiany!
daneGry <- read.csv(file = 'C:/Users/Kamil/Desktop/chernobylite-bazowy.csv',sep = ';')
head(daneGry)

chernobyliteBase <- read.csv(file = 'C:/Users/Kamil/Desktop/chernobylite-bazowy.csv',sep = ';')
chernobyliteDLSSQuality <- read.csv(file = 'C:/Users/Kamil/Desktop/chernobylite-bazowy.csv',sep = ';')
chernobyliteDLSSBalance <- read.csv(file = 'C:/Users/Kamil/Desktop/chernobylite-bazowy.csv',sep = ';')
chernobyliteDLSSPerformance <- read.csv(file = 'C:/Users/Kamil/Desktop/chernobylite-bazowy.csv',sep = ';')
chernobyliteFSRQuality <- read.csv(file = 'C:/Users/Kamil/Desktop/chernobylite-bazowy.csv',sep = ';')
chernobyliteFSRBalance <- read.csv(file = 'C:/Users/Kamil/Desktop/chernobylite-bazowy.csv',sep = ';')
chernobyliteFSRPerformance <- read.csv(file = 'C:/Users/Kamil/Desktop/chernobylite-bazowy.csv',sep = ';')

daneGry[13]
sum(daneGry[13])/241

shapiro.test(daneGry$Framerate)

t.test(daneGry[13], mu = 30, alternative = "greater")

hist(daneGry$Framerate)

daneWybrane = subset(daneGry, select = c("GPU.temperature", "GPU.usage", "FB.usage", "Memory.usage", "Core.clock", "Memory.clock",
                                         "Power", "CPU.temperature", "CPU.usage", "CPU.clock", "RAM.usage", 
                                         "Framerate", "Frametime", "Framerate.Min", "Framerate.Avg", "Framerate.Max"))

daneWybrane = subset(daneGry, select = c("GPU.temperature", "GPU.usage", "FB.usage", "Memory.usage", "Core.clock",
                                         "Power", "CPU.temperature", "CPU.usage", "CPU.clock", "RAM.usage", 
                                         "Framerate", "Frametime", "Framerate.Avg"))

macierz_korelacji <- cor(daneWybrane, method = "pearson")

corrplot(macierz_korelacji, method = "color")

getwd()

###########
colnames(chernobyliteBase)
# 
# daneWybrane = subset(chernobyliteBase, select = c("GPUtemperature", "GPUusage", "FBusage", "Memoryusage",   
#                                                   "Coreclock", "Power", "CPUtemperature", "CPUusage", "CPUclock", "RAMusage",
#                                                   "Framerate", "Frametime", "FramerateAvg"))
# 
# macierz_korelacji <- cor(daneWybrane, method = "pearson")
# 
# corrplot(macierz_korelacji, method = "color")