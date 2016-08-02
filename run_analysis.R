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
  unzip(filePath, overwrite = TRUE)
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
outputPathDataSet <- "./data/outputDataSet.csv"
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

#Debugging settings
countLimit <- 100 #-1 for productive case

#Debugging settings


#------------------Read features and activity labels-START--------------------------------

featuresDF <- read.csv(filePathFeatures, sep = " ", header = FALSE, stringsAsFactors = FALSE)
activityLabelsDF <- read.csv(filePathActivityLabels, sep = " ", header = FALSE, stringsAsFactors = FALSE)

#------------------Read features and activity labels-FINISH-------------------------------

#------------------Read training data-START-----------------------------------------------

subjectTrainDF <- read.csv(filePathSubjectTrain, sep = " ", header = FALSE, nrows = countLimit, stringsAsFactors = FALSE)
yTrainDF <- read.csv(filePathYTrain, sep = " ", header = FALSE, nrows = countLimit, stringsAsFactors = FALSE)
xTrainDF <- read.fwf(filePathXTrain, widths = rep(16, times=561), n = countLimit)

#------------------Read training data-FINISH----------------------------------------------

#------------------Read test data-START---------------------------------------------------

subjectTestDF <- read.csv(filePathSubjectTest, sep = " ", header = FALSE, nrows = countLimit, stringsAsFactors = FALSE)
yTestDF <- read.csv(filePathYTest, sep = " ", header = FALSE, nrows = countLimit, stringsAsFactors = FALSE)
xTestDF <- read.fwf(filePathXTest, widths = rep(16, times=561), n = countLimit)

#------------------Read test data-FINISH--------------------------------------------------

#------------------Merge training data-START----------------------------------------------
mergedTrainActivities <- merge(yTrainDF, activityLabelsDF, all.x = TRUE)
mergedTrainDF <- cbind(c(subjectTrainDF, as.data.frame(mergedTrainActivities$V2, stringsAsFactors=FALSE)), xTrainDF, stringsAsFactors=FALSE)
colnames(mergedTrainDF) <- c("subject", "activity", featuresDF$V2)

#------------------Merge training data-FINISH----------------------------------------------

#------------------Merge test data-START---------------------------------------------------

mergedTestActivities <- merge(yTestDF, activityLabelsDF, all.x = TRUE)
mergedTestDF <- cbind(c(subjectTestDF, as.data.frame(mergedTestActivities$V2, stringsAsFactors=FALSE)), xTestDF, stringsAsFactors=FALSE)
colnames(mergedTestDF) <- c("subject", "activity", featuresDF$V2)

#------------------Merge test data-FINISH--------------------------------------------------


#------------------Extract mean() and std() variables-START--------------------------------

mergedTrainMeanStd <- cbind(subject=mergedTrainDF$subject, activity=mergedTrainDF$activity, mergedTrainDF[,grep("-mean\\(\\)", colnames(mergedTrainDF))], mergedTrainDF[,grep("-std()", colnames(mergedTrainDF))], stringsAsFactors=FALSE)
mergedTestMeanStd <- cbind(subject=mergedTestDF$subject, activity=mergedTestDF$activity, mergedTestDF[,grep("-mean\\(\\)", colnames(mergedTestDF))], mergedTestDF[,grep("-std()", colnames(mergedTestDF))], stringsAsFactors=FALSE)

#------------------Extract mean() and std() variables-FINISH--------------------------------

#------------------Combine Train and Test data sets and order them by subjects-START--------

combinedMeanStdDF <- rbind(mergedTrainMeanStd, mergedTestMeanStd, stringsAsFactors = FALSE)
sortedMeanStdDF <- combinedMeanStdDF[order(combinedMeanStdDF$subject),]

#------------------Combine Train and Test data setsand order them by subjects-FINISH--------

#------------------Cleanup unsed variables-START--------------------------------------------

rm("xTestDF", "yTestDF", "xTrainDF", "yTrainDF", "subjectTestDF", "subjectTrainDF", "featuresDF", "activityLabelsDF")
rm("fileURL", "filePathActivityLabels", "filePathFeatures", "filePathSubjectTest", "filePathSubjectTrain", "filePathXTest", "filePathYTest", "filePathXTrain", "filePathYTrain")
rm("mergedTrainActivities", "mergedTestActivities", "mergedTrainDF", "mergedTestDF", "mergedTrainMeanStd", "mergedTestMeanStd")

#------------------Cleanup unsed variables-START--------------------------------------------

#------------------Getting the average of each variable for each activity and each subject--

finalDFMeans <- sortedMeanStdDF %>% group_by(subject, activity) %>% summarise_each(funs(mean))

#------------------Getting the average of each variable for each activity and each subject--

#------------------Cleanup unsed variables-START--------------------------------------------

rm("combinedMeanStdDF", "sortedMeanStdDF")

#------------------Cleanup unsed variables-START--------------------------------------------

write.table(downloadTime, outputPathTimestamp, row.names = FALSE, col.names = FALSE)
write.csv(finalDFMeans, outputPathDataSet)

#print(featuresDF)
#View(finalDFMeans)
#print(head(featuresDF[,2]))
