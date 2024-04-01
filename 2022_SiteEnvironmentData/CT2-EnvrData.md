CT2 - Processed Environmental Data
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
site_name <- ("CT2") #Use site code with site number based on lat position and state
collection_type <- ("continuous_seasonal")
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from Fence Creek, Connecticut. The ID_Site for this site is CT2. 
raw_CT2_sal <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/CT2-raw_sal.csv")
```

    ## New names:
    ## Rows: 2749 Columns: 5
    ## ── Column specification
    ## ──────────────────────────────────────────────────────── Delimiter: "," chr
    ## (3): Date Time, Site, variable dbl (2): ...1, mean
    ## ℹ Use `spec()` to retrieve the full column specification for this data. ℹ
    ## Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## • `` -> `...1`

``` r
raw_CT2_temp <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/CT2-raw_temp.csv")
```

    ## New names:
    ## Rows: 2749 Columns: 5
    ## ── Column specification
    ## ──────────────────────────────────────────────────────── Delimiter: "," chr
    ## (3): Date Time, Site, variable dbl (2): ...1, mean
    ## ℹ Use `spec()` to retrieve the full column specification for this data. ℹ
    ## Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## • `` -> `...1`

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
spec(raw_CT2_sal)
```

    ## cols(
    ##   ...1 = col_double(),
    ##   `Date Time` = col_character(),
    ##   Site = col_character(),
    ##   variable = col_character(),
    ##   mean = col_double()
    ## )

``` r
#View(raw_CT2_sal)

spec(raw_CT2_temp)
```

    ## cols(
    ##   ...1 = col_double(),
    ##   `Date Time` = col_character(),
    ##   Site = col_character(),
    ##   variable = col_character(),
    ##   mean = col_double()
    ## )

``` r
#View(raw_CT2_temp)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_CT2_sal$datetime <- as.POSIXct(raw_CT2_sal$`Date Time`, "%m/%d/%y %H:%M", tz = "")
raw_CT2_temp$datetime <- as.POSIXct(raw_CT2_temp$`Date Time`, "%m/%d/%y %H:%M", tz = "")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
head(raw_CT2_sal)
```

    ## # A tibble: 6 × 6
    ##    ...1 `Date Time`   Site  variable  mean datetime           
    ##   <dbl> <chr>         <chr> <chr>    <dbl> <dttm>             
    ## 1    13 6/14/23 11:00 FENC  Salinity  19.5 2023-06-14 11:00:00
    ## 2    24 6/14/23 12:00 FENC  Salinity  23.0 2023-06-14 12:00:00
    ## 3    35 6/14/23 13:00 FENC  Salinity  23.8 2023-06-14 13:00:00
    ## 4    46 6/14/23 14:00 FENC  Salinity  19.4 2023-06-14 14:00:00
    ## 5    57 6/14/23 15:00 FENC  Salinity  22.3 2023-06-14 15:00:00
    ## 6    68 6/14/23 16:00 FENC  Salinity  25.3 2023-06-14 16:00:00

``` r
head(raw_CT2_temp)
```

    ## # A tibble: 6 × 6
    ##    ...1 `Date Time`   Site  variable     mean datetime           
    ##   <dbl> <chr>         <chr> <chr>       <dbl> <dttm>             
    ## 1    22 6/14/23 11:00 FENC  Temperature  24.0 2023-06-14 11:00:00
    ## 2    33 6/14/23 12:00 FENC  Temperature  25.2 2023-06-14 12:00:00
    ## 3    44 6/14/23 13:00 FENC  Temperature  29.3 2023-06-14 13:00:00
    ## 4    55 6/14/23 14:00 FENC  Temperature  21.9 2023-06-14 14:00:00
    ## 5    66 6/14/23 15:00 FENC  Temperature  22.3 2023-06-14 15:00:00
    ## 6    77 6/14/23 16:00 FENC  Temperature  21.1 2023-06-14 16:00:00

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_CT2_sal <- raw_CT2_sal %>% rename("salinity" = "mean")
raw_CT2_temp <- raw_CT2_temp  %>% rename("temp" = "mean")

#Store variables that we will include in the final data frame
lat <- 41.271986
lon <- -72.586128
firstyear <- 2023
finalyear <- 2023
```

### Filter any of the variables that have data points outside of normal range. We will use 0-40 as the accepted range for salinity (ppt) and temperature (C) values. Note, in the summer, salinity values can sometimes exceed 40. Check to see if there are values above 40. In this case, adjust the range or notify someone that the site has particularly high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
filtered_CT2_sal <- raw_CT2_sal %>%
    filter(between(salinity, 0, 42)) 
           
filtered_CT2_temp <- raw_CT2_temp %>%
    filter(between(temp, 0, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_CT2_sal$salinity))
```

    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    ##  0.04694 21.80603 26.08103 24.15026 28.26177 29.68323

``` r
print(summary(filtered_CT2_temp$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   8.023  20.432  22.229  21.683  23.671  29.933

``` r
print(summary(filtered_CT2_sal$datetime))
```

    ##                       Min.                    1st Qu. 
    ## "2023-06-14 11:00:00.0000" "2023-07-13 02:15:00.0000" 
    ##                     Median                       Mean 
    ## "2023-08-10 18:30:00.0000" "2023-08-12 22:32:45.1857" 
    ##                    3rd Qu.                       Max. 
    ## "2023-09-08 08:45:00.0000" "2023-11-08 12:00:00.0000"

``` r
print(summary(filtered_CT2_temp$datetime))
```

    ##                       Min.                    1st Qu. 
    ## "2023-06-14 11:00:00.0000" "2023-07-13 02:15:00.0000" 
    ##                     Median                       Mean 
    ## "2023-08-10 18:30:00.0000" "2023-08-12 22:32:45.1857" 
    ##                    3rd Qu.                       Max. 
    ## "2023-09-08 08:45:00.0000" "2023-11-08 12:00:00.0000"

``` r
#Store our data into a variable name with just the site name. 
CT2_temp <- filtered_CT2_temp
CT2_sal <- filtered_CT2_sal
```

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(CT2_sal, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,40) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for CT2 - Fence Creek, CT") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()

salplot
```

![](CT2-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(CT2_temp, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for CT2 - Fence Creek") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

![](CT2-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
CT2_envrmonth_sal <- CT2_sal %>%
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
CT2_envrmonth_temp <- CT2_temp %>%
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
print(CT2_envrmonth_sal)
```

    ## # A tibble: 6 × 6
    ## # Groups:   year [1]
    ##    year month min_salinity max_salinity mean_salinity length_salinity
    ##   <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>
    ## 1  2023     6      18.0            29.7          26.5             397
    ## 2  2023     7       1.47           28.5          21.9             743
    ## 3  2023     8       0.758          29.1          24.4             742
    ## 4  2023     9       7.41           28.9          25.1             676
    ## 5  2023    10       0.0469         27.6          18.8               7
    ## 6  2023    11       9.12           27.6          23.6             181

``` r
print(CT2_envrmonth_temp)
```

    ## # A tibble: 6 × 6
    ## # Groups:   year [1]
    ##    year month min_temp max_temp mean_temp length_temp
    ##   <dbl> <dbl>    <dbl>    <dbl>     <dbl>       <int>
    ## 1  2023     6    17.1      29.3      20.4         397
    ## 2  2023     7    19.4      29.7      23.7         743
    ## 3  2023     8    19.2      27.5      22.8         742
    ## 4  2023     9    15.2      29.9      21.5         676
    ## 5  2023    10    12.4      19.5      14.6           7
    ## 6  2023    11     8.02     14.7      12.3         181

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
CT2_envryear_sal <- CT2_sal %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity))

CT2_envryear_temp <- CT2_temp %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(CT2_envryear_sal)
```

    ## # A tibble: 1 × 4
    ##    year min_salinity max_salinity mean_salinity
    ##   <dbl>        <dbl>        <dbl>         <dbl>
    ## 1  2023       0.0469         29.7          24.2

``` r
print(CT2_envryear_temp)
```

    ## # A tibble: 1 × 4
    ##    year min_temp max_temp mean_temp
    ##   <dbl>    <dbl>    <dbl>     <dbl>
    ## 1  2023     8.02     29.9      21.7

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(CT2_envrmonth_sal, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Salinity Timeplot for CT2 - Deep Water Shoal") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](CT2-EnvrData_files/figure-gfm/timeplot%20-%20salinity-1.png)<!-- -->

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(CT2_envrmonth_temp, aes(x = year)) +
    geom_point(aes(y = month, color = length_temp), size = 4) +
    labs(x = "Time", y = "Month", title = "Temperature Timeplot for CT2 - Deep Water Shoal") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](CT2-EnvrData_files/figure-gfm/timeplot%20-%20temperature-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(CT2_temp$temp)
Mean_max_temperature_C <- mean(CT2_envryear_temp$max_temp)
Mean_min_temperature_C <- mean(CT2_envryear_temp$min_temp)
Temperature_st_dev <- sd(CT2_temp$temp)
Temperature_n <- nrow(CT2_temp)
Temperature_years <- nrow(CT2_envryear_temp)

#Create a data frame to store the temperature results
CT2_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(CT2_temp)
```

    ##      site_name download_date
    ## [1,] "CT2"     "03-27-2024" 
    ##      source_description                                   lat        
    ## [1,] "NOAA Fisheries, Northeast Fisehries Science Center" "41.271986"
    ##      lon          firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "-72.586128" "2023"    "2023"    "21.683434550579"        
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "29.93308667"          "8.022749333"          "3.43271325911718"
    ##      Temperature_n Temperature_years collection_type      
    ## [1,] "2746"        "1"               "continuous_seasonal"

``` r
# Write to the combined file with all sites 
write.table(CT2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(CT2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/CT2_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(CT2_sal$salinity)
Mean_max_Salinity_ppt <- mean(CT2_envryear_sal$max_salinity)
Mean_min_Salinity_ppt <- mean(CT2_envryear_sal$min_salinity)
Salinity_st_dev <- sd(CT2_sal$salinity)
Salinity_n <- nrow(CT2_sal)
Salinity_years <- nrow(CT2_envryear_sal)


#Create a data frame to store the temperature results
CT2_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(CT2_salinity)
```

    ##      site_name download_date
    ## [1,] "CT2"     "03-27-2024" 
    ##      source_description                                   lat        
    ## [1,] "NOAA Fisheries, Northeast Fisehries Science Center" "41.271986"
    ##      lon          firstyear finalyear Mean_Annual_Salinity_ppt
    ## [1,] "-72.586128" "2023"    "2023"    "24.1502557605503"      
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev    Salinity_n
    ## [1,] "29.683235"           "0.04694429"          "5.34570290659941" "2746"    
    ##      Salinity_years collection_type      
    ## [1,] "1"            "continuous_seasonal"

``` r
# Write to the combined file with all sites 
write.table(CT2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(CT2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/CT2_salinity.csv", row.names = FALSE)
```
