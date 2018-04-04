### Projection information for NCEP North American Regional Reanalysis: NARR
### is Northern Lambert Conformal Conic grid. 
### Corners of this grid are 12.2N; 
### 133.5W, 54.5N; 
### 152.9W, 57.3N; 49.4W, 
### 14.3N; 65.1W (essentially, North America). 
### The grid resolution is 349x277, which is approximately 0.3 degrees (32km) 
### resolution at the lowest latitude
### more details about the coverage can be found here
### https://www.esrl.noaa.gov/psd/data/gridded/data.narr.monolevel.html




###########################################################################
######first step is to download the data for the year you interested
###### the data for each year usually quite big, around 700 MB, takes time.
###########################################################################

############ First way to download data with your internet browser 
############ and save locally in your working directory.
############ this is the url: ftp://ftp.cdc.noaa.gov/Datasets/NARR/monolevel/
############ or with "download.file"
############ decide which year's data will be downloaded from "1979 - present"
my_year <- 2016  #  year of 2016 is just an example

## link example: ftp://ftp.cdc.noaa.gov/Datasets/NARR/monolevel/hpbl.1979.nc

URL <- paste0("ftp://ftp.cdc.noaa.gov/Datasets/NARR/monolevel/hpbl.",my_year,".nc")
download.file(url = URL, destfile = paste0("hpbl.",my_year,".nc"))


############ second way is automatically grab data online with "data.table" pacakge 
library(data.table)
### decide which year's data will be downloaded from "1979 - present"
my_year <- 2016  #  year of 2016 is just an example
hpbl_2016 <- fread(paste0("ftp://ftp.cdc.noaa.gov/Datasets/NARR/monolevel/hpbl.",my_year,".nc"))

###########################################################################
###### second step is to load the data with package "ncdf4"
###########################################################################

library(ncdf4)
obsdata <- nc_open("hpbl.2016.nc")
print(obsdata) # check that dims are lon-lat-time


library(raster)

r <- brick("hpbl_2016.nc", varname = "hpbl")

############
## here you need to find your location information (the variables "lon" and "lat")
## under Lambert Conformal Conic grid.
## you can load the downloade netCDF file in ArcGIS with the tool "Make NetCDF Raster Layer"
## to find your location information
## the following number "6538325.863, 3108446.503" is an example for my site, you need to revise 
## this spatial location according to your site. 
############

vals <- extract(r, matrix(c(6538325.863 , 3108446.503), ncol = 2))

dim(vals)
head(vals)

write.csv(vals, "hpbl_site.csv")

########### transpose the output table from wide to long

hpbl <- t(read.csv("hpbl_site.csv"))
hpbl <- as.data.frame(hpbl)
head(hpbl)
names(hpbl) 

###### need library "tibble"
hpbl <- tibble::rownames_to_column(hpbl, var = "date_time")

names(hpbl)<- c("date_time", "height")
class(hpbl)

hpbl$date_time <- sub("^X", "", hpbl$date_time) 

hpbl$date_time <- as.POSIXct(hpbl$date_time,  format = "%Y.%m.%d.%H.%M.%S", tz = "UTC")

hpbl <- hpbl[-1,]


hpbl$date_time  <- lubridate::ceiling_date(hpbl$date_time, "30 mins" )


### generate a half-hour time series


half_hour_seq <- seq(
  from=as.POSIXct("2016-01-01 00:00:00","%Y-%m-%d %H:%M:%S", tz="UTC"),
  to=as.POSIXct("2017-01-01 00:00:00", "%Y-%m-%d %H:%M:%S", tz="UTC"),
  by="30 min"
  )

half_hour_seq <- as.data.frame(half_hour_seq)
head(half_hour_seq)
head(hpbl$date_time)

library(dplyr)
library(tidyr)

### join with the hpbl data 
hpbl_1 <- left_join(half_hour_seq, hpbl, by = c("half_hour_seq" = "date_time") )

head(hpbl_1)
tail(hpbl_1)
summary(hpbl_1)

#### interpolate with linear method 
hpbl_1$height <- imputeTS::na.interpolation(hpbl_1$height, option = "linear")

write.csv(hpbl_1, "hpbl_1_interpolated.csv")
saveRDS(hpbl_1, "hpbl_1_interpolated.rds")
#####################

## the extraction for pbhl is done, then you need to join this value to your input dataframe for
## Kljun's model

#########
## work done
## any suggestion or question can be sent to Xiangmin(Sam) Sun at sunxm19@gmail.com
##########
##########
##########