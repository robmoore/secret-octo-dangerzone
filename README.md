# "Getting and Cleaning Data" course project

## Overview

The [script](run_analysis.R) script takes the raw UCI HAR data set (saved
locally as `UCI-HAR-Dataset.zip`) and produces a data subset containing the 
average combined data for each subject and activity.

Please see the [code book](CodeBook.md) for more information on the resulting 
data set and the script itself for specifics on how the processing occurs.

## Processing

At a high level, the script performs the following actions as directed
in the assignment:

1. _Merges the training and the test sets to create one data set._
2. _Extracts only the measurements on the mean and standard deviation for each
    measurement._ **Note:** This instruction is interpreted as those columns 
    containing either `mean()` or `std()` as part of their name within
    the provided features.txt document.
3. _Uses descriptive activity names to name the activities in the data set._
    **Note:** This instruction is interpreted as meaning that the 
    activity labels provided in activity_labels.txt file should be added
    as a column along with the activity ID.
4. _Appropriately labels the data set with descriptive variable names._ 
    **Note:** As per #2, this instruction has been interpreted as meaning
    the features.txt values should be used as the column names.
5. _Creates a second, independent tidy data set with the average of each_

For more detail, please see the code and comments within the script.

