library(dplyr)
library(tidyverse)

fps_data <- data.frame(
  fps_base = read.csv(file = './dane/cyberpunk/bazowy.csv', sep = ';')$Framerate,
  fps_dlss_quality = read.csv(file = './dane/cyberpunk/dlss-jakosc.csv', sep = ';')$Framerate,
  fps_dlss_balance = read.csv(file = './dane/cyberpunk/dlss-balans.csv', sep = ';')$Framerate,
  fps_dlss_performance = read.csv(file = './dane/cyberpunk/dlss-wydajnosc.csv', sep = ';')$Framerate,
  fps_fsr_quality = read.csv(file = './dane/cyberpunk/fsr-jakosc.csv', sep = ';')$Framerate,
  fps_fsr_balance = read.csv(file = './dane/cyberpunk/fsr-balans.csv', sep = ';')$Framerate,
  fps_fsr_performance = read.csv(file = './dane/cyberpunk/fsr-wydajnosc.csv', sep = ';')$Framerate
)

# Analiza skoków FPS
fps_data_diff <- fps_data %>%
  mutate(across(starts_with("fps"), list(diff = ~ c(NA, diff(.))))) %>%
  select(contains("diff"))

fps_data_diff_tidy <- fps_data_diff %>% 
  mutate(id = row_number()) %>% 
  pivot_longer(cols = -id, names_to = "setting", values_to = "fps_diff")

# Wizualizacja skoków FPS
new_legend_labels <- c(
  "Base FPS",
  "DLSS Quality",
  "DLSS Balance",
  "DLSS Performance",
  "FSR Quality",
  "FSR Balance",
  "FSR Performance"
)

ggplot(fps_data_diff_tidy, aes(x = id, y = fps_diff, color = setting)) +
  geom_line() +
  theme_minimal() +
  labs(title = "Frame Rate Variability Plot (Chernobylite)", x = "Time", y = "Variability", color = "Settings") +
  scale_color_discrete(labels = new_legend_labels) +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_continuous(breaks = seq(0, 80, by = 1), 
                     labels = ifelse(seq(0, 80, by = 1) %% 10 == 0, seq(0, 80, by = 1), ""),
                     limits = c(0, 80)) +
  scale_y_continuous(breaks = seq(floor(min(fps_data_diff_tidy$fps_diff, na.rm = TRUE)), ceiling(max(fps_data_diff_tidy$fps_diff, na.rm = TRUE)), by = 1),
                     labels = ifelse(seq(floor(min(fps_data_diff_tidy$fps_diff, na.rm = TRUE)), ceiling(max(fps_data_diff_tidy$fps_diff, na.rm = TRUE)), by = 1) %% 10 == 0, seq(floor(min(fps_data_diff_tidy$fps_diff, na.rm = TRUE)), ceiling(max(fps_data_diff_tidy$fps_diff, na.rm = TRUE)), by = 1), ""))






fps_data_diff_selected <- fps_data_diff[, c("fps_base_diff", "fps_dlss_quality_diff", "fps_dlss_balance_diff", "fps_dlss_performance_diff", "fps_fsr_quality_diff", "fps_fsr_balance_diff", "fps_fsr_performance_diff")]

correlation_matrix <- cor(fps_data_diff_selected, use = "pairwise.complete.obs")
print(correlation_matrix)

library(corrplot)

corrplot(correlation_matrix, method = "circle")







 

# Liczenie spadków poniżej określonego progu (np. 30 FPS)
fps_threshold <- 30
fps_below_threshold <- only_fps %>%
  group_by(setting) %>%
  summarise(
    below_threshold = sum(fps < fps_threshold),
    total_samples = n(),
    percent_below_threshold = (below_threshold / total_samples) * 100
  )

print(fps_below_threshold)












# Funkcja do obliczania 1% low FPS
fps_base_1_percent_low <- min(fps_data$fps_base[fps_data$fps_base >= quantile(fps_data$fps_base, 0.01)])
fps_dlss_quality_1_percent_low <- min(fps_data$fps_dlss_quality[fps_data$fps_dlss_quality >= quantile(fps_data$fps_dlss_quality, 0.01)])
fps_dlss_balance_1_percent_low <- min(fps_data$fps_dlss_balance[fps_data$fps_dlss_balance >= quantile(fps_data$fps_dlss_balance, 0.01)])
fps_dlss_performance_1_percent_low <- min(fps_data$fps_dlss_performance[fps_data$fps_dlss_performance >= quantile(fps_data$fps_dlss_performance, 0.01)])
fps_fsr_quality_1_percent_low <- min(fps_data$fps_fsr_quality[fps_data$fps_fsr_quality >= quantile(fps_data$fps_fsr_quality, 0.01)])
fps_fsr_balance_1_percent_low <- min(fps_data$fps_fsr_balance[fps_data$fps_fsr_balance >= quantile(fps_data$fps_fsr_balance, 0.01)])
fps_fsr_performance_1_percent_low <- min(fps_data$fps_fsr_performance[fps_data$fps_fsr_performance >= quantile(fps_data$fps_fsr_performance, 0.01)])

# Stwórz ramkę danych z wynikami
fps_data_1_percent_low <- data.frame(
  fps_base_1_percent_low,
  fps_dlss_quality_1_percent_low,
  fps_dlss_balance_1_percent_low,
  fps_dlss_performance_1_percent_low,
  fps_fsr_quality_1_percent_low,
  fps_fsr_balance_1_percent_low,
  fps_fsr_performance_1_percent_low
)

# Wyświetl wyniki dla każdej kolumny osobno
print(fps_data_1_percent_low)

only_fps <- fps_data %>%
  mutate(id = row_number()) %>% 
  gather(key = "setting", value = "fps", -id)

# Statystyki opisowe
statystyki <- only_fps %>%
  group_by(setting) %>%
  summarise(
    mean_fps = mean(fps),
    median_fps = median(fps),
    sd_fps = sd(fps),
    iqr_fps = IQR(fps),
    min_fps = min(fps),
    max_fps = max(fps),
    range_fps = max(fps) - min(fps),
    cv_fps = (sd(fps) / mean(fps)) * 100
  )

print(statystyki)




