# Readme
Getting and Cleaning Data Course Project

The data retrieving and manipulation(transformation) proceeds automatically. You don't need to set additional parameters. But be aware to properly set the working directory!

Inputs are:
* "./UCI HAR Dataset/features.txt" - list of all features (variable names)
* "./UCI HAR Dataset/activity_labels.txt" - readable activity description like Walking, Laying etc.
* "./UCI HAR Dataset/test/subject_test.txt" - test persons/subjects listed by numbers /for test data
* "./UCI HAR Dataset/test/X_test.txt" - calculated values pro feature(variable) pro obsevation /for test data
* "./UCI HAR Dataset/test/y_test.txt" - list of corresponding activities (coded as numbers) /for test data
* "./UCI HAR Dataset/train/subject_train.txt" - test persons/subjects listed by numbers /for train data
* "./UCI HAR Dataset/train/X_train.txt" - calculated values pro feature(variable) pro obsevation /for train data
* "./UCI HAR Dataset/train/y_train.txt" - list of corresponding activities (coded as numbers) /for train data

Outputs are:
* "./outputSummarizedDataSet_Means.txt" - a csv file with average of each variable for each activity and each subject

Steps are:

1. The RAW-data from the provided URL will be downloaded. The script checks, if the ZIP is already in the "data" folder to prevent unnessesary downloads
* ZIP will be unzipped to the working directory
* Train and test data sets will be proceeded separatelly and put together in the final step
* First, the columns for subjects (subject_train.txt/subject_test.txt) and activities (y_train.txt/y_test.txt) are added to the feature data frames (X_train.txt/X_test.txt)
* Then, the columns are named "subject", "activity" following by 561 names of the features(variables) from features.txt
* After it in the column "activity" the numbers are substituted by the readable activity names (from activity_labels.txt)
* Then in the train and test data sets all columns are removed exept of those with "mean()" and "std()" 
* In the next step the train and test data sets are combined to one data set
* Finally, the second intependent data set with average of each variable for each activity and each subject is created
* The output file will be generated and put into your working directory 
* Afterwards all remaining created variables will be deleted


Enjoy the script and Data Science!

