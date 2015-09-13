### R script to reproduce plot 4
library(lubridate)

# Read date column ONLY first to find subset of table to read
# ASSUMPTION: "household_power_consumption.txt exists in project home directory
datafile <- "household_power_consumption.txt"
data <- read.table(datafile, header = TRUE, sep = ";",
                   colClasses = c("factor", rep("NULL", 8)))
# Convert into date format and select dates to read
data <- dmy(data[, 1])
date_start <- ymd("2007-02-01")
date_end <- date_start + days(1)
sel_rows <- which(data >= date_start & data <= date_end)
# Read the selected row chunk
# ASSUMPTION: given data is sorted by date and time
colnames <- unlist(read.table(datafile, sep = ";", nrow = 1))
data <- read.table(datafile, header = FALSE, sep = ";",
                   na.strings = "?", col.names = colnames,
                   skip = min(sel_rows),
                   nrows = max(sel_rows) - min(sel_rows) + 1)

# Convert date and time columns to date format
data$datetime <- paste(data$Date, data$Time)
data$datetime <- dmy_hms(data$datetime)
# Generate Plot 4 in a png file
png(filename = "plot4.png", width = 480, height = 480, bg = "transparent")
# Set background to transparent and sub-plots as 2*2
par(mfrow = c(2, 2), bg = NA)
# Plot all four sub-plots in order
with(data, {
    plot(formula = Global_active_power ~ datetime, type = "S", col = "black",
         xlab = "", ylab = "Global Active Power")
    plot(formula = Voltage ~ datetime, type = "S", col = "black")
    plot(formula = Sub_metering_1 ~ datetime, type = "S", col = "black",
         xlab = "", ylab = "Energy sub metering")
    lines(formula = Sub_metering_2 ~ datetime, type = "S", col = "red")
    lines(formula = Sub_metering_3 ~ datetime, type = "S", col = "blue")
    legend("topright", lty = "solid", col = c("black", "red", "blue"),
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
           bty = "n")
    plot(formula = Global_reactive_power ~ datetime, type = "S", col = "black")
})

dev.off()