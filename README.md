
# Information about the data we have

- [old repo, previous analysis done by Erin](https://github.com/MarineEvoEcoLab/OysterGenomeProject/tree/master/popstructureOutliers/data/environment)
- some issues with data used; some issues with not filtering out bad data

- [Google drive for final environmental data by thais](https://drive.google.com/drive/folders/1gsdFaAyLbL1BcN6Ss4fb1TjRDr-K7vaL?usp=sharing)

- Filtered, clean environment data [Site_Envi_Data_QC202011_Thais](https://drive.google.com/drive/folders/1gsdFaAyLbL1BcN6Ss4fb1TjRDr-K7vaL)

- [List of populations and data source for each population](https://docs.google.com/spreadsheets/d/1UPv-Lo2Ak2PhheqoyhA-HvnRhvn80Mdw85bakwYTvFU/edit?pli=1#gid=488191574) 
  - Entered by Thais in Dec 2020 
  - Skip the selection line populations - populations whose name ends in an "S"

- [List of datasources and what filters were applied, data cleaning](https://docs.google.com/spreadsheets/d/1ySYfxii6Z8q7BmNCyhmOYNfLbcpDIpsFER24YW5m08M/edit#gid=1467712745)



## Data we need

TO DO: MAKE A LIST

- [List of range-wide bouys we assessed for salinity data](https://docs.google.com/spreadsheets/d/1Juhol1DScMhPRLlBX7P23sqfddnqQ2pT2KkXKv1yAUk/edit#gid=552433388)

# Map

- [NEW MAP WITH COMBINED INFO](https://www.google.com/maps/d/edit?mid=1lgMGFGFNZIHxBEfI2eZBPsmDu_zM06nI&ll=30.31532912127891%2C-85.05581390625001&z=5)

- [OLD Map of bouy sites that have salinity data]() NEED TO UPDATE LINK
- [OLD Map of all Wild Populations and their respective environmental data locations](https://www.google.com/maps/d/edit?mid=1-ViurISNSSC9OIeHt1w02nIc-fzWxsrE&usp=sharing) FIX THIS LINK

- One color for salinity only data
- One color for temperature only data
- One color for both salinity and temp data
- "P" for whole-genome samples we have
- "C" for sites to collect from based on collaborator info
- See if we can add information on:
  -  general salinity (<15ppt, 15-25, or >25) for the bouy
  - website link for bouy data
  - use "datasource" as name in map

# What we want to calculate for each dataset

### Apply filters

NERR data: 

### Temperature
* Mean_Annual_Temperature_C	: average of all available data
* Mean_max_temperature_C	: average of (maximums for each year)
* Mean_min_temperature_C	: average of (minimums for each year)
* Temperature_st_dev: SD of all available data (if only daily averages are reported separately from mean/max daily this SD could be biased)
* Temperature_n: number of datapoints
* Temperature_years: number of years
*	dd_0: number of days where temp fell below 0
* dd_15: number of days where temp above 15C
* dd_30: number of days where temp above 30C

### Salinity
* Mean_Annual_Salinity_ppt	: average of all available data
* Salinity_st_dev	: SD of all available data (if only daily averages are reported separately from mean/max daily this SD could be biased)
* Mean_min_Salinity_ppt	: average of (minimums for each year)
* Mean_max_Salinity_ppt : average of (maximums for each year)
* Salinity_n: number of datapoints
* Salinity_years: number of years

## The following populations from the resequencing project do not have salinity data:

- NJ_DB_CS_Med_W
- ME_SR_SM_Low_W
- NY_LI_LH_High_W
- NY_LI_CM_High_W
