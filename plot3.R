# Install Package if not already installed
if("data.table" %in% installed.packages() ==FALSE)
{
        install.packages("data.table")
}

library(data.table)

#Download Zp file if not already available and unzip it
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dataFileName <-"household_power_consumption.txt"
zipFile <-"household_power_consumption.zip"

if(!file.exists(dataFileName))
{
        download.file(url,destfile = zipFile)
        unzip(zipfile =  zipFile)
}


#read the data
hpc <- fread(dataFileName, header = T, na.strings = "?", sep = ";")


# Remove unwanted data
hpc$Date<-as.Date(hpc$Date, format = "%d/%m/%Y")
hpc<-subset(hpc, hpc$Date>=as.Date('2007-02-01') & hpc$Date<as.Date('2007-02-03'))

#Convert Date and Time filed to DateTime
str(hpc[hpc$Date<'2007-02-02',])
hpc$DateTime <- as.POSIXct(paste(hpc$Date, hpc$Time, sep = " "), format = "%Y-%m-%d %H:%M:%S")
hpc$Date <-NULL
hpc$Time<-NULL


#Plot 3 - Generate and save it as png
plot(hpc$DateTime, hpc$Sub_metering_1,type="l", ylab = "Energy sub metering", xlab = "")
lines(hpc$DateTime, hpc$Sub_metering_2,col="red")
lines(hpc$DateTime, hpc$Sub_metering_3,col="blue")
#add legend
legend("topright", col = c("black", "red", "blue"), lty=c(1), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.copy(png, 'plot3.png')
dev.off()
