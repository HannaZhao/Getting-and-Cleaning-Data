# Getting-and-Cleaning-Data
Getting and Cleaning Data Course Project

The data retrieving and manipulation(transformation) proceeds automatically. 

Inputs are:
* "./data/UCI HAR Dataset/features.txt"
* "./data/UCI HAR Dataset/activity_labels.txt"
* "./data/UCI HAR Dataset/test/subject_test.txt"
* "./data/UCI HAR Dataset/test/X_test.txt"
* "./data/UCI HAR Dataset/test/y_test.txt"
* "./data/UCI HAR Dataset/train/subject_train.txt"
* "./data/UCI HAR Dataset/train/X_train.txt"
* "./data/UCI HAR Dataset/train/y_train.txt"

Outputs are:
* "./data/outputSummarizedDataSet_Raw.csv" - a csv file with combined train-test data set, only mean() and std() variables of measurements
* "./data/outputSummarizedDataSet_Means.csv" - a csv file with average of each variable for each activity and each subject
* "./data/outputSummarizedDataSet_Means.csv"
* "./data/Timestamp_Course_Project.txt" - Timestamp of download time
* outputMeanStdDF - data frame with combined train-test data set, only mean() and std() variables of measurements
* outputSummarizedDFMeans - data frame with average of each variable for each activity and each subject

Steps are:

1. The script run_analysis.R checks if the folder "data" is in the working directory. If not, the folder will be created
2. The RAW-data from the provided URL will be downloaded. The script checks, if the ZIP is already in the "data" folder to prevent unnessesary downloads
