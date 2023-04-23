fps_data <- data.frame(
  fps_base = read.csv(file = './dane/rdr2/base.csv', sep = ';', nrows = 100)$Framerate,
  fps_dlss_quality = read.csv(file = './dane/rdr2/dlss-jakosc.csv', sep = ';', nrows = 100)$Framerate,
  fps_dlss_balance = read.csv(file = './dane/rdr2/dlss-balans.csv', sep = ';', nrows = 100)$Framerate,
  fps_dlss_performance = read.csv(file = './dane/rdr2/dlss-wydajnosc.csv', sep = ';', nrows = 100)$Framerate,
  fps_fsr_quality = read.csv(file = './dane/rdr2/fsr-jakosc.csv', sep = ';', nrows = 100)$Framerate,
  fps_fsr_balance = read.csv(file = './dane/rdr2/fsr-balans.csv', sep = ';', nrows = 100)$Framerate,
  fps_fsr_performance = read.csv(file = './dane/rdr2/fsr-wydajnosc.csv', sep = ';', nrows = 100)$Framerate
)

# Wykonanie testu dla każdej pary prób
test_results <- data.frame(matrix(nrow = ncol(fps_data)-1, ncol = 2))
for(i in 2:ncol(fps_data)){
  test_result <- wilcox.test(fps_data$fps_base, fps_data[,i], paired = FALSE, alternative = "less" )
  test_results[i-1,1] <- names(fps_data)[i]
  test_results[i-1,2] <- ifelse(test_result$p.value < 0.05, "Spełnia", "Nie spełnia")
}

# Dodanie nazw prób do wyników testu
colnames(test_results) <- c("Próba", "Spełnienie założeń hipotez")

# Wyświetlenie wyników testu
test_results