plot1 <- function() {
    # Instructions say
    # "Your code file should include code for reading the data so that the plot can be fully reproduced".
    # and "There should be four PNG files and four R code files, a total of eight files".
    # But a code retrieving dataset, and subsetting a dataset for analysis
    # is common for all four plots, so it's extracted in a separate file 'init.R'.
    source('init.R')
    # get.data.for.dates function is defined in init.R
    data <- get.data.for.dates(as.Date(c('2007-2-1', '2007-2-2')))
    
    png('plot1.png', height = 504, width = 504)
    hist(data$Global_active_power,
         main="Global Active Power",
         xlab="Gloval Active Power (kilowatts)", 
         col="red"    
    )
    dev.off()
    message('plot1.png created')
}
plot1()