lcs <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "C")

### Use package sqldf for selecting certain rows sql style
### This uses not much memory and the resulting output is small
library(sqldf)
    
hpc <- read.csv.sql(file = "EDA/household_power_consumption.txt", 
                header = T, 
                colClasses = c(rep("character", 2), rep("numeric", 7)), 
                sql = "select * from file where Date = '1/2/2007' OR Date = '2/2/2007'", sep = ";")
    
### write a csv file back, just for convenience. 
write.csv(hpc, file = "EDA/hpc.csv", row.names = FALSE, sep = ",")
    
### read the resulting file and set the columns right for missing values
hpc <- read.csv(file = "EDA/hpc.csv", 
            sep = ",", 
            colClasses = c(rep("character", 2), rep("numeric", 7)), 
            na.strings = "?", 
            blank.lines.skip = TRUE)
    
### convert the 2 date and time columns into 1 datetime column and remove the original Date and Time columns
library(dplyr)
hpc <- mutate(hpc, datetime = as.POSIXct(strptime(paste(Date, Time, sep = " "), "%d/%m/%Y %H:%M:%S"))) %>% 
        select(-one_of(c("Date", "Time")))

# plot1
par(mar = c(4, 4, 2, 2))
png(filename = "EDA/plot1.png", width = 480, height = 480)
hist(hpc$Global_active_power, 
     col = "red", 
     xlab = "Global Active Power (kilowatts)", 
     ylab = "Frequency", 
     main = "Global Active Power")
dev.off()


Sys.setlocale("LC_TIME", lcs)
