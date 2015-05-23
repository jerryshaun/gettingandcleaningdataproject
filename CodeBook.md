---
title: "Course Project"
output: html_document
---

## Getting and Cleaning Data | Coursera


This is a codebook describing the variables, data, and transformations used to clean up the data.


#Data Source

Original data source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Original data source's description of the dataset: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#Data Set Information

The following is provided by the original data source:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


# Data Transformations

The data is processed using the run_analysis.R script, resulting in an output of a tidy data set saved ot a text file.

The transformations:

1. Merge the test and training data, subject ids and activity ids are merged into a single data set. Variables are labeld with the names provided in the features_info.txt and features.txt files.
2. Extract the mean and standard deviaion measures, keeping only those columns.
3. Add the descriptive activity names as a new column.
4. Create a tidy data set and write it out to a text file.


# Tidy data set

Variables

The tidy data set contains :

* Subject - subject identifier indicating who carried out the activity. Ranges from 1 to 30. 
* Activity - an activity label indicating the type of activity: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
* Mean of all other variables measured. This is a numeric value.

The variable name convention is like the following: 

The data set is written to the 'tidydata.txt' file.