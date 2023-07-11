NH1 - Processed Environmental Data
================
Madeline Eppley
7/11/2023

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
#Data was downloaded on 7/11/2023
#Source - https://cdmo.baruch.sc.edu//dges/- Selected Great Bay, Squamscott River. The station code is GRBSQWQ.

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("07-11-2023")
source_description <- ("NERR Centralized Data. Great Bay - Squamscott River GRBSQWQ")
site_name <- ("NH1") #Use site code with site number based on lat position and state
collection_type <- ("continuous")
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from Great Bay, Mouth of the Squamscott River in New Hampshire. The ID_Site for this site is NH1. 
raw_NH1 <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/NH1-raw.csv")
```

    ## Rows: 591234 Columns: 26
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (14): Station_Code, isSWMP, DateTimeStamp, F_Record, F_Temp, F_SpCond, F...
    ## dbl (12): Historical, ProvisionalPlus, Temp, SpCond, Sal, DO_pct, DO_mgl, De...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
spec(raw_NH1)
```

    ## cols(
    ##   Station_Code = col_character(),
    ##   isSWMP = col_character(),
    ##   DateTimeStamp = col_character(),
    ##   Historical = col_double(),
    ##   ProvisionalPlus = col_double(),
    ##   F_Record = col_character(),
    ##   Temp = col_double(),
    ##   F_Temp = col_character(),
    ##   SpCond = col_double(),
    ##   F_SpCond = col_character(),
    ##   Sal = col_double(),
    ##   F_Sal = col_character(),
    ##   DO_pct = col_double(),
    ##   F_DO_pct = col_character(),
    ##   DO_mgl = col_double(),
    ##   F_DO_mgl = col_character(),
    ##   Depth = col_double(),
    ##   F_Depth = col_character(),
    ##   cDepth = col_double(),
    ##   F_cDepth = col_character(),
    ##   pH = col_double(),
    ##   F_pH = col_character(),
    ##   Turb = col_double(),
    ##   F_Turb = col_character(),
    ##   ChlFluor = col_double(),
    ##   F_ChlFluor = col_character()
    ## )

``` r
View(raw_NH1)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
# SKIP combining, date and time of collection is already in a column together 

# Use unclass to view the way that the time and date are stored 
# unclass(raw_NH1$DateTimeStamp)
# The data is stored in month-day-yearXX hours(12):minutes format

#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_NH1$datetime <- as.POSIXct(raw_NH1$DateTimeStamp, "%m/%d/%y %H:%M", tz = "")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
summary(raw_NH1)
```

    ##  Station_Code          isSWMP          DateTimeStamp        Historical    
    ##  Length:591234      Length:591234      Length:591234      Min.   :0.0000  
    ##  Class :character   Class :character   Class :character   1st Qu.:1.0000  
    ##  Mode  :character   Mode  :character   Mode  :character   Median :1.0000  
    ##                                                           Mean   :0.8252  
    ##                                                           3rd Qu.:1.0000  
    ##                                                           Max.   :1.0000  
    ##                                                                           
    ##  ProvisionalPlus    F_Record              Temp           F_Temp         
    ##  Min.   :0.0000   Length:591234      Min.   :-0.7     Length:591234     
    ##  1st Qu.:1.0000   Class :character   1st Qu.:11.9     Class :character  
    ##  Median :1.0000   Mode  :character   Median :18.0     Mode  :character  
    ##  Mean   :0.9412                      Mean   :16.8                       
    ##  3rd Qu.:1.0000                      3rd Qu.:22.3                       
    ##  Max.   :1.0000                      Max.   :29.4                       
    ##                                      NA's   :153499                     
    ##      SpCond         F_SpCond              Sal            F_Sal          
    ##  Min.   : 0.01    Length:591234      Min.   : 0.00    Length:591234     
    ##  1st Qu.:21.57    Class :character   1st Qu.:12.90    Class :character  
    ##  Median :32.13    Mode  :character   Median :20.00    Mode  :character  
    ##  Mean   :29.73                       Mean   :18.64                      
    ##  3rd Qu.:39.91                       3rd Qu.:25.40                      
    ##  Max.   :52.33                       Max.   :34.50                      
    ##  NA's   :158356                      NA's   :158863                     
    ##      DO_pct         F_DO_pct             DO_mgl         F_DO_mgl        
    ##  Min.   : 24.50   Length:591234      Min.   : 1.90    Length:591234     
    ##  1st Qu.: 85.70   Class :character   1st Qu.: 7.10    Class :character  
    ##  Median : 93.20   Mode  :character   Median : 8.10    Mode  :character  
    ##  Mean   : 93.43                      Mean   : 8.28                      
    ##  3rd Qu.:101.10                      3rd Qu.: 9.40                      
    ##  Max.   :500.00                      Max.   :39.00                      
    ##  NA's   :163864                      NA's   :168659                     
    ##      Depth          F_Depth              cDepth         F_cDepth        
    ##  Min.   : 0.03    Length:591234      Min.   : 0.0     Length:591234     
    ##  1st Qu.: 1.35    Class :character   1st Qu.: 1.4     Class :character  
    ##  Median : 1.98    Mode  :character   Median : 2.0     Mode  :character  
    ##  Mean   : 2.05                       Mean   : 2.0                       
    ##  3rd Qu.: 2.61                       3rd Qu.: 2.6                       
    ##  Max.   :26.14                       Max.   :26.3                       
    ##  NA's   :158167                      NA's   :335102                     
    ##        pH             F_pH                Turb            F_Turb         
    ##  Min.   : 5.20    Length:591234      Min.   :  -4.00   Length:591234     
    ##  1st Qu.: 7.30    Class :character   1st Qu.:   7.00   Class :character  
    ##  Median : 7.60    Mode  :character   Median :  14.00   Mode  :character  
    ##  Mean   : 7.58                       Mean   :  28.51                     
    ##  3rd Qu.: 7.80                       3rd Qu.:  27.00                     
    ##  Max.   :11.10                       Max.   :2502.00                     
    ##  NA's   :163399                      NA's   :179436                      
    ##     ChlFluor       F_ChlFluor           datetime                     
    ##  Min.   :  0.4    Length:591234      Min.   :1997-07-21 14:30:00.00  
    ##  1st Qu.:  4.0    Class :character   1st Qu.:2008-04-19 12:41:15.00  
    ##  Median :  5.4    Mode  :character   Median :2012-09-24 17:22:30.00  
    ##  Mean   :  6.4                       Mean   :2012-05-13 11:25:56.24  
    ##  3rd Qu.:  7.3                       3rd Qu.:2017-05-16 00:18:45.00  
    ##  Max.   :398.3                       Max.   :2022-08-15 23:45:00.00  
    ##  NA's   :479896                      NA's   :46

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_NH1 <- raw_NH1 %>% rename("temp" = "Temp", "salinity" = "Sal") #No lat and long data in this file - check metadata files

#Print the range (minimum and maximum) of dates of data collection. 
print(summary(raw_NH1$datetime))
```

    ##                       Min.                    1st Qu. 
    ## "1997-07-21 14:30:00.0000" "2008-04-19 12:41:15.0000" 
    ##                     Median                       Mean 
    ## "2012-09-24 17:22:30.0000" "2012-05-13 11:25:56.2369" 
    ##                    3rd Qu.                       Max. 
    ## "2017-05-16 00:18:45.0000" "2022-08-15 23:45:00.0000" 
    ##                       NA's 
    ##                       "46"

``` r
#Print the range (minimum and maximum) of the salinity values. 
print(summary(raw_NH1$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   12.90   20.00   18.64   25.40   34.50  158863

``` r
#Print the range (minimum and maximum) of the temperature values.
print(summary(raw_NH1$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    -0.7    11.9    18.0    16.8    22.3    29.4  153499

``` r
#Store variables that we will include in the final data frame. Pull metadata from metadata file in download .zip file. 
lat <- 43.05240
lon <- -70.91181
firstyear <- 1997
finalyear <- 2022
```

### We can see that some of the values make sense - the minimum and maximum latitude and longitude values are the same.

Filter any of the variables that have data points outside of normal
range. We will use 0-40 as the accepted range for salinity (ppt) and
temperature (C) values. Note, in the summer, salinity values can
sometimes exceed 40. Check to see if there are values above 40. In this
case, adjust the range or notify someone that the site has particularly
high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
filtered_NH1<- raw_NH1 %>%
    filter(between(salinity, 0, 40) & between(temp, -1, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_NH1$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00   12.90   20.00   18.64   25.40   34.50

``` r
print(summary(filtered_NH1$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   -0.70   11.80   17.90   16.72   22.20   29.40

``` r
#Store our data into a variable name with just the site name. 
NH1 <- filtered_NH1
```

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(NH1, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,45) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for NH1 - Great Bay - Squamscott River") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()


salplot
```

    ## Warning: Removed 2 rows containing missing values (`geom_line()`).

![](NH1-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(NH1, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(-10, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for NH1 - Great Bay - Squamscott River") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

    ## Warning: Removed 2 rows containing missing values (`geom_line()`).

![](NH1-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
NH1_envrmonth <- NH1 %>%
    mutate(year = year(datetime), month = month(datetime)) %>%
    group_by(year, month) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity),
      length_salinity = length(salinity),
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp),
      length_temp = length(temp))
```

    ## `summarise()` has grouped output by 'year'. You can override using the
    ## `.groups` argument.

``` r
print(NH1_envrmonth)
```

    ## # A tibble: 222 × 10
    ## # Groups:   year [27]
    ##     year month min_salinity max_salinity mean_salinity length_salinity min_temp
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>    <dbl>
    ##  1  1997     7         12           24.5         19.7              499     19.1
    ##  2  1997     8         11.8         27.9         22.5             1430     19.2
    ##  3  1997     9         13.1         26.5         21.6             1312     14.3
    ##  4  1997    10         14.2         27.1         22.7             1327      6.9
    ##  5  1997    11          1.2         23.7         13.2             1307      0.8
    ##  6  1998     4          0.1         14.9          5.16             358      9.3
    ##  7  1998     5          0           21.8          6.00            1429     11.1
    ##  8  1998     6          0           22.1          4.45            1115     15.7
    ##  9  1998     7          0.1         24.4         11.7             1044     19.6
    ## 10  1998     8         13.4         29.9         25.9              873     20.2
    ## # ℹ 212 more rows
    ## # ℹ 3 more variables: max_temp <dbl>, mean_temp <dbl>, length_temp <int>

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
NH1_envryear <- NH1 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity),
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(NH1_envryear)
```

    ## # A tibble: 27 × 7
    ##     year min_salinity max_salinity mean_salinity min_temp max_temp mean_temp
    ##    <dbl>        <dbl>        <dbl>         <dbl>    <dbl>    <dbl>     <dbl>
    ##  1  1997          1.2         27.9          20.0      0.8     26.6      15.6
    ##  2  1998          0           29.9          16.0      4.8     27        17.1
    ##  3  1999          1.7         30.8          20.8      2.7     28.4      16.5
    ##  4  2000          0           28.5          19.3     10.5     25.6      20.2
    ##  5  2001          1.1         33.9          24.2      4.1     28.3      17.7
    ##  6  2002          0.2         33.8          22.7     -0.2     29        17.0
    ##  7  2003          0.2         29.8          18.2      2.6     27.3      16.8
    ##  8  2004          0.1         29            16.8     -0.7     26.5      15.8
    ##  9  2005          0           30.5          14.3     -0.2     27.3      15.8
    ## 10  2006          0           28.9          13.1      4.1     28.1      16.1
    ## # ℹ 17 more rows

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(NH1_envrmonth, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Timeplot for NH1 - Great Bay - Squamscott River") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

    ## Warning: Removed 1 rows containing missing values (`geom_point()`).

![](NH1-EnvrData_files/figure-gfm/timeplot-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(NH1$temp)
Mean_max_temperature_C <- mean(NH1_envryear$max_temp)
Mean_min_temperature_C <- mean(NH1_envryear$min_temp)
Temperature_st_dev <- sd(NH1$temp)
Temperature_n <- nrow(NH1)
Temperature_years <- nrow(NH1_envryear)

#Create a data frame to store the temperature results
NH1_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(NH1_temp)
```

    ##      site_name download_date
    ## [1,] "NH1"     "07-11-2023" 
    ##      source_description                                            lat      
    ## [1,] "NERR Centralized Data. Great Bay - Squamscott River GRBSQWQ" "43.0524"
    ##      lon         firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "-70.91181" "1997"    "2022"    "16.7170932303351"       
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "27.162962962963"      "2.54814814814815"     "6.44962480142627"
    ##      Temperature_n Temperature_years collection_type
    ## [1,] "432370"      "27"              "continuous"

``` r
# Write to the combined file with all sites 
write.table(NH1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(NH1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/NH1_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(NH1$salinity)
Mean_max_Salinity_ppt <- mean(NH1_envryear$max_salinity)
Mean_min_Salinity_ppt <- mean(NH1_envryear$min_salinity)
Salinity_st_dev <- sd(NH1$salinity)
Salinity_n <- nrow(NH1)
Salinity_years <- nrow(NH1_envryear)


#Create a data frame to store the temperature results
NH1_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(NH1_salinity)
```

    ##      site_name download_date
    ## [1,] "NH1"     "07-11-2023" 
    ##      source_description                                            lat      
    ## [1,] "NERR Centralized Data. Great Bay - Squamscott River GRBSQWQ" "43.0524"
    ##      lon         firstyear finalyear Mean_Annual_Salinity_ppt
    ## [1,] "-70.91181" "1997"    "2022"    "18.6413907070333"      
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev    Salinity_n
    ## [1,] "30.0444444444444"    "1.14444444444444"    "8.32092581976783" "432370"  
    ##      Salinity_years collection_type
    ## [1,] "27"           "continuous"

``` r
# Write to the combined file with all sites 
write.table(NH1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(NH1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/NH1_salinity.csv")
```
