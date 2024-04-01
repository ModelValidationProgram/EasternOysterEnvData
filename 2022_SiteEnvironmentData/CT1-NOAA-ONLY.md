CT1 - NOAA only Processed Environmental Data
================
Madeline Eppley
4/1/2024

``` r
setwd("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData")
```

### Load required packages.

``` r
library("dplyr") #Used for working with data frames
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library("lubridate") #Used for time-date conversions
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following objects are masked from 'package:base':
    ## 
    ##     date, intersect, setdiff, union

``` r
library("readr") #Used to read the CSV file
library("ggplot2") 
```

### Note the date of data download and source. All available data should be used for each site regardless of year. Note from the CSV file how often the site was sampled, and if there are replicates in the data. Also describe if the sampling occurred at only low tide, only high tide, or continuously.

``` r
#Data was sent on 3/27/2024
#Source - Meghana Parikh and Mariah Kachmar NOAA Affiliates
#The site was sampled continuously

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("03-27-2024")
source_description <- ("NOAA Fisheries, Northeast Fisehries Science Center")
site_name <- ("CT1") #Use site code with site number based on lat position and state
collection_type <- ("continuously")
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from Lower Cedar Point, Maryland. The ID_Site for this site is CT1. 
raw_CT1_sal <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/CT1-raw_sal.csv")
```

    ## Rows: 3147 Columns: 4
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (3): Date Time, Site, variable
    ## dbl (1): mean
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
raw_CT1_temp <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/CT1-raw_temp.csv")
```

    ## Rows: 3147 Columns: 4
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (3): Date Time, Site, variable
    ## dbl (1): mean
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
spec(raw_CT1_sal)
```

    ## cols(
    ##   `Date Time` = col_character(),
    ##   Site = col_character(),
    ##   variable = col_character(),
    ##   mean = col_double()
    ## )

``` r
#View(raw_CT1_sal)

spec(raw_CT1_temp)
```

    ## cols(
    ##   `Date Time` = col_character(),
    ##   Site = col_character(),
    ##   variable = col_character(),
    ##   mean = col_double()
    ## )

``` r
#View(raw_CT1_temp)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_CT1_sal$datetime <- as.POSIXct(raw_CT1_sal$`Date Time`, "%m/%d/%y %H:%M", tz = "")
raw_CT1_temp$datetime <- as.POSIXct(raw_CT1_temp$`Date Time`, "%m/%d/%y %H:%M", tz = "")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
head(raw_CT1_sal)
```

    ## # A tibble: 6 × 5
    ##   `Date Time`   Site  variable  mean datetime           
    ##   <chr>         <chr> <chr>    <dbl> <dttm>             
    ## 1 6/26/23 11:00 ASHC  Salinity  25.3 2023-06-26 11:00:00
    ## 2 6/26/23 14:00 ASHC  Salinity  25.6 2023-06-26 14:00:00
    ## 3 6/26/23 15:00 ASHC  Salinity  25.9 2023-06-26 15:00:00
    ## 4 6/26/23 16:00 ASHC  Salinity  26.3 2023-06-26 16:00:00
    ## 5 6/26/23 17:00 ASHC  Salinity  26.3 2023-06-26 17:00:00
    ## 6 6/26/23 18:00 ASHC  Salinity  26.3 2023-06-26 18:00:00

``` r
head(raw_CT1_temp)
```

    ## # A tibble: 6 × 5
    ##   `Date Time`   Site  variable     mean datetime           
    ##   <chr>         <chr> <chr>       <dbl> <dttm>             
    ## 1 6/26/23 11:00 ASHC  Temperature  23.2 2023-06-26 11:00:00
    ## 2 6/26/23 14:00 ASHC  Temperature  22.7 2023-06-26 14:00:00
    ## 3 6/26/23 15:00 ASHC  Temperature  22.6 2023-06-26 15:00:00
    ## 4 6/26/23 16:00 ASHC  Temperature  22.3 2023-06-26 16:00:00
    ## 5 6/26/23 17:00 ASHC  Temperature  22.3 2023-06-26 17:00:00
    ## 6 6/26/23 18:00 ASHC  Temperature  22.4 2023-06-26 18:00:00

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_CT1_sal <- raw_CT1_sal %>% rename("salinity" = "mean")
raw_CT1_temp <- raw_CT1_temp  %>% rename("temp" = "mean")

#Store variables that we will include in the final data frame
lat <- 41.271986
lon <- -72.586128
firstyear <- 2023
finalyear <- 2023
```

### Filter any of the variables that have data points outside of normal range. We will use 0-40 as the accepted range for salinity (ppt) and temperature (C) values. Note, in the summer, salinity values can sometimes exceed 40. Check to see if there are values above 40. In this case, adjust the range or notify someone that the site has particularly high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
filtered_CT1_sal <- raw_CT1_sal %>%
    filter(between(salinity, 0, 42)) 
           
filtered_CT1_temp <- raw_CT1_temp %>%
    filter(between(temp, 0, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_CT1_sal$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##  0.9168 22.6876 24.9477 23.8138 26.1899 27.7034

``` r
print(summary(filtered_CT1_temp$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   11.12   18.52   22.55   21.53   24.27   29.15

``` r
#Store our data into a variable name with just the site name. 
CT1_temp <- filtered_CT1_temp
CT1_sal <- filtered_CT1_sal
```

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(CT1_sal, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,40) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for CT1 - Fence Creek, CT") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()

salplot
```

![](CT1-NOAA-ONLY_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(CT1_temp, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for CT1 - Fence Creek") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

![](CT1-NOAA-ONLY_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
CT1_envrmonth_sal <- CT1_sal %>%
    mutate(year = year(datetime), month = month(datetime)) %>%
    group_by(year, month) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity),
      length_salinity = length(salinity))
```

    ## `summarise()` has grouped output by 'year'. You can override using the
    ## `.groups` argument.

``` r
CT1_envrmonth_temp <- CT1_temp %>%
    mutate(year = year(datetime), month = month(datetime)) %>%
    group_by(year, month) %>%
    summarise(      
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp),
      length_temp = length(temp))
```

    ## `summarise()` has grouped output by 'year'. You can override using the
    ## `.groups` argument.

``` r
print(CT1_envrmonth_sal)
```

    ## # A tibble: 6 × 6
    ## # Groups:   year [1]
    ##    year month min_salinity max_salinity mean_salinity length_salinity
    ##   <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>
    ## 1  2023     6       21.0           26.4          25.4             107
    ## 2  2023     7        3.03          27.0          23.1             699
    ## 3  2023     8        4.28          27.7          24.9             744
    ## 4  2023     9        0.917         27.7          24.2             720
    ## 5  2023    10        8.93          27.6          23.2             744
    ## 6  2023    11        9.55          23.3          21.4             133

``` r
print(CT1_envrmonth_temp)
```

    ## # A tibble: 6 × 6
    ## # Groups:   year [1]
    ##    year month min_temp max_temp mean_temp length_temp
    ##   <dbl> <dbl>    <dbl>    <dbl>     <dbl>       <int>
    ## 1  2023     6     21.4     26.6      23.1         107
    ## 2  2023     7     20.7     28.9      24.8         699
    ## 3  2023     8     20.5     26.9      23.3         744
    ## 4  2023     9     14.7     29.1      21.9         720
    ## 5  2023    10     13.4     21.9      17.5         744
    ## 6  2023    11     11.1     15.6      13.8         133

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
CT1_envryear_sal <- CT1_sal %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity))

CT1_envryear_temp <- CT1_temp %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(CT1_envryear_sal)
```

    ## # A tibble: 1 × 4
    ##    year min_salinity max_salinity mean_salinity
    ##   <dbl>        <dbl>        <dbl>         <dbl>
    ## 1  2023        0.917         27.7          23.8

``` r
print(CT1_envryear_temp)
```

    ## # A tibble: 1 × 4
    ##    year min_temp max_temp mean_temp
    ##   <dbl>    <dbl>    <dbl>     <dbl>
    ## 1  2023     11.1     29.1      21.5

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(CT1_envrmonth_sal, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Salinity Timeplot for CT1 - Deep Water Shoal") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](CT1-NOAA-ONLY_files/figure-gfm/timeplot%20-%20salinity-1.png)<!-- -->

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(CT1_envrmonth_temp, aes(x = year)) +
    geom_point(aes(y = month, color = length_temp), size = 4) +
    labs(x = "Time", y = "Month", title = "Temperature Timeplot for CT1 - Deep Water Shoal") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](CT1-NOAA-ONLY_files/figure-gfm/timeplot%20-%20temperature-1.png)<!-- -->

### We can now calculate a list of variables that we will have collected for all sites. This will allow us to compare sites easily. We will calculate the number of observations from each site, the mean annual, maximum annual, and minimum annual value for all variables.

Our list of variables includes:

- Mean_Annual_Temperature_C: average of all available data

- Mean_max_temperature_C: average of maximums for each year

- Mean_min_temperature_C: average of minimums for each year

- Temperature_st_dev: standard deviation of all available data

- Temperature_n: total number of data points

- Temperature_years: number of years in data set

- Mean_Annual_Salinity_ppt: average of all available data

- Mean_min_Salinity_ppt: average of minimums for each year

- Mean_max_Salinity_ppt: average of maximums for each year

- Salinity_st_dev: standard deviation of all available data

- Salinity_n: total number of data points

- Salinity_years: number of years in data set

``` r
#Calculate temperature variables. 
#Calculate temperature variables. 
Mean_Annual_Temperature_C <- mean(CT1_temp$temp)
Mean_max_temperature_C <- mean(CT1_envryear_temp$max_temp)
Mean_min_temperature_C <- mean(CT1_envryear_temp$min_temp)
Temperature_st_dev <- sd(CT1_temp$temp)
Temperature_n <- nrow(CT1_temp)
Temperature_years <- nrow(CT1_envryear_temp)

#Create a data frame to store the temperature results
CT1_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(CT1_temp)
```

    ##      site_name download_date
    ## [1,] "CT1"     "03-27-2024" 
    ##      source_description                                   lat        
    ## [1,] "NOAA Fisheries, Northeast Fisehries Science Center" "41.271986"
    ##      lon          firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "-72.586128" "2023"    "2023"    "21.5293662606609"       
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "29.148335"            "11.118172"            "3.58035424474288"
    ##      Temperature_n Temperature_years collection_type
    ## [1,] "3147"        "1"               "continuously"

``` r
# Write to the combined file with all sites 
write.table(CT1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(CT1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/CT1_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(CT1_sal$salinity)
Mean_max_Salinity_ppt <- mean(CT1_envryear_sal$max_salinity)
Mean_min_Salinity_ppt <- mean(CT1_envryear_sal$min_salinity)
Salinity_st_dev <- sd(CT1_sal$salinity)
Salinity_n <- nrow(CT1_sal)
Salinity_years <- nrow(CT1_envryear_sal)


#Create a data frame to store the temperature results
CT1_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(CT1_salinity)
```

    ##      site_name download_date
    ## [1,] "CT1"     "03-27-2024" 
    ##      source_description                                   lat        
    ## [1,] "NOAA Fisheries, Northeast Fisehries Science Center" "41.271986"
    ##      lon          firstyear finalyear Mean_Annual_Salinity_ppt
    ## [1,] "-72.586128" "2023"    "2023"    "23.8138252620346"      
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev   Salinity_n
    ## [1,] "27.703445"           "0.916823125"         "3.6876707312241" "3147"    
    ##      Salinity_years collection_type
    ## [1,] "1"            "continuously"

``` r
# Write to the combined file with all sites 
write.table(CT1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(CT1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/CT1_salinity.csv", row.names = FALSE)
```
