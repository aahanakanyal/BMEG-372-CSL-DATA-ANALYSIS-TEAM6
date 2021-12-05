

#Code adapted from http://rstudio-pubs-static.s3.amazonaws.com/140202_529bec3c57004e3da55f3df889b59c62.html

library(readxl)
library(dplyr)
library(choroplethr)
library(choroplethrMaps)
library(ggplot2)
library(plotly)

tmp = tempfile()
download.file(url = "http://www.stats.indiana.edu/maptools/county_zips.xls", 
              destfile = tmp)
countyZIP <- read_excel(tmp, sheet = 2, skip = 1)
names(countyZIP) <- c("FIPS", "county", "zip", "percent_zip_in_county")

# filter out a row of NAs at the end and drop the last column
countyZIP <- filter(countyZIP, !is.na(county))
countyZIP <- countyZIP[, -5]

# change class to data.frame
countyZIP <- as.data.frame(countyZIP)

# take a look see
head(countyZIP)
## Source: local data frame [6 x 4]
## 
##    FIPS county   zip percent_zip_in_county
##   (chr)  (chr) (chr)                 (dbl)
## 1   001  Adams 46711             99.999994
## 2   001  Adams 46714              4.910616
## 3   001  Adams 46733             98.199316
## 4   001  Adams 46740             97.094041
## 5   001  Adams 46772             99.999990
## 6   001  Adams 46773              3.629616

#The countyZIP data frame has a record for every zip-county combination. If a zip code straddles two counties, then it will show up twice with the percentage of area in each county recorded in the percent_zip_in_county column. For simplicity I will assign one zip code to one county, based on the highest percent of zip code area.

countyZIP <- group_by(countyZIP, zip)
countyZIP <- filter(countyZIP, percent_zip_in_county == max(percent_zip_in_county))
#Now I’ll grab some income data from the IRS so I have something to plot.
zipcodefirstres<-read_excel("/Users/aahanakanyal/Downloads/ISDH_FirstResponde_Grant_Reporting_Formstack.xlsx") # from https://ubcca-my.sharepoint.com/:x:/r/personal/gabrielle_lam_ubc_ca/_layouts/15/Doc.aspx?sourcedoc=%7B86A0FDFC-6B01-4B62-BD4B-9525B3DF2109%7D&file=ISDH_FirstResponde_Grant_Reporting_Formstack.xlsx&action=default&mobileredirect=true 

zipcodefirstres<-zipcodefirstres[,c(3,5,6,9,10,11,12)]

zipcodefirstres$`Zip Code` <- as.character(zipcodefirstres$`Zip Code`)
countyZIP <- left_join(countyZIP, zipcodefirstres, by = c("zip" = "Zip Code"))

county <- group_by(countyZIP, county) 

county <- summarize(county, value = sum(`Number instances naloxone used`, na.rm = TRUE))
county$county <- tolower(county$county)
data(county.regions)
county.regions <- filter(county.regions, state.name == "indiana")
county <- left_join(county, county.regions, by = c("county" = "county.name"))

county_map <- county_choropleth(county, legend="Number instances naloxone used \n by First Responders from 2016-2020",num_colors = 9,
                                                     state_zoom = "indiana")

#view county map
county_map
#Anotehr way to view county map
county_map + scale_fill_brewer(name = "Number instances requiring one (1) dose", palette = "YlOrRd")
