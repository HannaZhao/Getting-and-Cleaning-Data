downloadAndUnzip <- function (url, path) {
  fileURL <- url
  filePath <- path
  # create "data" directory in working directory if not exists
  if(!dir.exists("./data")){
    dir.create("./data")
  }
  #Downloads Zip if not already done
  if(!file.exists(filePath)){
    download.file(fileURL, filePath, method = "curl")
  }
  unzip(filePath, exdir = "./data", overwrite = TRUE)
}

pkgTest <- function(packageName)
{
  if (!require(packageName,character.only = TRUE))
  {
    install.packages(packageName,dep=TRUE)
    if(!require(packageName,character.only = TRUE)) stop("Package not found")
  }
}

#------------------Download and Unzip data set-START-------------------------------------

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
archivePath <- "./data/UCIDataset.zip"
outputPathDataSetMeans <- "./data/outputSummarizedDataSet_Means.csv"
outputPathDataSetRaw <- "./data/outputSummarizedDataSet_Raw.csv"
outputPathTimestamp <- "./data/Timestamp_Course_Project.txt"

downloadAndUnzip(fileURL, archivePath)
downloadTime <- date()

#------------------Download and Unzip data set-FINISH-------------------------------------

pkgTest("dplyr")
library(dplyr)

#------------------Set paths-START--------------------------------------------------------

filePathFeatures <- "./data/UCI HAR Dataset/features.txt"
filePathActivityLabels <- "./data/UCI HAR Dataset/activity_labels.txt"
filePathSubjectTest <- "./data/UCI HAR Dataset/test/subject_test.txt"
filePathXTest <- "./data/UCI HAR Dataset/test/X_test.txt"
filePathYTest <- "./data/UCI HAR Dataset/test/y_test.txt"
filePathSubjectTrain <- "./data/UCI HAR Dataset/train/subject_train.txt"
filePathXTrain <- "./data/UCI HAR Dataset/train/X_train.txt"
filePathYTrain <- "./data/UCI HAR Dataset/train/y_train.txt"

#------------------Set paths-FINISH-------------------------------------------------------



#------------------Read features and activity labels-START--------------------------------

featuresDF <- read.table(filePathFeatures,  stringsAsFactors = FALSE)
activityLabelsDF <- read.table(filePathActivityLabels,  stringsAsFactors = FALSE)

#------------------Read features and activity labels-FINISH-------------------------------

#------------------Read training data-START-----------------------------------------------

subjectTrainDF <- read.table(filePathSubjectTrain, stringsAsFactors = FALSE)
yTrainDF <- read.table(filePathYTrain, stringsAsFactors = FALSE)
xTrainDF <- read.table(filePathXTrain, stringsAsFactors = FALSE)

#------------------Read training data-FINISH----------------------------------------------

#------------------Read test data-START---------------------------------------------------

subjectTestDF <- read.table(filePathSubjectTest, stringsAsFactors = FALSE)
yTestDF <- read.table(filePathYTest, stringsAsFactors = FALSE)
xTestDF <- read.table(filePathXTest, stringsAsFactors = FALSE)

#------------------Read test data-FINISH--------------------------------------------------

#------------------Merge training data-START----------------------------------------------

mergedTrainDF <- cbind(subjectTrainDF, yTrainDF, xTrainDF, stringsAsFactors=FALSE)
colnames(mergedTrainDF) <- c("subject", "activity", featuresDF$V2)
mergedTrainDF$activity <- factor(mergedTrainDF$activity, labels = activityLabelsDF$V2)

#------------------Merge training data-FINISH----------------------------------------------

#------------------Merge test data-START---------------------------------------------------

mergedTestDF <- cbind(subjectTestDF, yTestDF, xTestDF, stringsAsFactors=FALSE)
colnames(mergedTestDF) <- c("subject", "activity", featuresDF$V2)
mergedTestDF$activity <- factor(mergedTestDF$activity, labels = activityLabelsDF$V2)

#------------------Merge test data-FINISH--------------------------------------------------


#------------------Extract mean() and std() variables-START--------------------------------

mergedTrainMeanStd <- cbind(subject=mergedTrainDF$subject, activity=mergedTrainDF$activity, mergedTrainDF[,grep("mean\\(\\)", colnames(mergedTrainDF))], mergedTrainDF[,grep("std()", colnames(mergedTrainDF))], stringsAsFactors=FALSE)
mergedTestMeanStd <- cbind(subject=mergedTestDF$subject, activity=mergedTestDF$activity, mergedTestDF[,grep("mean\\(\\)", colnames(mergedTestDF))], mergedTestDF[,grep("std()", colnames(mergedTestDF))], stringsAsFactors=FALSE)

#------------------Extract mean() and std() variables-FINISH--------------------------------

#------------------Combine Train and Test data sets and order them by subjects-START--------

unpreparedMeanStdDF <- rbind(mergedTrainMeanStd, mergedTestMeanStd, stringsAsFactors = FALSE)
outputMeanStdDF <- unpreparedMeanStdDF[order(unpreparedMeanStdDF$subject),]

#------------------Combine Train and Test data setsand order them by subjects-FINISH--------

#------------------Getting the average of each variable for each activity and each subject--

outputSummarizedDFMeans <- outputMeanStdDF %>% group_by(subject, activity) %>% summarize_each(c("mean"))

#------------------Getting the average of each variable for each activity and each subject--

#------------------Cleanup unsed variables-START--------------------------------------------

rm("xTestDF", "yTestDF", "xTrainDF", "yTrainDF", "subjectTestDF", "subjectTrainDF", "featuresDF", "activityLabelsDF")
rm("fileURL", "filePathActivityLabels", "filePathFeatures", "filePathSubjectTest", "filePathSubjectTrain", "filePathXTest", "filePathYTest", "filePathXTrain", "filePathYTrain")
rm("mergedTrainActivities", "mergedTestActivities", "mergedTrainDF", "mergedTestDF", "mergedTrainMeanStd", "mergedTestMeanStd", "unpreparedMeanStdDF")

#------------------Cleanup unsed variables-START--------------------------------------------


write.table(downloadTime, outputPathTimestamp, row.names = FALSE, col.names = FALSE)
write.csv(outputSummarizedDFMeans, outputPathDataSetMeans)
write.csv(outputMeanStdDF, outputPathDataSetRaw)

