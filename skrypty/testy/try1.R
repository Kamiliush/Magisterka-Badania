fps_data <- data.frame(
  fps_base =         read.csv(file = './dane/cyberpunk/bazowy.csv', sep = ';')$Framerate,
  fps_dlss_quality = read.csv(file = './dane/cyberpunk/dlss-jakosc.csv', sep = ';')$Framerate,
  fps_dlss_balance = read.csv(file = './dane/cyberpunk/dlss-balans.csv', sep = ';')$Framerate,
  fps_dlss_performance = read.csv(file = './dane/cyberpunk/dlss-wydajnosc.csv', sep = ';')$Framerate,
  fps_fsr_quality = read.csv(file = './dane/cyberpunk/fsr-jakosc.csv', sep = ';')$Framerate,
  fps_fsr_balance = read.csv(file = './dane/cyberpunk/fsr-balans.csv', sep = ';')$Framerate,
  fps_fsr_performance = read.csv(file = './dane/cyberpunk/fsr-wydajnosc.csv', sep = ';')$Framerate
)

# Wykonanie testu dla każdej pary prób
test_results <- data.frame(matrix(nrow = ncol(fps_data)-1, ncol = 2))
for(i in 2:ncol(fps_data)){
  test_result <- wilcox.test(fps_data$fps_base, fps_data[,i],  paired = TRUE, alternative = "less" )
  test_results[i-1,1] <- names(fps_data)[i]
  test_results[i-1,2] <- test_result$p.value
}

# Dodanie nazw prób do wyników testu
colnames(test_results) <- c("Proba", "P-value")

# Wyświetlenie wyników testu
test_results


colnames(fps_data) <- c(
  "Base",
  "DLSS Quality",
  "DLSS Balance",
  "DLSS Performance",
  "FSR Quality",
  "FSR Balance",
  "FSR Performance"
)

write.csv(test_results, "cyberpunk_test_results_table.csv", row.names = FALSE)















# Nowa ramka danych dla wyników porównania FSR i DLSS
comparison_results <- data.frame(matrix(nrow = 3, ncol = 2))

# Testy Wilcoxona dla par prób FSR i DLSS
for (i in seq(2, 6, by = 2)) {
  fsr_sample <- fps_data[, i + 1]
  dlss_sample <- fps_data[, i]
  
  test_result <- wilcox.test(fsr_sample, dlss_sample, paired = TRUE, alternative = "two.sided")
  comparison_results[(i / 2), 1] <- paste(names(fps_data)[i + 1], "vs", names(fps_data)[i])
  
  if (test_result$p.value < 0.05) {
    if (mean(fsr_sample) > mean(dlss_sample)) {
      comparison_results[(i / 2), 2] <- "FSR ma większy przebieg"
    } else {
      comparison_results[(i / 2), 2] <- "DLSS ma większy przebieg"
    }
  } else {
    comparison_results[(i / 2), 2] <- "Brak istotnych różnic"
  }
}

# Dodanie nazw prób do wyników porównania
colnames(comparison_results) <- c("Porównanie", "Wynik")

# Wyświetlenie wyników porównania
comparison_results