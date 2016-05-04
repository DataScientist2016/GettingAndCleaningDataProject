---
title: "CodeBook"
output: html_document
---
Getting and Cleaning Data Course Project
======================================
****************************************************
Description of the DATA:
Human Activity Recognition Using Smartphones Dataset

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The data
--------

The dataset includes the following files:

    'README.txt'

    'features_info.txt': Shows information about the variables used on the feature vector.

    'features.txt': List of all features.

    'activity_labels.txt': Links the class labels with their activity name.

    'train/X_train.txt': Training set.

    'train/y_train.txt': Training labels.

    'test/X_test.txt': Test set.

    'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent.

    'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

    'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.

    'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration.

    'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

******************************************************

0. Download the data
======================================

Libraries

library(data.table)
library(dplyr)

Download file

setwd("D:/User/Olga/Coursera")

if(!file.exists("./gettingdata")){dir.create("./gettingdata")}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl,destfile="./gettingdata/Dataset.zip",method="auto")

Unzip DataSet to /gettingdata directory

unzip(zipfile="./gettingdata/Dataset.zip",exdir="./gettingdata")


Read metadata

features <- read.table("./gettingdata/UCI HAR Dataset/features.txt", colClasses = c("character"))

activities <- read.table("./gettingdata/UCI HAR Dataset/activity_labels.txt", header = FALSE)

Read training and test data

subjectTrain <- read.table("./gettingdata/UCI HAR Dataset/train/subject_train.txt", header = FALSE)

actTrain <- read.table("./gettingdata/UCI HAR Dataset/train/y_train.txt", header = FALSE)

dataTrain <- read.table("./gettingdata/UCI HAR Dataset/train/X_train.txt", header = FALSE)

subjectTest <- read.table("./gettingdata/UCI HAR Dataset/test/subject_test.txt", header = FALSE)

actTest <- read.table("./gettingdata/UCI HAR Dataset/test/y_test.txt", header = FALSE)

dataTest <- read.table("./gettingdata/UCI HAR Dataset/test/X_test.txt", header = FALSE)

1. Merge the training and the test sets to create one data set
--------------------------------------------------------------

Merge the data

subject <- rbind(subjectTrain, subjectTest)

setnames(subject, "V1", "subject")

activityData <- rbind(actTrain, actTest)

setnames(activityData, "V1", "activityNum")

data <- rbind(dataTrain, dataTest)

setnames(features, names(features), c("featureNum", "featureName"))

colnames(data) <- features$featureName

dataset <- cbind(subject,activityData,activities, data)

setnames(activities, names(activities), c("activityNum","activityName"))

2. Extract only the measurements on the mean and standard deviation for each measurement
---------------------------------------------------------------------------------------

selecting only the columns that contains means and std

columnsMeanStd <- grep(".*subject.*|.*activityNum.*|.*mean.*|.*std.*", names(dataset), ignore.case=TRUE)

columns <- c(columnsMeanStd, 562, 563)

datasetMeanStd <- dataset[,columns]

3. Use descriptive activity names to name the activities in the data set
------------------------------------------------------------------------

tab <- merge(activities, datasetMeanStd , by="activityNum", all.x=TRUE, sort=FALSE)

tab$activityName <- as.character(tab$activityName)

tab$asubject <- as.character(tab$subject)

4. Appropriately label the data set with descriptive variable names
------------------------------------------------------------------

names(tab)<-gsub("Acc", "Accelerometer", names(tab))

names(tab)<-gsub("angle", "Angle", names(tab))

names(tab)<-gsub("BodyBody", "Body", names(tab))

names(tab)<-gsub("Gyro", "Gyroscope", names(tab))

names(tab)<-gsub("Mag", "Magnitude", names(tab))

names(tab)<-gsub("^t", "Time", names(tab))

names(tab)<-gsub("^f", "Frequency", names(tab))

names(tab)<-gsub("tBody", "TimeBody", names(tab))

names(tab)<-gsub("-mean()", "Mean", names(tab), ignore.case = TRUE)

names(tab)<-gsub("-std()", "STD", names(tab), ignore.case = TRUE)

names(tab)<-gsub("-freq()", "Frequency", names(tab), ignore.case = TRUE)

names(tab)<-gsub("gravity", "Gravity", names(tab))

5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject

tidy <- aggregate(. ~subject + activityName, tab, mean)

tidy <- tidy[order(tidy$subject,tidy$activityName),]

tidy$activityNum = NULL

write.table(tidy, file = "./gettingdata/Tidy.txt", row.names = FALSE)


***********************
