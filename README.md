---
title: "Course Project"
output: html_document
---

## Getting and Cleaning Data | Coursera


This is a read me file describing the run_analysis.R script.


# Instructions for the course project.

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example  this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!

# Loading the data

Load the dplyr library, used later to manipulate the data frame.

```{r}
library(dplyr)
```

# Step One: Merge the training and data sets to create one data set.

Load the data sets text files containing the lables, including the activity and feature labels.

```{r}
activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features.labels <- read.table("./UCI HAR Dataset/features.txt")
```

Read the testing datasets, including x, y, and the subject files.

```{r}
test.x <- read.table("./UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names=c("Activity"))
test.subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names=c("Subject"))
```

Read the training datasets, including x, y, and the subject files.
```{r}
train.x <- read.table("./UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names=c("Activity"))
train.subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names=c("Subject"))
```

Combine the x, y, and subject data for both the testing set and the training set based on binding columns.
```{r}
test <- cbind(test.subject, test.y, test.x)
train <- cbind(train.subject, train.y, train.x)
```

Combine test and train, appending one on the end of the other (binding rows).
```{r}
full.data <- rbind(test, train)
```

#Step Two: Extract measurements on mean and standard deviation for each measure.

Move full.data set to a dplyr data frame to use dplyr functions.
```{r}
activity.data <- tbl_df(full.data)
```

Identify which columns contain 'mean' or 'std' (standard deviation) data by using grp to identify which column names includes either of those two pieces of text.
```{r}
column.list <- grep("mean\\()|std\\()", features.labels$V2, ignore.case = TRUE)
column.names <- grep("mean\\()|std\\()", features.labels$V2, value=TRUE, ignore.case = TRUE)
```

Increment column.list by two to add in other columns (activity and subject), then add those two names to column.names.
```{r}
column.list <- column.list + 2
column.list <- c(1, 2, column.list)
column.names <- c("Subject", "Activity", column.names)
```

Subset/select columns based on 'mean' and 'std' identifications above.
```{r}
activity.data <- activity.data[, c(column.list)]
```

#Step Three: Assign descriptive names to the activities in the data set.

The data from the prior step will be used to assign those column names onto the data set.

Use data from prior step to assign those column names to the data frame.
Need to fist convert all labels to characters
```{r}
activity.data$Activity <- as.character(activity.data$Activity)
activity.labels$V1 <- as.character(activity.labels$V1)
activity.labels$V2 <- as.character(activity.labels$V2)
for(i in 1:nrow(activity.labels)) {
    activity.data$Activity<-gsub(activity.labels[i,1], activity.labels[i,2], activity.data$Activity)
}
```

#Step Four: Appropriately label the data set with descriptive varaibel names.

Column labels were build in a prior step, so assign those to the data frame names.
```{r}
names(activity.data) <- column.names
```

#Step Five: Create a second, independant tidy data set using the data set above.

This tidy data set should include the average of each variable for each activity and each subject.

Group the data by subject and activity, and then use that set to find the mean of each.
```{r}
tidy.data <- group_by(activity.data, Subject, Activity) %>% summarise_each(funs(mean))
names(tidy.data) <- column.names
```

Write the tidy data set out to a text file named 'tidydate.txt'
```{r}
write.table(tidy.data, "tidydata.txt", row.name=FALSE)
```