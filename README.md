# Getting-and-Cleaning-Data-Project
This repo is for the Getting and Cleaning Data Course on Coursera.
The purpose of this project is to collect, work with and clean a data set.

UCI HAR Dataset: 
Human Activity Recognition Using Smartphones Data Set
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

newData.txt:
This is a tidy dataset, which is the output file of R script (run_analysis.R)

codebook.txt:
Breaks down and explains the variables in newData.txt
Please check this file to understand new dataset

run_analysis.R:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the dataset, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
6. Write out the new dataset to newData.txt