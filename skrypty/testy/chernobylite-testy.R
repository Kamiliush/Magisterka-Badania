fps_data <- data.frame(
  fps_base =         read.csv(file = './dane/chernobylite/bazowy.csv', sep = ';')$Framerate,
  fps_dlss_quality = read.csv(file = './dane/chernobylite/dlss-jakosc.csv', sep = ';')$Framerate,
  fps_dlss_balance = read.csv(file = './dane/chernobylite/dlss-balans.csv', sep = ';')$Framerate,
  fps_dlss_performance = read.csv(file = './dane/chernobylite/dlss-wydajnosc.csv', sep = ';')$Framerate,
  fps_fsr_quality = read.csv(file = './dane/chernobylite/fsr-jakosc.csv', sep = ';')$Framerate,
  fps_fsr_balance = read.csv(file = './dane/chernobylite/fsr-balans.csv', sep = ';')$Framerate,
  fps_fsr_performance = read.csv(file = './dane/chernobylite/fsr-wydajnosc.csv', sep = ';')$Framerate
)

# Wykonanie testu dla każdej pary prób
test_results <- data.frame(matrix(nrow = ncol(fps_data)-1, ncol = 2))
for(i in 2:ncol(fps_data)){
  test_result <- wilcox.test(fps_data$fps_base, fps_data[,i],  paired = TRUE, alternative = "less" )
  test_results[i-1,1] <- names(fps_data)[i]
  test_results[i-1,2] <- test_result$p.value
}

psych::describe(fps_data$fps_base)
psych::describe(fps_data$fps_dlss_quality)
psych::describe(fps_data$fps_fsr_quality)
psych::describe(fps_data$fps_dlss_balance)
psych::describe(fps_data$fps_fsr_balance)
psych::describe(fps_data$fps_dlss_performance)
psych::describe(fps_data$fps_fsr_performance)

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

write.csv(test_results, "chernobylite_test_results_table.csv", row.names = FALSE) 