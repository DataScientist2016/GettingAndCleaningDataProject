---
title: "CodeBook"
output: html_document
---
Getting and Cleaning Data Course Projectless 

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Create one R script called run_analysis.R that does the following.

    1. Merges the training and the test sets to create one data set.
    2. Extracts only the measurements on the mean and standard deviation for each measurement.
    3. Uses descriptive activity names to name the activities in the data set
    4. Appropriately labels the data set with descriptive variable names.
    5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Review criteria:

    -The submitted data set is tidy.
    -The Github repo contains the required scripts.
    -GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
    -The README that explains the analysis files is clear and understandable.
    -The work submitted for this project is the work of the student who submitted it.
    
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

******************************************************
0.Download the data

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

1.Merge the training and the test sets to create one data set

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

2.Extract only the measurements on the mean and standard deviation for each measurement

selecting only the columns that contains means and std

columnsMeanStd <- grep(".*subject.*|.*activityNum.*|.*mean.*|.*std.*", names(dataset), ignore.case=TRUE)
columns <- c(columnsMeanStd, 562, 563)
datasetMeanStd <- dataset[,columns]

3.Use descriptive activity names to name the activities in the data set

tab <- merge(activities, datasetMeanStd , by="activityNum", all.x=TRUE, sort=FALSE)
tab$activityName <- as.character(tab$activityName)
tab$asubject <- as.character(tab$subject)

4.Appropriately label the data set with descriptive variable names

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

5.From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject

tidy <- aggregate(. ~subject + activityName, tab, mean)
tidy <- tidy[order(tidy$subject,tidy$activityName),]
tidy$activityNum = NULL
write.table(tidy, file = "./gettingdata/Tidy.txt", row.names = FALSE)


***********************
