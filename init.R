prepare.dataset <- function() {
    if (!file.exists('data')) {
        dir.create('data')
    }
    dataset.file.path <- file.path('data', 'household_power_consumption.txt')
    if (!file.exists(dataset.file.path)) {
        dataset.zip.path <- file.path('data', 'household_power_consumption.zip')
        if (!file.exists(dataset.zip.path )) {
            message('Downloading dataset zip file...')
            download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip',
                          dataset.zip.path,
                          method = 'curl')
            message('Dataset zip file downloaded.')
        }
        else {
            message('Dataset archive exists.')
        }
        unzip(dataset.zip.path, exdir = 'data')
        message('Dataset file is extracted.')
    }
    else {
        message('Dataset file exists.')
    }
}

ensure.libraries <- function() {
    missing.packages <- setdiff(c("sqldf", "memoise"), installed.packages()[,1])
    if (length(missing.packages) > 0) {
        prompt <- paste("The following packages are missing, yet required to run this code: ",
                        "\n",
                        paste(missing.packages, collapse = ", "),
                        "\n Would you like to install them now?(y/n)")
        answer <- ''
        while (!(answer %in% c('y', 'n'))) {
            answer <- readline(prompt = prompt)
            if (answer == 'n') {
                stop('Cannot proceed without those packages.')
            }
        }
        install.packages(missing.packages)
        message("Installed all missing packages.")
    }
    library("sqldf")
}
ensure.libraries()

ensure.column.types <- function(data) {
    data$DateTime <- strptime(paste(data$Date, data$Time), format="%d/%m/%Y %H:%M:%S")
    data$Time <- strptime(data$Time, format="%H:%M:%S")
    data$Date <- sapply(data$Date, as.Date, format="%d/%m/%Y")
    data
}

get.data.for.dates <- function(dates) {
    prepare.dataset()
    message('Retrieving data from dataset...')
    dataset.file.path <- file.path('data', 'household_power_consumption.txt')
    dates.str <- sapply(dates, function(d) {
        paste("'", gsub('0(\\d/)', '\\1', format(d, "%d/%m/%Y"), perl=TRUE), "'", sep="")
    })
    file.sql <- paste("select * from file where Date in (", paste(dates.str, collapse=", "), ")")
    data <- read.csv.sql(dataset.file.path, sql = file.sql, header=TRUE, sep=";")
    message('Data retrieved')
    ensure.column.types(data)
}

get.data.for.dates2 <- function(dates) {
    prepare.dataset()
    dataset.file.path <- file.path('data', 'household_power_consumption.txt')
    data.all <- fread(dataset.file.path, na.strings="?")
    dates.str <- sapply(dates, gsub('0(\\d/)', '\\1', format(d, "%d/%m/%Y"), perl=TRUE))
    data <- data.all[Date %in% dates.str, ]
    ensure.column.types (data)
}

# dates - vector of dates for which we want to retrieve data
get.data.for.dates3 <- function(dates) {
    prepare.dataset()
    dataset.file.path <- file.path('data', 'household_power_consumption.txt')
    con <- file(dataset.file.path, open = 'r')
    
    data <- NULL
    header <- strsplit(readLines(con, n=1), ";")[[1]]
    seen.dates = c()
    dates.to.see <- length(dates)
    previous.date.str <- NULL
    while (length(one.line <- readLines(con, n=1)) > 0) {
        fields = strsplit(one.line, ";")[[1]]
        date.str = fields[1]
        date <- as.Date(fields[1], format='%d/%m/%Y')
        if (date %in% dates) {
            # record data for requested dates
            if (is.null(data)) {
                fields.list <- as.list(fields)
                names(fields.list) <- header
                data <- rbindlist(list(fields.list))
            }
            else {
                data <- rbindlist(list(data, as.list(fields)))
            }
            
            # remember what dates we already seen - to stop after we collect all dates,
            # and not to read file till the end
            if (!(date.str %in% seen.dates)) {
                seen.dates <- c(seen.dates, date.str)
                dates.to.see <- dates.to.see - 1
            }
        }
        else if (dates.to.see == 0) {
            break
        }
    }
    close(con)
    ensure.column.types (data)
}