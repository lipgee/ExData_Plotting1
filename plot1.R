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

datetime <- strptime(paste(power7$Date,power7$Time),"%d/%m/%Y %H:%M:%S")
power7 <- cbind(datetime,power7)

png(filename="plot1.png", width=480,height=480)
with(power7, hist(Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)",ylab="Frequency"))
dev.off()
