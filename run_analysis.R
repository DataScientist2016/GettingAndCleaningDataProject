##0.Download the data

##Libraries
library(data.table)
library(dplyr)

##Download file
setwd("D:/User/Olga/Coursera")

if(!file.exists("./gettingdata")){dir.create("./gettingdata")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./gettingdata/Dataset.zip",method="auto")

###Unzip DataSet to /gettingdata directory
unzip(zipfile="./gettingdata/Dataset.zip",exdir="./gettingdata")


##Read metadata
features <- read.table("./gettingdata/UCI HAR Dataset/features.txt", colClasses = c("character"))
activities <- read.table("./gettingdata/UCI HAR Dataset/activity_labels.txt", header = FALSE)

##Read training and test data
subjectTrain <- read.table("./gettingdata/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
actTrain <- read.table("./gettingdata/UCI HAR Dataset/train/y_train.txt", header = FALSE)
dataTrain <- read.table("./gettingdata/UCI HAR Dataset/train/X_train.txt", header = FALSE)
subjectTest <- read.table("./gettingdata/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
actTest <- read.table("./gettingdata/UCI HAR Dataset/test/y_test.txt", header = FALSE)
dataTest <- read.table("./gettingdata/UCI HAR Dataset/test/X_test.txt", header = FALSE)

##1.Merge the training and the test sets to create one data set
##Merge the data
subject <- rbind(subjectTrain, subjectTest)
setnames(subject, "V1", "subject")

activityData <- rbind(actTrain, actTest)
setnames(activityData, "V1", "activityNum")

data <- rbind(dataTrain, dataTest)
setnames(features, names(features), c("featureNum", "featureName"))
colnames(data) <- features$featureName

dataset <- cbind(subject,activityData,activities, data)

setnames(activities, names(activities), c("activityNum","activityName"))

##2.Extract only the measurements on the mean and standard deviation for each measurement
#selecting only the columns that contains means and std

columnsMeanStd <- grep(".*subject.*|.*activityNum.*|.*mean.*|.*std.*", names(dataset), ignore.case=TRUE)
columns <- c(columnsMeanStd, 562, 563)
datasetMeanStd <- dataset[,columns]

##3.Use descriptive activity names to name the activities in the data set

tab <- merge(activities, datasetMeanStd , by="activityNum", all.x=TRUE, sort=FALSE)
tab$activityName <- as.character(tab$activityName)
tab$asubject <- as.character(tab$subject)

##4.Appropriately label the data set with descriptive variable names
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

##5.From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject


tidy <- aggregate(. ~subject + activityName, tab, mean)
tidy <- tidy[order(tidy$subject,tidy$activityName),]
tidy$activityNum = NULL
write.table(tidy, file = "./gettingdata/Tidy.txt", row.names = FALSE)