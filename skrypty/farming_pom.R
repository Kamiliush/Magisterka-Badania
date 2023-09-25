library(dplyr)
library(ggplot2)
library(gridExtra)
library(tibble)

# Lista nazw plików
file_names <- c("bazowy.csv", "dlss-balans.csv", "dlss-jakosc.csv", "dlss-wydajnosc.csv", "fsr-balans.csv", "fsr-jakosc.csv", "fsr-wydajnosc.csv")

# Wczytanie plików i znalezienie najkrótszego
min_rows <- Inf
data_list <- list()

for (file in file_names) {
  temp_data <- read.csv(file = paste0('./dane/farming-simulator/1/pom/', file), sep = ';')
  data_list[[file]] <- temp_data
  if (nrow(temp_data) < min_rows) {
    min_rows <- nrow(temp_data)
  }
}

# Przycięcie plików do najkrótszej długości i dodanie kolumny Dataset
for (file in file_names) {
  data_list[[file]] <- data_list[[file]][1:min_rows, ]
  data_list[[file]]$Dataset <- gsub(".csv", "", file)
  data_list[[file]] <- tibble::rowid_to_column(data_list[[file]], "Second")
}

# Połączenie wszystkich ramek danych
combined_data <- do.call(rbind, data_list)

# Tworzenie wykresu
g <- ggplot(data = combined_data, aes(x = Second, y = Framerate, color = Dataset)) +
  geom_line(linewidth = 0.2) +
  labs(title = "Porównanie przebiegów liczby klatek na sekundę - Farming Simulator 22",
       x = "Czas (s)",
       y = "Klatki na sekundę (FPS)") +
  theme_minimal() +
  scale_color_manual(values = c("bazowy" = "blue", 
                                "dlss-jakosc" = "red", 
                                "dlss-balans" = "green", 
                                "dlss-wydajnosc" = "purple",
                                "fsr-jakosc" = "orange",
                                "fsr-balans" = "cyan",
                                "fsr-wydajnosc" = "yellow")) +
  scale_x_continuous(breaks = seq(0, min_rows, 25)) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 12),
        plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        legend.position="bottom") 

# Zapisanie wykresu
ggsave(g, filename = './eksporty/FPS/farming_combined_pom.png', dpi = 300,
       width = 8, height = 4, units = 'in', bg = 'white')