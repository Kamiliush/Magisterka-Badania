source(file = "./skrypty/wykresy_pudelkowe/funkcja.R")

fps_data <- data.frame(
  Bazowy = read.csv(file = './dane/chernobylite/bazowy.csv', sep = ';')$Framerate,
  DLSS_Jakość = read.csv(file = './dane/chernobylite/dlss-jakosc.csv', sep = ';')$Framerate,
  DLSS_Balans = read.csv(file = './dane/chernobylite/dlss-balans.csv', sep = ';')$Framerate,
  DLSS_Wydajność = read.csv(file = './dane/chernobylite/dlss-wydajnosc.csv', sep = ';')$Framerate,
  FSR_Jakość = read.csv(file = './dane/chernobylite/fsr-jakosc.csv', sep = ';')$Framerate,
  FSR_Balans = read.csv(file = './dane/chernobylite/fsr-balans.csv', sep = ';')$Framerate,
  FSR_Wydajność = read.csv(file = './dane/chernobylite/fsr-wydajnosc.csv', sep = ';')$Framerate
)

plot = create_fps_plot(fps_data, "Rozkłady klatek na sekundę dla gry Chernobylite")
ggsave("./eksporty/wykresy_pudelkowe/chernobylite_pudelkowy.png", plot)