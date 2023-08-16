NC1 - Processed Environmental Data
================
Madeline Eppley
8/16/2023

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
#Data was downloaded on 8/16/2023
#Source - https://cdmo.baruch.sc.edu//dges/ - Selected North Carolina, Zeke's Basin. The station code is NOCZBWQ.

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("08-16-2023")
source_description <- ("NERR Centralized Data. North Carolina - Zeke's Basin/Cape Fear River NOCZBWQ")
site_name <- ("NC1") #Use site code with site number based on lat position and state
collection_type <- ("continuous")
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from Zeke's Basin/Cape Fear River in North Carolina. The ID_Site for this site is NC1. 
raw_NC1 <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/NC1-raw.csv")
```

    ## Rows: 668588 Columns: 26
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (14): Station_Code, isSWMP, DateTimeStamp, F_Record, F_Temp, F_SpCond, F...
    ## dbl (12): Historical, ProvisionalPlus, Temp, SpCond, Sal, DO_pct, DO_mgl, De...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
spec(raw_NC1)
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
View(raw_NC1)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
# SKIP combining, date and time of collection is already in a column together 

#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_NC1$datetime <- as.POSIXct(raw_NC1$DateTimeStamp, "%m/%d/%y %H:%M", tz = "")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
summary(raw_NC1)
```

    ##  Station_Code          isSWMP          DateTimeStamp        Historical    
    ##  Length:668588      Length:668588      Length:668588      Min.   :0.0000  
    ##  Class :character   Class :character   Class :character   1st Qu.:1.0000  
    ##  Mode  :character   Mode  :character   Mode  :character   Median :1.0000  
    ##                                                           Mean   :0.8143  
    ##                                                           3rd Qu.:1.0000  
    ##                                                           Max.   :1.0000  
    ##                                                                           
    ##  ProvisionalPlus    F_Record              Temp          F_Temp         
    ##  Min.   :0.0000   Length:668588      Min.   :-1.7    Length:668588     
    ##  1st Qu.:1.0000   Class :character   1st Qu.:14.0    Class :character  
    ##  Median :1.0000   Mode  :character   Median :21.0    Mode  :character  
    ##  Mean   :0.9952                      Mean   :20.3                      
    ##  3rd Qu.:1.0000                      3rd Qu.:27.0                      
    ##  Max.   :1.0000                      Max.   :39.8                      
    ##                                      NA's   :35753                     
    ##      SpCond        F_SpCond              Sal           F_Sal          
    ##  Min.   : 0.12   Length:668588      Min.   : 0.10   Length:668588     
    ##  1st Qu.:28.69   Class :character   1st Qu.:17.70   Class :character  
    ##  Median :35.86   Mode  :character   Median :22.60   Mode  :character  
    ##  Mean   :34.71                      Mean   :21.91                     
    ##  3rd Qu.:41.76                      3rd Qu.:26.70                     
    ##  Max.   :54.43                      Max.   :35.90                     
    ##  NA's   :47325                      NA's   :47326                     
    ##      DO_pct         F_DO_pct             DO_mgl        F_DO_mgl        
    ##  Min.   :-12.30   Length:668588      Min.   :-1.00   Length:668588     
    ##  1st Qu.: 69.00   Class :character   1st Qu.: 5.20   Class :character  
    ##  Median : 87.10   Mode  :character   Median : 7.10   Mode  :character  
    ##  Mean   : 86.02                      Mean   : 7.08                     
    ##  3rd Qu.:100.40                      3rd Qu.: 8.90                     
    ##  Max.   :492.80                      Max.   :30.80                     
    ##  NA's   :56909                       NA's   :65526                     
    ##      Depth         F_Depth              cDepth         F_cDepth        
    ##  Min.   :-0.29   Length:668588      Min.   :-0.20    Length:668588     
    ##  1st Qu.: 0.27   Class :character   1st Qu.: 0.18    Class :character  
    ##  Median : 0.54   Mode  :character   Median : 0.47    Mode  :character  
    ##  Mean   : 0.60                      Mean   : 0.53                      
    ##  3rd Qu.: 0.91                      3rd Qu.: 0.85                      
    ##  Max.   : 2.09                      Max.   : 2.20                      
    ##  NA's   :67833                      NA's   :266872                     
    ##        pH            F_pH                Turb            F_Turb         
    ##  Min.   :5.50    Length:668588      Min.   :  -3.00   Length:668588     
    ##  1st Qu.:7.50    Class :character   1st Qu.:   9.00   Class :character  
    ##  Median :7.70    Mode  :character   Median :  18.00   Mode  :character  
    ##  Mean   :7.73                       Mean   :  63.65                     
    ##  3rd Qu.:8.00                       3rd Qu.:  50.00                     
    ##  Max.   :9.80                       Max.   :5264.00                     
    ##  NA's   :58879                      NA's   :77661                       
    ##     ChlFluor       F_ChlFluor           datetime                     
    ##  Min.   :  0.0    Length:668588      Min.   :2002-03-01 12:30:00.00  
    ##  1st Qu.:  7.0    Class :character   1st Qu.:2009-03-29 16:18:45.00  
    ##  Median : 13.4    Mode  :character   Median :2014-01-03 18:07:30.00  
    ##  Mean   : 20.8                       Mean   :2013-11-16 19:13:06.30  
    ##  3rd Qu.: 26.2                       3rd Qu.:2018-10-10 20:56:15.00  
    ##  Max.   :724.0                       Max.   :2023-07-17 23:45:00.00  
    ##  NA's   :517708                      NA's   :78

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_NC1 <- raw_NC1 %>% rename("temp" = "Temp", "salinity" = "Sal") #No lat and long data in this file - check metadata files

#Print the range (minimum and maximum) of dates of data collection. 
print(summary(raw_NC1$datetime))
```

    ##                       Min.                    1st Qu. 
    ## "2002-03-01 12:30:00.0000" "2009-03-29 16:18:45.0000" 
    ##                     Median                       Mean 
    ## "2014-01-03 18:07:30.0000" "2013-11-16 19:13:06.3108" 
    ##                    3rd Qu.                       Max. 
    ## "2018-10-10 20:56:15.0000" "2023-07-17 23:45:00.0000" 
    ##                       NA's 
    ##                       "78"

``` r
#Print the range (minimum and maximum) of the salinity values. 
print(summary(raw_NC1$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.10   17.70   22.60   21.91   26.70   35.90   47326

``` r
#Print the range (minimum and maximum) of the temperature values.
print(summary(raw_NC1$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    -1.7    14.0    21.0    20.3    27.0    39.8   35753

``` r
#Store variables that we will include in the final data frame. Pull metadata from metadata file in download .zip file. 
lat <- 33.95470
lon <- -77.93500
firstyear <- 2002
finalyear <- 2023
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
filtered_NC1<- raw_NC1 %>%
    filter(between(salinity, 0, 40) & between(temp, 0, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_NC1$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.10   17.70   22.60   21.91   26.70   35.90

``` r
print(summary(filtered_NC1$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00   14.00   21.00   20.26   26.90   39.80

``` r
#Store our data into a variable name with just the site name. 
NC1 <- filtered_NC1
```

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(NC1, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,45) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for NC1 - Zeke's Basin/Cape Fear River") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()


salplot
```

    ## Warning: Removed 74 rows containing missing values (`geom_line()`).

![](NC1-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(NC1, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for NC1 - Great Bay - Zeke's Basin/Cape Fear River") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

    ## Warning: Removed 74 rows containing missing values (`geom_line()`).

![](NC1-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
NC1_envrmonth <- NC1 %>%
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
print(NC1_envrmonth)
```

    ## # A tibble: 257 × 10
    ## # Groups:   year [23]
    ##     year month min_salinity max_salinity mean_salinity length_salinity min_temp
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>    <dbl>
    ##  1  2002     3         11.6         28.4          23.2            1462      5.7
    ##  2  2002     4         20.5         28.1          23.9            1437     13.6
    ##  3  2002     5         25.2         32.8          28.2            1487     14.9
    ##  4  2002     6         27.6         34            31.9            1439     20.7
    ##  5  2002     7         24.5         33.1          30.8            1488     24  
    ##  6  2002     8         27.3         34.1          31.5            1488     22.7
    ##  7  2002     9         24.8         29            26.7            1440     22.8
    ##  8  2002    10         19.2         30.7          24.8            1488     16.7
    ##  9  2002    11         13.2         27.2          19.8            1440      6.5
    ## 10  2002    12          9.9         26.3          18.5            1344      4.5
    ## # ℹ 247 more rows
    ## # ℹ 3 more variables: max_temp <dbl>, mean_temp <dbl>, length_temp <int>

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
NC1_envryear <- NC1 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity),
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(NC1_envryear)
```

    ## # A tibble: 23 × 7
    ##     year min_salinity max_salinity mean_salinity min_temp max_temp mean_temp
    ##    <dbl>        <dbl>        <dbl>         <dbl>    <dbl>    <dbl>     <dbl>
    ##  1  2002          9.9         34.1          26.0      4.5     34.6      21.9
    ##  2  2003          5.5         25.4          15.8      3.4     39.8      21.0
    ##  3  2004         11.8         29.1          21.8      0.2     34.8      19.4
    ##  4  2005          6.5         28.4          21.3      0       36.6      17.6
    ##  5  2006          4.6         29.1          20.1      2.2     36.8      19.2
    ##  6  2007          0.1         34.9          26.1      0.9     34.8      20.4
    ##  7  2008         11.6         34.5          24.1      0.2     35        20.2
    ##  8  2009          1.2         30.7          22.0      1.1     35        20.0
    ##  9  2010          0.5         35.5          22.6      0       37.3      19.5
    ## 10  2011          7.6         35.9          27.1      0       37.7      20.5
    ## # ℹ 13 more rows

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(NC1_envrmonth, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Timeplot for NC1 - Zeke's Basin/Cape Fear River") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

    ## Warning: Removed 1 rows containing missing values (`geom_point()`).

![](NC1-EnvrData_files/figure-gfm/timeplot-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(NC1$temp)
Mean_max_temperature_C <- mean(NC1_envryear$max_temp)
Mean_min_temperature_C <- mean(NC1_envryear$min_temp)
Temperature_st_dev <- sd(NC1$temp)
Temperature_n <- nrow(NC1)
Temperature_years <- nrow(NC1_envryear)

#Create a data frame to store the temperature results
NC1_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(NC1_temp)
```

    ##      site_name download_date
    ## [1,] "NC1"     "08-16-2023" 
    ##      source_description                                                            
    ## [1,] "NERR Centralized Data. North Carolina - Zeke's Basin/Cape Fear River NOCZBWQ"
    ##      lat       lon       firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "33.9547" "-77.935" "2002"    "2023"    "20.2565155905466"       
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "35.9869565217391"     "1.01739130434783"     "7.46635556377482"
    ##      Temperature_n Temperature_years collection_type
    ## [1,] "620857"      "23"              "continuous"

``` r
# Write to the combined file with all sites 
write.table(NC1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(NC1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/NC1_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(NC1$salinity)
Mean_max_Salinity_ppt <- mean(NC1_envryear$max_salinity)
Mean_min_Salinity_ppt <- mean(NC1_envryear$min_salinity)
Salinity_st_dev <- sd(NC1$salinity)
Salinity_n <- nrow(NC1)
Salinity_years <- nrow(NC1_envryear)


#Create a data frame to store the temperature results
NC1_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(NC1_salinity)
```

    ##      site_name download_date
    ## [1,] "NC1"     "08-16-2023" 
    ##      source_description                                                            
    ## [1,] "NERR Centralized Data. North Carolina - Zeke's Basin/Cape Fear River NOCZBWQ"
    ##      lat       lon       firstyear finalyear Mean_Annual_Salinity_ppt
    ## [1,] "33.9547" "-77.935" "2002"    "2023"    "21.9066780273074"      
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev    Salinity_n
    ## [1,] "31.1695652173913"    "4.67826086956522"    "6.16908774550768" "620857"  
    ##      Salinity_years collection_type
    ## [1,] "23"           "continuous"

``` r
# Write to the combined file with all sites 
write.table(NC1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(NC1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/NC1_salinity.csv")
```
