plot3 <- function() {
    source('init.R')
    data <- get.data.for.dates(as.Date(c('2007-2-1', '2007-2-2')))
    png('plot3.png', height = 504, width = 504)
    plot(data$DateTime, data$Global_active_power,
         type="n", ylab="Energy sub metering", xlab="", ylim=c(0, 38))
    lines(data$DateTime, data$Sub_metering_1)
    lines(data$DateTime, data$Sub_metering_2, col="red")
    lines(data$DateTime, data$Sub_metering_3, col="blue")
    legend('topright', c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
           col=c('black', 'red', 'blue'),
           lwd=1)
    dev.off()
}
plot3()