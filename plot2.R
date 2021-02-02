plot2 <- function () {
     # First make sure I'm in the right directory
     setwd("/home/daniel/Documents/Coursera/EDA.JH/EDA.Plotting01/")
     print(utils::sessionInfo()[2])
     
     # load the hms library for proper handling of the Time column
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
                               sep =";",
                               # “?” are treated as NA
                               na.strings = "?")
     
     # convert the columns to the appropriate type.
     # Yes, I'm obsessed with mutate()
     consumption <- consumption %>% 
          mutate("Global_active_power"   = as.numeric(Global_active_power),
                 "Global_reactive_power" = as.numeric(Global_reactive_power),
                 "Voltage"               = as.numeric(Voltage),
                 "Global_intensity"      = as.numeric(Global_intensity),
                 "Sub_metering_1"        = as.numeric(Sub_metering_1),
                 "Sub_metering_2"        = as.numeric(Sub_metering_2),
                 "Sub_metering_3"        = as.numeric(Sub_metering_3),
                 "dateTime"              = as.POSIXct(paste(Date, Time),
                                                      tz     = "PST8PDT", 
                                                      format = "%d/%m/%Y %H:%M:%S"))

     # filter out dates not of interest
     # as.Date() needed to extract the date part of the column dateTime
     dataOfInterest <- subset(consumption, 
                              as.Date(dateTime, tz = "PST8PDT") == "2007-02-01" |
                              as.Date(dateTime, tz = "PST8PDT") =="2007-02-02")
     
     # create the plot 
     png("plot2.png", width=480, height=480)
     with(dataOfInterest, {
          plot(x    = dateTime,
               y    = Global_active_power,
               xlab = "",
               ylab = "Global Active Power (kilowatts)",
               type = "l")
          })
     dev.off()
     print("Done!")
}

plot2
