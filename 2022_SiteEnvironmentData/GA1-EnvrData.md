GA1 - Processed Environmental Data
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
#Data was downloaded on 7/7/2023
#Source - https://cdmo.baruch.sc.edu//dges/- Selected Sapelo Island, Lower Duplin. The station code is SAPLDWQ

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("07-11-2023")
source_description <- ("NERR Centralized Data. Sapelo Island - Lower Duplin SAPLDWQ")
site_name <- ("GA1") #Use site code with site number based on lat position and state
collection_type <- ("continuous")
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from Copano Bay, Texas. The ID_Site for this site is TX2. 
raw_GA1 <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/GA1-raw.csv")
```

    ## Rows: 691351 Columns: 24
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (13): Station_Code, isSWMP, DateTimeStamp, F_Record, F_Temp, F_SpCond, F...
    ## dbl (11): Historical, ProvisionalPlus, Temp, SpCond, Sal, DO_pct, DO_mgl, De...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
spec(raw_GA1)
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
    ##   F_Turb = col_character()
    ## )

``` r
View(raw_GA1)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
# SKIP combining, date and time of collection is already in a column together 

# Use unclass to view the way that the time and date are stored 
# unclass(raw_GA1$DateTimeStamp)
# The data is stored in month-day-yearXX hours(12):minutes format

#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_GA1$datetime <- as.POSIXct(raw_GA1$DateTimeStamp, "%m/%d/%y %H:%M", tz = "")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
summary(raw_GA1)
```

    ##  Station_Code          isSWMP          DateTimeStamp        Historical    
    ##  Length:691351      Length:691351      Length:691351      Min.   :0.0000  
    ##  Class :character   Class :character   Class :character   1st Qu.:1.0000  
    ##  Mode  :character   Mode  :character   Mode  :character   Median :1.0000  
    ##                                                           Mean   :0.8202  
    ##                                                           3rd Qu.:1.0000  
    ##                                                           Max.   :1.0000  
    ##                                                                           
    ##  ProvisionalPlus    F_Record              Temp          F_Temp         
    ##  Min.   :0.0000   Length:691351      Min.   : 4.60   Length:691351     
    ##  1st Qu.:1.0000   Class :character   1st Qu.:15.60   Class :character  
    ##  Median :1.0000   Mode  :character   Median :21.90   Mode  :character  
    ##  Mean   :0.9701                      Mean   :21.43                     
    ##  3rd Qu.:1.0000                      3rd Qu.:27.80                     
    ##  Max.   :1.0000                      Max.   :39.00                     
    ##                                      NA's   :49234                     
    ##      SpCond        F_SpCond              Sal           F_Sal          
    ##  Min.   : 0.01   Length:691351      Min.   : 0.00   Length:691351     
    ##  1st Qu.:38.15   Class :character   1st Qu.:24.20   Class :character  
    ##  Median :42.85   Mode  :character   Median :27.50   Mode  :character  
    ##  Mean   :41.96                      Mean   :26.96                     
    ##  3rd Qu.:46.84                      3rd Qu.:30.40                     
    ##  Max.   :61.57                      Max.   :41.40                     
    ##  NA's   :51417                      NA's   :52328                     
    ##      DO_pct         F_DO_pct             DO_mgl        F_DO_mgl        
    ##  Min.   :-18.90   Length:691351      Min.   :-1.30   Length:691351     
    ##  1st Qu.: 72.20   Class :character   1st Qu.: 5.00   Class :character  
    ##  Median : 83.90   Mode  :character   Median : 6.30   Mode  :character  
    ##  Mean   : 81.28                      Mean   : 6.33                     
    ##  3rd Qu.: 91.80                      3rd Qu.: 7.70                     
    ##  Max.   :271.20                      Max.   :17.70                     
    ##  NA's   :86534                       NA's   :90077                     
    ##      Depth         F_Depth              cDepth         F_cDepth        
    ##  Min.   :-0.24   Length:691351      Min.   :-0.09    Length:691351     
    ##  1st Qu.: 2.54   Class :character   1st Qu.: 2.72    Class :character  
    ##  Median : 3.25   Mode  :character   Median : 3.45    Mode  :character  
    ##  Mean   : 3.23                      Mean   : 3.42                      
    ##  3rd Qu.: 4.00                      3rd Qu.: 4.11                      
    ##  Max.   : 6.32                      Max.   : 9.95                      
    ##  NA's   :58134                      NA's   :308784                     
    ##        pH            F_pH                Turb             F_Turb         
    ##  Min.   : 5.50   Length:691351      Min.   :  -33.00   Length:691351     
    ##  1st Qu.: 7.50   Class :character   1st Qu.:   11.00   Class :character  
    ##  Median : 7.70   Mode  :character   Median :   26.00   Mode  :character  
    ##  Mean   : 7.74                      Mean   :   46.59                     
    ##  3rd Qu.: 7.90                      3rd Qu.:   56.00                     
    ##  Max.   :10.60                      Max.   :27287.00                     
    ##  NA's   :80127                      NA's   :111030                       
    ##     datetime                     
    ##  Min.   :1999-01-01 00:00:00.00  
    ##  1st Qu.:2007-10-04 19:37:30.00  
    ##  Median :2012-09-08 05:00:00.00  
    ##  Mean   :2012-04-27 17:39:11.49  
    ##  3rd Qu.:2017-08-13 14:22:30.00  
    ##  Max.   :2022-07-18 23:45:00.00  
    ##  NA's   :80

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_GA1 <- raw_GA1 %>% rename("temp" = "Temp", "salinity" = "Sal") #No lat and long data in this file - check metadata files

#Print the range (minimum and maximum) of dates of data collection. 
print(summary(raw_GA1$datetime))
```

    ##                       Min.                    1st Qu. 
    ## "1999-01-01 00:00:00.0000" "2007-10-04 19:37:30.0000" 
    ##                     Median                       Mean 
    ## "2012-09-08 05:00:00.0000" "2012-04-27 17:39:11.4941" 
    ##                    3rd Qu.                       Max. 
    ## "2017-08-13 14:22:30.0000" "2022-07-18 23:45:00.0000" 
    ##                       NA's 
    ##                       "80"

``` r
#Print the range (minimum and maximum) of the salinity values. 
print(summary(raw_GA1$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   24.20   27.50   26.96   30.40   41.40   52328

``` r
#Print the range (minimum and maximum) of the temperature values.
print(summary(raw_GA1$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    4.60   15.60   21.90   21.43   27.80   39.00   49234

``` r
#Store variables that we will include in the final data frame. Pull metadata from metadata file in download .zip file. 
lat <- 31.41794
lon <- -81.29605
firstyear <- 1999
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
filtered_GA1 <- raw_GA1 %>%
    filter(between(salinity, 0, 42) & between(temp, 0, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_GA1$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00   24.20   27.50   26.96   30.40   41.40

``` r
print(summary(filtered_GA1$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    4.60   15.50   22.00   21.44   27.80   39.00

``` r
#Store our data into a variable name with just the site name. 
GA1 <- filtered_GA1
```

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(GA1, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,45) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for GA1 - Sapelo Island") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()


salplot
```

    ## Warning: Removed 74 rows containing missing values (`geom_line()`).

![](GA1-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(GA1, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for GA1 - Sapelo Island") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

    ## Warning: Removed 74 rows containing missing values (`geom_line()`).

![](GA1-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
GA1_envrmonth <- GA1 %>%
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
print(GA1_envrmonth)
```

    ## # A tibble: 283 × 10
    ## # Groups:   year [25]
    ##     year month min_salinity max_salinity mean_salinity length_salinity min_temp
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>    <dbl>
    ##  1  1999     1         21.1         35            27.8            1486      9.3
    ##  2  1999     2         15.8         34.9          25.7            1341     12.1
    ##  3  1999     3         19.5         32.2          24.7            1485     13.3
    ##  4  1999     4         20.2         32.9          26.2            1435     18.4
    ##  5  1999     5          0.2         34.6          28.8            1487     16.7
    ##  6  1999     6         25.4         31.4          27.7            1439     25.4
    ##  7  1999     7         22.6         29.7          26.2            1486     26.2
    ##  8  1999     8         22.5         34.4          27.4            1268     27.9
    ##  9  1999     9         24           34.3          29.2            1341     23.4
    ## 10  1999    10         23.4         28.1          25.5            1073     21.3
    ## # ℹ 273 more rows
    ## # ℹ 3 more variables: max_temp <dbl>, mean_temp <dbl>, length_temp <int>

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
GA1_envryear <- GA1 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity),
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(GA1_envryear)
```

    ## # A tibble: 25 × 7
    ##     year min_salinity max_salinity mean_salinity min_temp max_temp mean_temp
    ##    <dbl>        <dbl>        <dbl>         <dbl>    <dbl>    <dbl>     <dbl>
    ##  1  1999          0.1         35            26.7      9.3     33.1      21.6
    ##  2  2000          0.1         36.7          27.9      6.6     31.1      21.3
    ##  3  2001          7.8         41.1          29.0      7.1     31.1      21.8
    ##  4  2002          4.6         34.4          27.8      8       31.5      20.3
    ##  5  2003          0.1         34.3          24.7      7.6     31.1      21.0
    ##  6  2004          8.5         36.6          26.4      7.9     31.3      21.0
    ##  7  2005          4.1         34.8          24.3      7.8     32.4      21.3
    ##  8  2006         13.9         35.3          29.0      9.5     32.4      21.4
    ##  9  2007         13.5         36.3          29.1      9.7     39        20.8
    ## 10  2008         13           35.5          28.7      6.6     30.9      21.3
    ## # ℹ 15 more rows

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(GA1_envrmonth, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Timeplot for GA1 - Sapelo Island") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

    ## Warning: Removed 1 rows containing missing values (`geom_point()`).

![](GA1-EnvrData_files/figure-gfm/timeplot-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(GA1$temp)
Mean_max_temperature_C <- mean(GA1_envryear$max_temp)
Mean_min_temperature_C <- mean(GA1_envryear$min_temp)
Temperature_st_dev <- sd(GA1$temp)
Temperature_n <- nrow(GA1)
Temperature_years <- nrow(GA1_envryear)

#Create a data frame to store the temperature results
GA1_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(GA1_temp)
```

    ##      site_name download_date
    ## [1,] "GA1"     "07-11-2023" 
    ##      source_description                                            lat       
    ## [1,] "NERR Centralized Data. Sapelo Island - Lower Duplin SAPLDWQ" "31.41794"
    ##      lon         firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "-81.29605" "1999"    "2022"    "21.4355738369354"       
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "31.676"               "8.624"                "6.63561715192258"
    ##      Temperature_n Temperature_years collection_type
    ## [1,] "639023"      "25"              "continuous"

``` r
# Write to the combined file with all sites 
write.table(GA1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(GA1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/GA1_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(GA1$salinity)
Mean_max_Salinity_ppt <- mean(GA1_envryear$max_salinity)
Mean_min_Salinity_ppt <- mean(GA1_envryear$min_salinity)
Salinity_st_dev <- sd(GA1$salinity)
Salinity_n <- nrow(GA1)
Salinity_years <- nrow(GA1_envryear)


#Create a data frame to store the temperature results
GA1_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(GA1_salinity)
```

    ##      site_name download_date
    ## [1,] "GA1"     "07-11-2023" 
    ##      source_description                                            lat       
    ## [1,] "NERR Centralized Data. Sapelo Island - Lower Duplin SAPLDWQ" "31.41794"
    ##      lon         firstyear finalyear Mean_Annual_Salinity_ppt
    ## [1,] "-81.29605" "1999"    "2022"    "26.9566034399388"      
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev    Salinity_n
    ## [1,] "35.352"              "6.128"               "4.59614985358915" "639023"  
    ##      Salinity_years collection_type
    ## [1,] "25"           "continuous"

``` r
# Write to the combined file with all sites 
write.table(GA1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(GA1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/GA1_salinity.csv")
```
