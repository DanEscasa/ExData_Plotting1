plot4 <- function () {
     # First make sure I'm in the right directory
     setwd("/home/daniel/Documents/Coursera/EDA.JH/EDA.Plotting01/")
     print(utils::sessionInfo()[2])
     
     library(hms)
     library(dplyr)
     library("data.table")
     # Download the zipped dataset if necessary
     if (!file.exists("./exdata_data_household_power_consumption.zip")) {
          message("Downloading dataset")
          download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                        destfile = "./UCI_HAR_Dataset.zip",  
                        method   = "internal", 
                        mode     = "wb")
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
                               sep = ";",
                               # “?” are treated as NA
                               na.strings = "?")
     
     # Add a column to combine Date and Time
     # Yes, I'm obsessed with mutate()
     consumption <- consumption %>% 
          mutate("dateTime" = as.POSIXct(paste(Date, Time),
                                         tz     = "PST8PDT", 
                                         format = "%d/%m/%Y %H:%M:%S"))
     
     # filter out dates not of interest
     # as.Date() needed to extract the date part of the column dateTime
     dataOfInterest <- subset(consumption, 
                              as.Date(dateTime, tz = "PST8PDT") == "2007-02-01" |
                              as.Date(dateTime, tz = "PST8PDT") =="2007-02-02")
     
     # create the plots
     png("plot4.png", width = 480, height = 480)
     par(mfrow = c(2, 2))
     with(dataOfInterest, {
          plot(dateTime, Global_active_power, 
               type = "l", xlab = "", ylab = "Global Active Power")
          plot(dateTime, Voltage, 
               type = "l", xlab = "datetime", ylab= "Voltage")
          plot(dateTime, Sub_metering_1, 
               type = "l", xlab = "", ylab = "Energy sub metering")
          lines(dateTime, Sub_metering_2, type = "l", col = "red")
          lines(dateTime, Sub_metering_3, type = "l", col = "blue")
          legend(c("topright"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
                 lty = 1, lwd = 2, col = c("black", "red", "blue"))
          plot(dateTime, Global_reactive_power, 
               type = "l", xlab = "datetime", ylab = "Global_reactive_power")
     })
     dev.off()
}

plot4