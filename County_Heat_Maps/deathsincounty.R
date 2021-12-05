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

zipcodedeath<-read_excel("/Users/aahanakanyal/Downloads/CSL Drug Death Data 2016-2021/DeathCountyChart_data.xlsx") #files obtained from https://www.in.gov/health/overdose-prevention/data/indiana/  
zipcodedeath<-zipcodedeath[!(zipcodedeath$`Death Year`=="2021"),] #to take out 2021 year data
zipcodedeath<-zipcodedeath[,c(1,4,10,11)]
zipcodedeath$`Zip Code` <- as.character(zipcodedeath$`Zip Code`)
countyZIP <- left_join(countyZIP, zipcodedeath, by = c("zip" = "Zip Code"))


county <- group_by(countyZIP, county)
county <- summarize(county, value = sum(DrugTypeDeath, na.rm = TRUE))
county$county <- tolower(county$county)
data(county.regions)
county.regions <- filter(county.regions, state.name == "indiana")
county <- left_join(county, county.regions, by = c("county" = "county.name"))
county_map <- county_choropleth(county, title ="Number of overdose deaths 2016 to 2020",num_colors = 7,
                                state_zoom = "indiana")
#view county map
county_map


