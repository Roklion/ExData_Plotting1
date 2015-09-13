### R script to reproduce plot 3
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
data$Date_time <- paste(data$Date, data$Time)
data$Date_time <- dmy_hms(data$Date_time)
# Generate Plot 3 in a png file
png(filename = "plot3.png", width = 480, height = 480, bg = "transparent")
par(bg = NA)
# Initialize plot with measurement of sub meter 1
with(data, plot(formula = Sub_metering_1 ~ Date_time,
                type = "S", col = "black",
                xlab = "", ylab = "Energy sub metering"))
# Add line of sub meter 2 & 3
with(data, lines(formula = Sub_metering_2 ~ Date_time,
                 type = "S", col = "red"))
with(data, lines(formula = Sub_metering_3 ~ Date_time,
                 type = "S", col = "blue"))
# Add legend
legend("topright", lty = "solid", col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()