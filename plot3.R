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

#convert the dates into days and store into a new column called dayfor later use
#data$day <- weekdays(strptime(data$Date,"%d/%m/%Y"))

#graph 3, sub-metering graph
par(mar = c(2,4,2,1))
plot(data$Sub_metering_1, col = "gray", type = "l", ylab = "Energy sub metering", xaxt = "n", xlab = "")
axis(1, at= seq(1, length(data$Sub_metering_1), length.out = 3), labels = c("Thu", "Fri", "Sat"))
lines(data$Sub_metering_2, col= "red", type = "l")
lines(data$Sub_metering_3, col= "blue", type = "l")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("gray", "red", "blue"), lty = 1, box.lty = 0, inset = 0.09, cex = .8, text.font = 3 )
dev.copy(png, file = "plot3.png")
dev.off()

