# BMEG-372-CSL-DATA-ANALYSIS-TEAM6
Multiple Data analysis methdods and software were used for the Communkity Service Learning Project. 
All files were obtained from the drive [BMEG 372 2021W Overdose Lifeline](https://ubcca-my.sharepoint.com/personal/gabrielle_lam_ubc_ca/_layouts/15/onedrive.aspx?originalPath=aHR0cHM6Ly91YmNjYS1teS5zaGFyZXBvaW50LmNvbS86ZjovZy9wZXJzb25hbC9nYWJyaWVsbGVfbGFtX3ViY19jYS9FbkNTLXRmWXF5NUdpVlQwclVCT0VDZ0IxNDNiek8tY3FnVUx1NVppUkRYbFRnP3J0aW1lPWg5aU5IWFNEMlVn&id=%2Fpersonal%2Fgabrielle%5Flam%5Fubc%5Fca%2FDocuments%2FBMEG%20372%202021W%20Overdose%20Lifeline)

The Analysis was divided into 3 key categories: 

1. First Responder data for instances of naloxne use , Overdose deaths and Kits Distribution --> folder County_Heat_Maps  
   (Code adapted from [here](http://rstudio-pubs-static.s3.amazonaws.com/140202_529bec3c57004e3da55f3df889b59c62.html))
   *  deathsincounty.R produces Overdose Deaths Heatmaps (Data Obtained from [Indiana State Department of Health](https://www.in.gov/health/overdose-prevention/data/indiana/))
   * KitDist.R produces Heatmaps of naloxone kits distributed to first reposnders using wordpress forms
   * FirstResponderData.R produces heatmaps of number of instances naloxone was administered to individuals in counties using Formstack Incident Reports. 
   * Microsoft Excel was used for Line graphs in the report using layperson data
 
    Areas of concern were highlighted manually as shown in the report

2. corrplot and random forrest - contains r code used for generating PC data and for classifying the data.
   * random forrest classifier.R - produces all the plots and data seen in the folder. change "file location" seen on lines 1, 70, and 96 to a file name on your computer and remove the # at the start of those lines to obtain the outputs
   * table 1.csv - the classification data for the first responders by counties
   * table 2.csv - the classificaiton data for the first responders by type
   * county prediction.xlsx - used to calculate percent accuracy for the classification of all the counties
   * most of the images were generated using earlier iterations of the code. corr~0.5.png and corr~1.png are examples of what the correlations in corrplot.png.png look like. Rplot.png is the same as corrplot.png, but with coloured numbers instead of coloured circles.
