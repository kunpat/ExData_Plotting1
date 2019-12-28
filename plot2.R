#set the link of the zip file
file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#file to hold the unzipped data
dataFile <- "data.txt"

#if file doesnt exist, download, unzip data to data.txt file 
if (!file.exists(dataFile))
{
        temp <- tempfile()
        download.file(file_url, temp)
        unz(temp, dataFile) 
        unlink(temp)
}

#read in just data column to find the index of interested data 2/1/2007, 2/2/2007 MM/DD/YY
dataColumn <- read.table("data.txt",sep = ";", header = TRUE, colClasses = c("character", rep("NULL", 8)))
dataInterest <- grep(paste("\\b1/2/2007\\b|\\b2/2/2007\\b"), dataColumn$Date)

#now read in data for the specific dates
data <- read.table("data.txt",sep = ";",stringsAsFactors = FALSE, skip = min(dataInterest) - 1, nrows = length(dataInterest), header = TRUE)
header <- read.table("data.txt",stringsAsFactors = FALSE, sep = ";", nrows = 1, header = FALSE)

#label the column names using the header vector
colnames(data) <- header[1,]

#line graph with x axis tick marks labeled by days
plot(data$Global_active_power, xaxt = "n",  type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")
axis(1, at= seq(1, length(data$Global_active_power), length.out = 3), labels = c("Thu", "Fri", "Sat"))
dev.copy(png, file = "plot2.png")
dev.off()