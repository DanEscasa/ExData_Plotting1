# script to create a histogram of household global minute-averaged active 
# power (in kilowatt)
# downloads and unzips the Household Power Consumption dataset

plot1 <- function () {
     # First make sure I'm in the right directory
     setwd("/home/daniel/Documents/Coursera/EDA.JH/EDA.Plotting01/")
     print(utils::sessionInfo()[2])
     
     library(hms)
     library("data.table")
     library(dplyr)
     
     # Download the zipped dataset if necessary
     if (!file.exists("./exdata_data_household_power_consumption.zip")) {
          message("Downloading dataset")
          download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                        destfile = "./UCI_HAR_Dataset.zip",  
                        method = "internal", 
                        mode = "wb")
     }
     
     # Unzip the dataset if necessary
     if (!file.exists("./household_power_consumption.txt")) {
          message("Extracting dataset")
          unzip("./exdata_data_household_power_consumption.zip", 
                overwrite = FALSE)
     }
     
     consumption <- read.table("household_power_consumption.txt", 
                               stringsAsFactors = FALSE, 
                               header = TRUE,
                               sep    = ";",
                               # “?” are treated as NA
                               na.strings = "?")
     
     # Add a column to combine Date and Time
     # Yes, I'm obsessed with mutate()
     consumption <- consumption %>%
          mutate("dateTime" = as.POSIXct(paste(Date, Time),
                                         tz     = "PST8PDT", 
                                         format = "%d/%m/%Y %H:%M:%S"))
     
     # filter out dates not of interest 
     dataOfInterest <- subset(consumption, 
                              as.Date(dateTime, tz = "PST8PDT") == "2007-02-01" |
                              as.Date(dateTime, tz = "PST8PDT") == "2007-02-02")
     
     # create the histogram 
     png("plot1.png", width = 480, height = 480)
     hist(as.numeric(dataOfInterest$Global_active_power), 
          col    = "red", 
          border = "black", 
          main   = "Global Active Power", 
          xlab   = "Global Active Power (kilowatts)",
          ylab   = "Frequency")
     title(main = "Global Active Power")
     dev.off()
print("Done!")
}

plot1

