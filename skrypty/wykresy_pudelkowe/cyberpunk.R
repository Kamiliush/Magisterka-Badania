source(file = "./skrypty/wykresy_pudelkowe/funkcja.R")

fps_data <- data.frame(
  Bazowy = read.csv(file = './dane/cyberpunk/bazowy.csv', sep = ';')$Framerate,
  DLSS_Jakość = read.csv(file = './dane/cyberpunk/dlss-jakosc.csv', sep = ';')$Framerate,
  DLSS_Balans = read.csv(file = './dane/cyberpunk/dlss-balans.csv', sep = ';')$Framerate,
  DLSS_Wydajność = read.csv(file = './dane/cyberpunk/dlss-wydajnosc.csv', sep = ';')$Framerate,
  FSR_Jakość = read.csv(file = './dane/cyberpunk/fsr-jakosc.csv', sep = ';')$Framerate,
  FSR_Balans = read.csv(file = './dane/cyberpunk/fsr-balans.csv', sep = ';')$Framerate,
  FSR_Wydajność = read.csv(file = './dane/cyberpunk/fsr-wydajnosc.csv', sep = ';')$Framerate
)

plot = create_fps_plot(fps_data, "Rozkłady klatek na sekundę dla gry Cyberpunk 2077")
ggsave("./eksporty/wykresy_pudelkowe/cp77_pudelkowy.png", plot)