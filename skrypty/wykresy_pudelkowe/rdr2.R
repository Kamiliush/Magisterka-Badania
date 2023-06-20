source(file = "./skrypty/wykresy_pudelkowe/funkcja.R")

fps_data <- data.frame(
  Bazowy = read.csv(file = './dane/rdr2/base.csv', sep = ';')$Framerate,
  DLSS_Jakość = read.csv(file = './dane/rdr2/dlss-jakosc.csv', sep = ';')$Framerate,
  DLSS_Balans = read.csv(file = './dane/rdr2/dlss-balans.csv', sep = ';')$Framerate,
  DLSS_Wydajność = read.csv(file = './dane/rdr2/dlss-wydajnosc.csv', sep = ';')$Framerate,
  FSR_Jakość = read.csv(file = './dane/rdr2/fsr-jakosc.csv', sep = ';')$Framerate,
  FSR_Balans = read.csv(file = './dane/rdr2/fsr-balans.csv', sep = ';')$Framerate,
  FSR_Wydajność = read.csv(file = './dane/rdr2/fsr-wydajnosc.csv', sep = ';')$Framerate
)

plot = create_fps_plot(fps_data, "Rozkłady klatek na sekundę dla gry Red Dead Redemption 2")
ggsave("./eksporty/wykresy_pudelkowe/rdr2_pudelkowy.png", plot)