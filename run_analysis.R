# load the data table package for reading data
library(data.table)
#load the dplyr package for data frame manipulation
library(dplyr)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists("UCI HAR Dataset")) {
  download.file(fileUrl, destfile = "project_data.zip")
  unzip("project_data.zip")
}

# read all data
features <- fread("./UCI HAR Dataset/features.txt", col.names = c("index", "feature"))
labels <- fread("./UCI HAR Dataset/activity_labels.txt", col.names = c("label", "activity"))
test <- fread("./UCI HAR Dataset/test/X_test.txt", col.names = features$feature)
test_labels <- fread("./UCI HAR Dataset/test/y_test.txt", col.names = "label")
test_subjects <- fread("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
train <- fread("./UCI HAR Dataset/train/X_train.txt", col.names = features$feature)
train_labels <- fread("./UCI HAR Dataset/train/y_train.txt", col.names = "label")
train_subjects <- fread("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

# fliter the features we want: mean and std for each measurement
# make sure to find exactly the mean and std feature, as there are unwanted features with mean/std in it
featuresWantedMean <- grep("-mean\\()", features$feature)
featuresWantedStd <- grep("-std\\()", features$feature)

testWanted <- subset(test, select = c(featuresWantedMean, featuresWantedStd))
testWanted$set = "test"
trainWanted <- subset(train, select = c(featuresWantedMean, featuresWantedStd))
trainWanted$set = "train"

# merge data together into one data set
# add a column named "set" to indicate where the data come from
merged_data <- rbind(trainWanted, testWanted)
merged_labels <- rbind(train_labels, test_labels)
merged_subjects <- rbind(train_subjects, test_subjects)
total <- cbind(merged_subjects, merged_labels, merged_data)

# transform the label to corresponding activity
total <- total %>% inner_join(labels) %>% 
  select(subject, activity, set, contains("mean"), contains("std"))

# modify the column names to be descriptive
names(total) <- gsub("\\W", "", names(total))
names(total) <- sub("^t", "time", names(total))
names(total) <- sub("^f", "freq", names(total))
names(total) <- gsub("std", "STD", names(total))
names(total) <- gsub("mean", "Mean", names(total))
names(total) <- sub("BodyBody", "Body", names(total))
names(total) <- sub("X$", "inXaxis", names(total))
names(total) <- sub("Y$", "inYaxis", names(total))
names(total) <- sub("Z$", "inZaxis", names(total))

# group the data by subject, activity and set
# summaise to get mean for each measurement
new_data <- total %>% group_by(subject, activity, set) %>% summarise_all(funs(mean))

# write the data to a txt file
write.table(new_data, "newData.txt", row.names = FALSE)