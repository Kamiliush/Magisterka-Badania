library(dplyr)
library(tidyverse)
library(corrplot)

fps_data <- data.frame(
  Base = read.csv(file = './dane/cyberpunk/bazowy.csv', sep = ';')$Framerate,
  DLSS_Quality = read.csv(file = './dane/cyberpunk/dlss-jakosc.csv', sep = ';')$Framerate,
  DLSS_Balance = read.csv(file = './dane/cyberpunk/dlss-balans.csv', sep = ';')$Framerate,
  DLSS_Performance = read.csv(file = './dane/cyberpunk/dlss-wydajnosc.csv', sep = ';')$Framerate,
  FSR_Quality = read.csv(file = './dane/cyberpunk/fsr-jakosc.csv', sep = ';')$Framerate,
  FSR_Balance = read.csv(file = './dane/cyberpunk/fsr-balans.csv', sep = ';')$Framerate,
  FSR_Performance = read.csv(file = './dane/cyberpunk/fsr-wydajnosc.csv', sep = ';')$Framerate
)

# Przekształcenie danych do długiego formatu
fps_data_long <- fps_data %>% 
  mutate(id = 1:n()) %>%
  gather(key = "Technology", value = "Framerate", -id) %>%
  group_by(Technology) %>%
  mutate(Median = median(Framerate),
         Mean = mean(Framerate))

# Tworzenie wykresu
ggplot(fps_data_long, aes(x = Technology, y = Framerate, fill = Technology)) +
  geom_boxplot() +
  geom_point(aes(y = Median, color = "Median"), size = 4, shape = 18, show.legend = TRUE) +
  geom_point(aes(y = Mean, color = "Mean"), size = 4, shape = 3, show.legend = TRUE) +
  scale_color_manual(values = c("Median" = "red", "Mean" = "blue"), name = "Stats: ") +
  labs(x = "Upscaling technology", y = "Framerate (FPS)", title = "Averages and Distributions\nof Frame Rates for Different Technologies") +
  theme_bw() +
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        plot.title = element_text(hjust = 0.5)) +
  scale_x_discrete(labels = c("Base" = "Base",
                              "DLSS_Quality" = "DLSS Quality",
                              "FSR_Quality" = "FSR Quality",
                              "DLSS_Balance" = "DLSS Balance",
                              "FSR_Balance" = "FSR Balance",
                              "DLSS_Performance" = "DLSS Performance",
                              "FSR_Performance" = "FSR Performance"),
                   limits = c("Base", "DLSS_Quality", "FSR_Quality", "DLSS_Balance", "FSR_Balance", "DLSS_Performance", "FSR_Performance"))
