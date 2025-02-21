library(rmarkdown)
library(ggplot2)
library(dplyr)
library(lubridate)
library(readr)

# TX2, LA4, FL3, MA1, NH1,
sites <- c("TX2", "LA4", "FL3", "MA1", "NH1")  # sites

all_data <- list()

# Loop through each site and render its .Rmd file
for (site in sites) {
  rmd_file <- paste0("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/", site, "-EnvrData.Rmd")  # path from /data folder
  output_file <- paste0("output/", site, "_summary.csv")  # Output file
  # make .Rmd
  rmarkdown::render(rmd_file)
  # Load the output data (assuming the Rmd script outputs a CSV file)
  if (file.exists(output_file)) {
    df <- read_csv(output_file)
    df$Site <- site  # Add site column for identification
    all_data[[site]] <- df
  }
}

# combine into one data frame
combined_data <- bind_rows(all_data)

# Convert date column to date format
combined_data$Date <- as.Date(combined_data$Date)

# Extract year and month for aggregation
combined_data <- combined_data %>%
  mutate(Year = year(Date), Month = month(Date, label = TRUE))

# Plot mean monthly temperature over time
ggplot(combined_data, aes(x = Year, y = Mean_Temperature, color = Site)) +
  geom_line() +
  labs(title = "Mean Monthly Temperature by Site", x = "Year", y = "Temperature (°C)") +
  theme_minimal()

# Plot mean monthly salinity over time
ggplot(combined_data, aes(x = Year, y = Mean_Salinity, color = Site)) +
  geom_line() +
  labs(title = "Mean Monthly Salinity by Site", x = "Year", y = "Salinity (ppt)") +
  theme_minimal()
