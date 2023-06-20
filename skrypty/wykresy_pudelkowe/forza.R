source(file = "./skrypty/wykresy_pudelkowe/funkcja.R")

fps_data <- data.frame(
  Bazowy = read.csv(file = './dane/forza/bazowy.csv', sep = ';')$Framerate,
  DLSS_Jakość = read.csv(file = './dane/forza/dlss-jakosc.csv', sep = ';')$Framerate,
  DLSS_Balans = read.csv(file = './dane/forza/dlss-balans.csv', sep = ';')$Framerate,
  DLSS_Wydajność = read.csv(file = './dane/forza/dlss-wydajnosc.csv', sep = ';')$Framerate,
  FSR_Jakość = read.csv(file = './dane/forza/fsr-jakosc.csv', sep = ';')$Framerate,
  FSR_Balans = read.csv(file = './dane/forza/fsr-balans.csv', sep = ';')$Framerate,
  FSR_Wydajność = read.csv(file = './dane/forza/fsr-wydajnosc.csv', sep = ';')$Framerate
)

plot = create_fps_plot(fps_data, "Rozkłady klatek na sekundę dla gry Forza Horizon 5")
ggsave("./eksporty/wykresy_pudelkowe/forza_pudelkowy.png", plot)