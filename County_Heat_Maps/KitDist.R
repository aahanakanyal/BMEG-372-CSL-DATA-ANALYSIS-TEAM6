
#Code adapted from http://rstudio-pubs-static.s3.amazonaws.com/140202_529bec3c57004e3da55f3df889b59c62.html\library(readxl)
library(dplyr)
library(choroplethr)
library(choroplethrMaps)
library(ggplot2)
library(plotly)
kitdist<-read_excel("/Users/aahanakanyal/Downloads/KitsRequested_County.xlsx") #from https://ubcca-my.sharepoint.com/:x:/r/personal/gabrielle_lam_ubc_ca/_layouts/15/Doc.aspx?sourcedoc=%7BBF0830B5-5274-4094-AD65-3AD3A8981E5D%7D&file=wpforms-10302-Naloxone-Request-2021-10-21-13-35-25.xlsx&action=default&mobileredirect=true
kistsummarised<-read_excel("/Users/aahanakanyal/Downloads/KitDist.xlsx") #excel sheet from https://ubcca-my.sharepoint.com/:x:/r/personal/gabrielle_lam_ubc_ca/_layouts/15/Doc.aspx?sourcedoc=%7BBF0830B5-5274-4094-AD65-3AD3A8981E5D%7D&file=wpforms-10302-Naloxone-Request-2021-10-21-13-35-25.xlsx&action=default&mobileredirect=true with other columns removed

#another way to visualise data
kitdist<-as.data.frame(kitdist)
kitdist<-kitdist[,c(1,2)]
kitdist2<-kitdist%>% group_by(`In what county is your organization located?`)%>% summarise(sum(`How many kits would you like to request?`))
ggplot(data=kistsummarised, aes(x = `County Name`, y = `Kits Requested`))+geom_point()
ggplot(kistsummarised, aes(y = `County Name`, x = `Kits Requested`,fill = ifelse( `Kits Requested`>= 578, "Over 578 Kits Distributed to County", "Less than 578 Kits Distributed to County") , legend("Kits DIstributed"))) + xlab("Number of Kits Requested") + ylab("") + geom_bar(stat = "identity") + scale_fill_discrete(name = "Kit Distribution Requests")



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


kistsummarised$`Zip Code` <- as.character(kistsummarised$`Zip Code`)
countyZIP <- left_join(countyZIP, kistsummarised, by = c("zip" = "Zip Code"))

county <- group_by(countyZIP, county)
county <- summarize(county, value = sum(`Kits Requested`, na.rm = TRUE))
county$county <- tolower(county$county)
data(county.regions)
county.regions <- filter(county.regions, state.name == "indiana")
county <- left_join(county, county.regions, by = c("county" = "county.name"))
county_map <- county_choropleth(county, title ="Number of Kits Requested",num_colors = 9,
                                state_zoom = "indiana")
#view county map
county_map

