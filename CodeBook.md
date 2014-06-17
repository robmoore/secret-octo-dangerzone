# Codebook

For specific details regarding the data set used to derive this data set, 
please see the `README.txt` and `features_info.txt` file provided in the [source data 
set](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). 
It provides the background for the study itself as well as an explanation for 
each measurement provided and is not reproduced here.

## Original Data Overview

The data is broken up into test and training data sets which are stored in separate
directories (`test` and `train`, respectively).

The features.txt file provides the column names for the data in each set.

The subject files (`subject_test.txt` and `subject_train.txt`) is of the same size 
as the test data (`X_test.txt` and `X_train.txt`) and contains the subject IDs for
each row of data. Likewise, the activity IDs can be found in the `y_test.txt` and
`y_train.txt` files which also map to each row of the measurement data.

In the top level of the provided data, the `activity_labels.txt` file contains a 
description for each activity and is mapped by activity ID.

The column names for each data set are contained within the `features.txt` file
and map to the column number in the data set itself.

## Processed Data Overview

As instructed, the data for the training and test sets has been combined
into a single set. From the original data, only the mean and standard
deviation columns have been preserved. Whereas the original data set
included duplicate observations for an activity for each subject, this
data set only contains the averages for these measurements.

The original column names have been used with the exception that parentheses
which were used in the original names have been removed. While not strictly
necessary this change was made with a view to assist in processing as
parentheses can prove problematic in rerferences (such as data$column.name).

The activity labels provided in the original data have been added to the
new data set for clarity's sake.
