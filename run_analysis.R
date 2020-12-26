# ******************************************************************
# Author: Junaid Naseer
# Date: 26.12.2020
# Peer-graded Assignment: Getting and Cleaning Data Course Project
# ******************************************************************

# rm(list = ls()) # not good for re-running this script
if(require("dplyr") == FALSE) {
  install.packages("dplyr")
}
library(dplyr)

# ******************************************************************
# Function to download and extract the dataset
# ******************************************************************
get_data <- function() {
  filename <- "dataset.zip"
  if (!file.exists(filename)) {
    download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
                  destfile =  filename,
                  method = "curl")
  }
  dir_name <- "UCI HAR Dataset"
  if (!file.exists(dir_name)) {
    unzip (zipfile = filename)  
  }
  return(dir_name)
}

# ******************************************************************
# merge the test data
# ******************************************************************
tidify_test <- function(dir_name, features_list, activity) {
  subject_test <- read.table(paste(dir_name,"/test/subject_test.txt",sep=""), 
                             col.names = "subject")
  x_test <- read.table(paste(dir_name,"/test/X_test.txt",sep=""), 
                       col.names = features_list$features)
  y_test <- read.table(paste(dir_name,"/test/Y_test.txt",sep = ""), 
                       col.names = "label")
  y_test_label <- left_join(y_test, activity, by = "label")
  
  tidy_test <- cbind(subject_test, y_test_label, x_test)
  tidy_test <- select(tidy_test, -label)
  return(tidy_test)
}

# ******************************************************************
# merge the train data
# ******************************************************************
tidify_train <- function(dir_name, features_list, activity) {
  subject_train <- read.table(paste(dir_name,"/train/subject_train.txt",sep=""), 
                              col.names = "subject")
  x_train <- read.table(paste(dir_name,"/train/X_train.txt",sep = ""), 
                        col.names = features_list$features)
  y_train <- read.table(paste(dir_name,"/train/Y_train.txt",sep=""), 
                        col.names = "label")
  y_train_label <- left_join(y_train, activity, by = "label")
  
  tidy_train <- cbind(subject_train, y_train_label, x_train)
  tidy_train <- select(tidy_train, -label)
  return(tidy_train)
}

# ******************************************************************
# combine the test and the train data
# ******************************************************************
get_tidy_data <- function(tidy_test, tidy_train) {
  tidy_data <- rbind(tidy_test, tidy_train)
  
  mean_and_std<- select(tidy_data, contains("mean"), contains("std"))
  
  mean_and_std$subject <- as.factor(tidy_data$subject)
  mean_and_std$activity <- as.factor(tidy_data$activity)
  
  tidy_data_avg <- mean_and_std%>%
                   group_by(subject, activity) %>%
                   summarise_each(list(mean = mean))
  return(tidy_data_avg)
}

# ******************************************************************
# This function cleans up the global environment.
#
# Remove those object names from this function that you want to keep
# at the end, ( to help with the debugging).
# ******************************************************************
cleanup <- function() {
  rm("tidy_test", "tidy_train", "activity", "features_list",
     envir = sys.frame(-1))
  return("success")
}

# ******************************************************************
# Call the functions
# ******************************************************************
dir_name <- get_data()

features_list <- read.table(paste(dir_name,"/features.txt",sep = ""), 
                            col.names = c("no","features"))
activity <- read.table(paste(dir_name,"/activity_labels.txt",sep=""), 
                       col.names = c("label", "activity"))

if (!exists("tidy_test")) {
  tidy_test <- tidify_test(dir_name, features_list, activity)
}
if (!exists("tidy_train")) {
  tidy_train <- tidify_test(dir_name, features_list, activity)
}
if (!exists("tidy_data_average")) {
  tidy_data_average <- get_tidy_data(tidy_test, tidy_train)
  write.table(tidy_data_average, file="tidy_data.txt", row.names=FALSE, col.names=FALSE)
  cleanup()  
}

# ******************************************************************
# The End
# ******************************************************************
