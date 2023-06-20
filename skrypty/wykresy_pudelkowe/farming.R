source(file = "./skrypty/wykresy_pudelkowe/funkcja.R")

fps_data <- data.frame(
  Bazowy = read.csv(file = './dane/farming-simulator/bazowy.csv', sep = ';')$Framerate,
  DLSS_Jakość = read.csv(file = './dane/farming-simulator/dlss-jakosc.csv', sep = ';')$Framerate,
  DLSS_Balans = read.csv(file = './dane/farming-simulator/dlss-balans.csv', sep = ';')$Framerate,
  DLSS_Wydajność = read.csv(file = './dane/farming-simulator/dlss-wydajnosc.csv', sep = ';')$Framerate,
  FSR_Jakość = read.csv(file = './dane/farming-simulator/fsr-jakosc.csv', sep = ';')$Framerate,
  FSR_Balans = read.csv(file = './dane/farming-simulator/fsr-balans.csv', sep = ';')$Framerate,
  FSR_Wydajność = read.csv(file = './dane/farming-simulator/fsr-wydajnosc.csv', sep = ';')$Framerate
)


plot = create_fps_plot(fps_data, "Rozkłady klatek na sekundę dla gry Farming Simulator 22")
ggsave("./eksporty/wykresy_pudelkowe/fs22_pudelkowy.png", plot)
