
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
- [MVP Google Drive](https://drive.google.com/open?id=1ByD3YWeNVWYFYh6gnrO1oZA8j8Xe-YDT)

# Map

- [NEW MAP WITH COMBINED INFO](https://www.google.com/maps/d/edit?mid=1lgMGFGFNZIHxBEfI2eZBPsmDu_zM06nI&ll=30.31532912127891%2C-85.05581390625001&z=5)
  - One color for salinity only data NONE
  - One color for temperature only data BLUE
  - One color for both salinity and temp data GREEN
  - "P" for whole-genome samples we have ORANGE "P"
  - "C" for sites to collect from based on collaborator info RED "C"
  - See if we can add information on:
    -  general salinity (<15ppt, 15-25, or >25) for the bouy THIS INFO IS IN THE 'TITLE' OF EACH P LOCATION AND UNDER 'SALINITY INFO' FOR EACH C LOCATION (note that data have not been cleaned up for the C locations).
    - website link for buoy DONE
    - use "datasource" as name in map - DONE


- [OLD Map of bouy sites that have salinity data](https://www.google.com/maps/d/viewer?ll=40.33360977259689%2C-78.13703889&z=6&mid=1KSCN-iwrqxIKESxX4FkWQZUVBUPrbAJk)
- [OLD Map of all Wild Populations and their respective environmental data locations](https://www.google.com/maps/d/edit?mid=1-ViurISNSSC9OIeHt1w02nIc-fzWxsrE&usp=sharing) FIX THIS LINK



# What we want to calculate for each dataset

### Apply filters

1. **USGS**: Flags are:  
A Approved for publication, Processing and review completed or   
P Provisional data subject to revision.

2. **NERR** data: [multiple flags](http://cdmo.baruch.sc.edu/data/qaqc.cfm), QC Flags and QC codes are combined; QC may be combined with 1 or more QC codes.  
* We focused on the QC Flags & Codes below - **exclude** and **include** flags/codes are listed below; **NA** were flags/codes not encountered in the datasets that we looked at so far. 

QC Flags

Each parameter in the exported data file contains a flag column. The flag column, F_param, contains a quality control (QC) flag and may contain additional QC codes. In a chart mouse-over, the QAQC flag and any codes are displayed behind the F_param: designation. Refer to the list below for the available QC flags and their descriptions.

| QC Flag | criteria |
|---------|----------|
|-5 Outside high sensor range |**exclude**  |   
|-4 Outside low sensor range |**exclude**  |   
|-3 Data rejected due to QAQC |**exclude**  |   
|-2 Missing data |**exclude**   |
|-1 Optional parameter not collected  | **NA**|
|0 Passed initial QAQC checks |**include**     
|1 Suspect data |**include**     
|2 Reserved for future use |  **NA**|
|3 Calculated data: non-vented depth/level sensor correction for changes in barometric pressure   |  **NA**|
|4 Historical: Pre-auto QAQC |**include**   |  
|5 Corrected data |**include**     |
 
QC Codes by Dataset  
- Water Quality:  

| QC Code | criteria |
|---------|----------|
|General Errors||  
|||
|GIC No instrument deployed due to ice|  **NA**|
|GIM Instrument malfunction| **exclude**   |
| GIT Instrument recording error; recovered telemetry data| **exclude** |
|GMC No instrument deployed due to maintenance/calibration|  **NA**|
|GNF Deployment tube clogged / no flow | **NA**|
|GOW Out of water event  |**NA**|
|GPF Power failure / low battery | **NA**|
|GQR Data rejected due to QAQC checks  |**NA**|
|GSM See metadata| **include**  |
|Corrected Depth/Level Data Codes | **NA**|
|||
|GCC Calculated with data that were corrected during QAQC | **NA**|
|GCM Calculated value could not be determined due to missing data | **NA**|
|GCR Calculated value could not be determined due to rejected data|  **NA**|**NA**|
|GCS Calculated value suspect due to questionable data  |**NA**|
|GCU Calculated value could not be determined due to unavailable data  |**NA**|
|Sensor Errors  ||
|||
|SBO Blocked optic | **NA**|
|SCF Conductivity sensor failure | **NA**|
|SCS Chlorophyll spike | **NA**|
|SDF Depth port frozen | **NA**|
|SDG Suspect due to sensor diagnostics| **NA**|
|SDO DO suspect  |**NA**|
|SDP DO membrane puncture  |**NA**|
|SIC Incorrect calibration / contaminated standard  |**exclude** |
|SNV Negative value  |**include for temp, exclude for sal** |
|SOW Sensor out of water  |**NA**|
|SPC Post calibration out of range  |**exclude** |
|SQR Data rejected due to QAQC checks  |**NA**|
|SSD Sensor drift  |**exclude** |
| SSM Sensor malfunction |**exclude** |
|SSR Sensor removed / not deployed | **NA**|
|STF Catastrophic temperature sensor failure  |**exclude** |
|STS Turbidity spike | **NA**|
|SWM Wiper malfunction / loss|  **NA**|
|Comments  ||
|||
|CAB* Algal bloom  |**NA**|
|CAF Acceptable calibration/accuracy error of sensor  |**NA**|
|CAP Depth sensor in water, affected by atmospheric pressure  |**NA**|
|CBF Biofouling  |  **exclude**    |
|CCU Cause unknown  |  **exclude**   |
|CDA* DO hypoxia (<3 mg/L)  |**NA**|
|CDB* Disturbed bottom  |**NA**|
|CDF Data appear to fit conditions  |**include**    |
|CFK* Fish kill  |**NA**|
|CIP* Surface ice present at sample station | **NA**|
|CLT* Low tide  |**NA**|
|CMC* In field maintenance/cleaning  | **exclude**    |
|CMD* Mud in probe guard  |**NA**|
|CND New deployment begins |  **include**    |
|CRE* Significant rain event  | **include**    |
|CSM* See metadata  |**exclude**     |
|CTS Turbidity spike  |**NA**|
|CVT* Possible vandalism/tampering | **NA**|
|CWD* Data collected at wrong depth | **exclude** |
|CWE* Significant weather event  |**NA**|

*Indicates comments that can be applied to an entire record in the F_Record column.

### Temperature
* Mean_Annual_Temperature_C	: average of all available data
* Mean_max_temperature_C	: average of (maximums for each year)
* Mean_min_temperature_C	: average of (minimums for each year)
* Temperature_st_dev: SD of all available data (if only daily averages are reported separately from mean/max daily this SD could be biased)
* Temperature_n: number of datapoints
* Temperature_years: number of years  
**no longer including the following 3:**
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
