library(dplyr)
library(tidyverse)
library(corrplot)

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
  mutate(across(starts_with("fps"), list(diff = ~ c(NA, diff(.))))) %>% # Przetworzenie kolumn fps_data na kolumnę diff zawierającą różnice
  select(contains("diff")) # select wybiera tylko kolumny zawierajace "diff"

fps_data_diff_tidy <- fps_data_diff %>% 
  mutate(id = row_number()) %>% 
  pivot_longer(cols = -id, names_to = "setting", values_to = "fps_diff") # dodanie kolumny id
# Spłaszczenie ramki danych do 3 kolumn, id, setting i fps diff



# Wizualizacja skoków FPS
new_legend_labels <- c(
  "Base FPS",
  "DLSS Quality",
  "DLSS Balance",
  "DLSS Performance",
  "FSR Quality",
  "FSR Balance",
  "FSR Performance"
) # wektor legendy

ggplot(fps_data_diff_tidy, aes(x = id, y = fps_diff, color = setting)) +
  geom_line() +
  theme_minimal() +
  labs(title = "Frame Rate Variability Plot (Cyberpunk)", x = "Time", y = "Variability", color = "Settings") +
  scale_color_discrete(labels = new_legend_labels) +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_continuous(breaks = seq(0, 80, by = 1), 
                     labels = ifelse(seq(0, 80, by = 1) %% 10 == 0, seq(0, 80, by = 1), ""),
                     limits = c(0, 80)) +
  scale_y_continuous(breaks = seq(floor(min(fps_data_diff_tidy$fps_diff, na.rm = TRUE)), ceiling(max(fps_data_diff_tidy$fps_diff, na.rm = TRUE)), by = 1),
                     labels = ifelse(seq(floor(min(fps_data_diff_tidy$fps_diff, na.rm = TRUE)), ceiling(max(fps_data_diff_tidy$fps_diff, na.rm = TRUE)), by = 1) %% 10 == 0, seq(floor(min(fps_data_diff_tidy$fps_diff, na.rm = TRUE)), ceiling(max(fps_data_diff_tidy$fps_diff, na.rm = TRUE)), by = 1), ""))


fps_data_diff_selected <- fps_data_diff[, c("fps_base_diff", "fps_dlss_quality_diff", "fps_dlss_balance_diff", "fps_dlss_performance_diff", "fps_fsr_quality_diff", "fps_fsr_balance_diff", "fps_fsr_performance_diff")]

correlation_matrix <- cor(fps_data_diff_selected, use = "pairwise.complete.obs")
# wyliczenie macierzy korelacji, wykluczenie brakujacych danych (nie występują)

print(correlation_matrix) 


corrplot(correlation_matrix, method = "circle")