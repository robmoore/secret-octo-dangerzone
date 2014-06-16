# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each
#      measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. Creates a second, independent tidy data set with the average of each 
#      variable for each activity and each subject. 

# Good to know:
# - Equal number of lines for *_test/train.txt files.
# - 

dataFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataFile <- "./UCI-HAR-Dataset.zip"
dataDir <- "./UCI HAR Dataset/"
testDir <- paste0(dataDir, "test/")
trainDir <- paste0(dataDir, "train/")

# Assume if data directory exists then we have already have what we need here
if (!file.exists(dataDir)) {
  if (!file.exists(dataFile)) { 
    download.file(url=dataFileUrl, destfile=dataFile, method="curl") 
  }
  unzip(dataFile)
}
subjectIdColName <- "subject.id"
activityIdColName <- "activity.id"

# activity_labels.txt: space delimited values id to activity map. join to 
activityLabels <- read.table(paste0(dataDir, "activity_labels.txt"), col.names=c(activityIdColName, "activity.name"))
                         
# features.txt: space delimited values column number to column name. row-to-row match to next file.
features <- read.table(paste0(dataDir, "features.txt"), as.is = TRUE)
#colNames <- features$V2
# Add activity type to colNames

# y_test.txt: the activitiy type ID for each observation
# X_test.txt: the observations
# subject_test.txt: the subject ID for each observation. Not needed.
# TODO: Remove column names? Really not needed.
testSubjectIds <- read.table(paste0(testDir, "subject_test.txt")) #, col.names=c(subjectIdColName))
testActivityIds <- read.table(paste0(testDir, "y_test.txt")) #, col.names=c(activityIdColName))
testData <- read.table(paste0(testDir, "X_test.txt")) #, col.names = colNames)
testObs <- cbind(testData, testSubjectIds, testActivityIds)

# y_train.txt: the activitiy type ID for each observation. row-to-row match to next file.
# X_train.txt: the observations
# subject_train.txt: the subject ID for each observation. Not needed.
# TODO: Remove column names? Really not needed.
trainSubjectIds <- read.table(paste0(trainDir, "subject_train.txt")) #, col.names=c(subjectIdColName))
trainActivityIds <- read.table(paste0(trainDir, "y_train.txt")) #, col.names=c(activityIdColName))
trainData <- read.table(paste0(trainDir, "X_train.txt")) #, col.names = colNames)
trainObs <- cbind(trainData, trainSubjectIds, trainActivityIds)

# rbind the two together to form one data frame
obs <- rbind(testObs, trainObs)

# filter the columns down to only those with std() and mean() in their names and subject.id and activity.id
meanStdColumns <- grep("mean\\(\\)|std\\(\\)", features$V2)
colsOfIterest <- append(meanStdColumns, c(562, 563)) # 562 = subject.id, 562 = activity.id

filteredObs <- obs[,colsOfIterest]
colnames(filteredObs) <- c(features$V2[meanStdColumns], subjectIdColName, activityIdColName)

# Add the activity names to the obs
mergedObs <- merge(activityLabels, filteredObs)

# Creates a second, independent tidy data set with the average of each 
#      variable for each activity and each subject. 
# Average by activity and subject so no duplicate activyt and subject combinations across data

