plot4 <- function() {
    source('init.R')
    data <- get.data.for.dates(as.Date(c('2007-2-1', '2007-2-2')))
    png('plot4.png', height = 504, width = 504)
    
    par(mfrow=c(2, 2))
    
    # top-left
    plot(data$DateTime, data$Global_active_power,
         type="n", ylab="Gloval Active Power (kilowatts)", xlab="")
    lines(data$DateTime, data$Global_active_power)
    
    # top-right
    plot(data$DateTime, data$Voltage,
         type="n", ylab="Voltage", xlab="datetime")
    lines(data$DateTime, data$Voltage)
    
    # bottom-left
    plot(data$DateTime, data$Global_active_power,
         type="n", ylab="Energy sub metering", xlab="", ylim=c(0, 38))
    lines(data$DateTime, data$Sub_metering_1)
    lines(data$DateTime, data$Sub_metering_2, col="red")
    lines(data$DateTime, data$Sub_metering_3, col="blue")
    legend('topright', c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
           col=c('black', 'red', 'blue'),
           lwd=1,
           bty="n")
    
    # bottom-right
    plot(data$DateTime, data$Global_reactive_power,
         type="n", ylab="Global_reactive_power", xlab="datetime")
    lines(data$DateTime, data$Global_reactive_power)
    
    dev.off()
}
plot4()