library(dplyr)
library(tidyverse)
library(corrplot)

create_fps_plot <- function(fps_data, plot_title) {
  # Przekształcenie danych do długiego formatu
  fps_data_long <- fps_data %>% 
    mutate(id = 1:n()) %>%
    gather(key = "Technologia", value = "Framerate", -id) %>%
    group_by(Technologia) %>%
    mutate(Mediana = median(Framerate),
           Średnia = mean(Framerate))
  
  fps_data_long$Technologia <- gsub("_", " ", fps_data_long$Technologia)
  
  # Tworzenie wykresu
  ggplot(fps_data_long, aes(x = Technologia, y = Framerate, fill = Technologia)) +
    geom_boxplot(show.legend = FALSE) +
    geom_point(aes(y = Mediana, color = "Mediana"), size = 4, shape = 18, show.legend = TRUE) +
    geom_point(aes(y = Średnia, color = "Średnia"), size = 4, shape = 3, show.legend = TRUE) +
    scale_color_manual(values = c("Mediana" = "red", "Średnia" = "blue"), name = "") +
    labs(x = "", y = "Klatki na sekundę (FPS)", title = plot_title) + 
    theme_bw() +
    theme(
      legend.position = "bottom",
      axis.text.x = element_text(angle = 0, vjust = 0.5, hjust = 0.5, size = 16), 
      axis.text.y = element_text(size = 16),
      axis.title.y = element_text(size = 16),
      legend.text = element_text(size = 16),
      plot.title = element_text(hjust = 0.5, size = 16)
    ) +
    scale_x_discrete(
      labels = c(
        "Bazowy" = "Bazowy",
        "DLSS Jakość" = "DLSS\n Jakość",
        "FSR Jakość" = "FSR\n Jakość",
        "DLSS Balans" = "DLSS\n Balans",
        "FSR Balans" = "FSR\n Balans",
        "DLSS Wydajność" = "DLSS\n Wydajność",
        "FSR Wydajność" = "FSR\n Wydajność"
      ),
      limits = c(
        "Bazowy", 
        "DLSS Jakość", 
        "FSR Jakość", 
        "DLSS Balans", 
        "FSR Balans", 
        "DLSS Wydajność", 
        "FSR Wydajność"
      )
    ) + 
    scale_fill_manual(
      values = c(
        "Bazowy" = "darkgoldenrod1",
        "DLSS Jakość" = "chartreuse",
        "DLSS Balans" = "deepskyblue",
        "DLSS Wydajność" = "darkorchid1",
        "FSR Jakość" = "chartreuse4",
        "FSR Balans" = "deepskyblue4",
        "FSR Wydajność" = "darkorchid4"
      )
    ) +
    guides(fill=FALSE, color=guide_legend(override.aes = list(fill = NA)))
}