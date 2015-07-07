# Load the required packages

library(dplyr)

# Create a directory to host the data set
# If a directory with the same name exist, back it up

if(file.exists("./dataquiz1mod4"))
{
        file.rename("./dataquiz1mod4","./dataquiz1mod4_old")

}

dir.create("./dataquiz1mod4")        

# Download the dataset and unzip it
# remove the downloaded zip file to save space

file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(file_url,"./dataquiz1mod4/dataset.zip",method="libcurl")
unzip("./dataquiz1mod4/dataset.zip",exdir="./dataquiz1mod4")
file.remove("./dataquiz1mod4/dataset.zip")

# Reading data set

power <- read.table(file="./dataquiz1mod4/household_power_consumption.txt", sep=";", header=TRUE, colClasses=c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"),na.strings="?", stringsAsFactors = FALSE)

# Subsetting data for 1/2/2007 and 2/2/2007

power7 <- power[power$Date %in% c("1/2/2007", "2/2/2007"),]

# Generating new column by combining date and time

datetime <- strptime(paste(power7$Date,power7$Time),"%d/%m/%Y %H:%M:%S")

power7 <- cbind(datetime,power7)

# Only take those variable that is related to Sub metering and its datetime
power_sub <- select(power7, datetime, Sub_metering_1,Sub_metering_2,Sub_metering_3)
subm <- melt(power_sub, id="datetime")



png(filename="plot4.png", width=480,height=480)
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
with(power7, plot(x=datetime, y=Global_active_power,  xlab="", ylab="Global Active Power", type="l"))
with(power7, plot(x=datetime, y=Voltage,  xlab="datetime", type="l"))
with(subm, plot(x=datetime, y=value,  xlab="", ylab="Energy sub metering", type="S"))
with(subset(subm, variable == "Sub_metering_1"), lines(datetime, value, col = "black"))
with(subset(subm, variable == "Sub_metering_2"), lines(datetime, value, col = "red"))
with(subset(subm, variable == "Sub_metering_3"), lines(datetime, value, col = "blue"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty = 1, col = c("black", "red", "blue"))
with(power7, plot(x=datetime, y=Global_reactive_power,  xlab="datetime", type="l"))
dev.off()
