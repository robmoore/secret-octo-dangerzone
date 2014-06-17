dataFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataFile <- "./UCI-HAR-Dataset.zip"
dataDir <- "./UCI HAR Dataset/"
testDir <- paste0(dataDir, "test/")
trainDir <- paste0(dataDir, "train/")

# Assume if data directory exists then we have already have what we need here
if (!file.exists(dataDir)) {
  # Grab the data since we don't have a local copy
  if (!file.exists(dataFile)) { 
    download.file(url=dataFileUrl, destfile=dataFile, method="curl") 
  }
  unzip(dataFile)
}

# Load the subject IDs
testSubjectIds <- read.table(paste0(testDir, "subject_test.txt"))
# Load the activity IDs
testActivityIds <- read.table(paste0(testDir, "y_test.txt"))
# Load the test data
testData <- read.table(paste0(testDir, "X_test.txt"))
# Add the subject and activity IDs to the test data
testObs <- cbind(testData, testSubjectIds, testActivityIds)

# Load the subject IDs
trainSubjectIds <- read.table(paste0(trainDir, "subject_train.txt"))
# Load the activity IDs
trainActivityIds <- read.table(paste0(trainDir, "y_train.txt"))
# Load the training data
trainData <- read.table(paste0(trainDir, "X_train.txt"))
# Add the subject and activity IDs to the training data
trainObs <- cbind(trainData, trainSubjectIds, trainActivityIds)

# Combine the training and test data
obs <- rbind(testObs, trainObs)

# Load list of column labels for our data set.
features <- read.table(paste0(dataDir, "features.txt"), as.is = TRUE)

# Filter the column names down to those containing mean and standard deviation values.
meanStdColumns <- grep("mean\\(\\)|std\\(\\)", features$V2)
# Add the subject ID and activity ID columns to the list.
colsOfIterest <- append(meanStdColumns, c(562, 563)) # 562 = subject.id, 562 = activity.id

# New columns to add to the existing data
subjectIdColName <- "subject.id"
activityIdColName <- "activity.id"

# Filter out the data (columns) that don't contain mean or standard deviation values.
filteredObs <- obs[,colsOfIterest]
# Derive the labels for the column names we want to capture.
meanStdColsLabels <- c(features$V2[meanStdColumns], subjectIdColName, activityIdColName)
# Remove the parens in the column names (e.g., tBodyAcc-mean()-X -> tBodyAcc-mean-X)
#  and set the column names accordingly.
colnames(filteredObs) <- lapply(meanStdColsLabels, function(label) { gsub("\\(\\)", label, replacement="") })

library(data.table)
# Create data table so we can group data efficiently.
filteredObs <- data.table(filteredObs)
# Group the data by activity ID and subject ID and take the mean across all the columns for the group.
# Order the output by activity and subject IDs.
tidyObs <- filteredObs[, lapply(.SD, mean), by=c("activity.id", "subject.id")][order(activity.id, subject.id)]

# Read in the activity labels to provide a description of the activities in the data.
activityLabels <- read.table(paste0(dataDir, "activity_labels.txt"), col.names=c(activityIdColName, "activity.name"))
# Add the activity names to the observations.
tidyObs <- merge(activityLabels, tidyObs)

# Write out the tidy obs to a file
write.csv(tidyObs, file = "combined-HAR-data.csv")
