# run_analysis.R contains a script designed to merge and create a tidy data set
# from data files realted to the course project.

# Load necesesary libraries
library(dplyr)


# Step One: Merge the training and data sets to create one data set.

## Load the data sets text files containing the lables, including the activity and feature labels.
activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features.labels <- read.table("./UCI HAR Dataset/features.txt")

## Read the testing datasets, including x, y, and the subject files.
test.x <- read.table("./UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names=c("Activity"))
test.subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names=c("Subject"))

## Read the training datasets, including x, y, and the subject files.
train.x <- read.table("./UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names=c("Activity"))
train.subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names=c("Subject"))

## Combine the x, y, and subject data for both the testing set and the training set based on binding columns.
test <- cbind(test.subject, test.y, test.x)
train <- cbind(train.subject, train.y, train.x)

## Combine test and train, appending one on the end of the other (binding rows).
full.data <- rbind(test, train)


# Step Two: Extract measurements on mean and standard deviation for each measure.

## Move full.data set to a dplyr data frame to use dplyr functions.
activity.data <- tbl_df(full.data)

## Identify which columns contain 'mean' or 'std' (standard deviation) data by using grp
## to identify which column names includes either of those two pieces of text.
column.list <- grep("mean\\()|std\\()", features.labels$V2, ignore.case = TRUE)
column.names <- grep("mean\\()|std\\()", features.labels$V2, value=TRUE, ignore.case = TRUE)

## Increment column.list by two to add in other columns (activity and subject), then add
## those two names to column.names.
column.list <- column.list + 2
column.list <- c(1, 2, column.list)
column.names <- c("Subject", "Activity", column.names)

## Subset/select columns based on 'mean' and 'std' identifications above.
activity.data <- activity.data[, c(column.list)]


# Step Three: Assign descriptive names to the activities in the data set.

## The data from the prior step will be used to assign those column names onto the data set.
## Use data from prior step to assign those column names to the data frame.
## Need to fist convert all labels to characters
activity.data$Activity <- as.character(activity.data$Activity)
activity.labels$V1 <- as.character(activity.labels$V1)
activity.labels$V2 <- as.character(activity.labels$V2)
for(i in 1:nrow(activity.labels)) {
    activity.data$Activity<-gsub(activity.labels[i,1], activity.labels[i,2], activity.data$Activity)
}


# Step Four: Appropriately label the data set with descriptive varaibel names.

## Column labels were build in a prior step, so assign those to the data frame names.
names(activity.data) <- column.names


# Step Five: Create a second, independant tidy data set using the data set above. This
# tidy data set should include the average of each variable for each activity and each subject.

## Group the data by subject and activity, and then use that set to find the mean of each.
tidy.data <- group_by(activity.data, Subject, Activity) %>% summarise_each(funs(mean))
names(tidy.data) <- column.names

## Write the tidy data set out to a text file named 'tidydate.txt'
write.table(tidy.data, "tidydata.txt", row.name=FALSE)