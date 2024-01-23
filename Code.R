# Read the CSV file
df <- read.csv("3CDD.csv", header = TRUE)

# Load necessary libraries
library(dplyr)
library(tidyr)
library(plotly)
library(ggplot2)
library(gganimate)

# Convert 'Month' to Date type
df$Month <- as.Date(df$Month, format = "%d-%b")

# Convert data to long format
df_long <- df %>%
  pivot_longer(cols = -Month, names_to = "Temperature_Type", values_to = "Temperature")

# Create dynamic temperature line chart
temperature_line_chart <- plot_ly(df_long, x = ~Month, y = ~Temperature, color = ~Temperature_Type,
                                   type = 'scatter', mode = 'lines+markers') %>%
  layout(title = 'Dynamic Temperature Line Chart',
         xaxis = list(title = 'Month'),
         yaxis = list(title = 'Temperature'))

# Display the plot
temperature_line_chart

# Create the animated racing plot
animated_racing_plot <- ggplot(df_long, aes(x = Month, y = Temperature, fill = Temperature_Type)) +
  geom_bar(stat = "identity", width = 0.3) +
  labs(title = 'Animated Racing Bar Plot temperature datas',
       x = 'Month',
       y = 'Temperature') + 
  transition_states(Temperature_Type, transition_length = 100, state_length = 60) +
  enter_fade() +
  exit_fade() +
  shadow_mark() +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Rotate x-axis text by 90 degrees

# Set the filename for the animated GIF
output_file <- "animated_racing_plot.gif"

# Save the animated plot as a GIF
anim_save(output_file, animate(animated_racing_plot, nframes = length(unique(df_long$Temperature_Type)), fps = 10, width = 1500, height = 500))
