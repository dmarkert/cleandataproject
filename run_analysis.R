library(dplyr)
library(tidyr)

path.to.data <- file.path(getwd(), "UCI HAR Dataset")
path.to.source <- getwd()

#loading feature names.  using them just for setting up column names for the larger data set
#I took the feature names from features.txt, created my own version called my_feature_names.txt
#and renamed the std and mean columns I'm importing so that they read slighly better.
features.path <- file.path(path.to.source, "my_feature_names.txt")
features <- tbl_df(read.table(features.path, col.names = c("FeatureID", "FeatureName")))
feature.names <- features$FeatureName

#activity label names.  using them later to translate the activity id levels from the y_(text|train).txt file with their readable names.
activity.labels.path <- file.path(path.to.data, "activity_labels.txt")
activity.labels <- tbl_df(read.table(activity.labels.path, col.names = c("ActivityLabelID", "ActivityLabel")))

#loading in test data; setting column names to the ones I created and adding the subject and activity mappings.  
#everthing is in the same row order so even without ids to join on, I can just cbind the column and everything comes out right.
subject.test.path <- file.path(path.to.data, "test", "subject_test.txt")
subject.test <- tbl_df(read.table(subject.test.path, col.names=c("SubjectID")))

test.labels.path <- file.path(path.to.data, "test", "y_test.txt")
test.labels <- tbl_df(read.table(test.labels.path, col.names=c("ActivityLabelID"), colClasses="factor"))

test.data.path <- file.path(path.to.data, "test", "X_test.txt")
test.data <- tbl_df(read.table(test.data.path, col.names=feature.names))
test.data <- cbind(test.data, ActivityLabelID=test.labels$ActivityLabelID)
test.data <- cbind(test.data, Subject=subject.test$SubjectID)

#importing the training data using the sames methods that I did for the test set.
subject.train.path <- file.path(path.to.data, "train", "subject_train.txt")
subject.train <- tbl_df(read.table(subject.train.path, col.names=c("SubjectID")))

train.labels.path <- file.path(path.to.data, "train", "y_train.txt")
train.labels <- tbl_df(read.table(train.labels.path, col.names=c("ActivityLabelID"), colClasses = "factor"))

train.data.path <- file.path(path.to.data, "train", "X_train.txt")
train.data <- tbl_df(read.table(train.data.path, col.names=feature.names))
train.data <- cbind(train.data, ActivityLabelID=train.labels$ActivityLabelID)
train.data <- cbind(train.data, Subject=subject.train$SubjectID)

#merging the test and train datasets together.  The sets use different subjects, so I don't have to worry about 
#collisions.
data <- rbind(test.data, train.data)

#pulling out just the std and mean columns as well as the Subject and ActivityLabelIDs for later use
data <- data[,grep("std|mean[^F]|Subject|ActivityLabelID", colnames(data))]

#renaming the labels from their ID to their associated activity name
levels(data$ActivityLabelID) <- activity.labels$ActivityLabel

#this is step5 of the assignment.  I'm creating an aggregate list of the data grouped by subject and activity and I'm calculating the mean
#of each of the measurements for each group
tidy.data <- aggregate(data, by=list(subject.id=data$Subject, activity.label=data$ActivityLabelID), FUN=mean)

#Removing some columns I don't need anymore.
tidy.data$ActivityLabelID <- NULL
tidy.data$Subject <- NULL

#ordering the data by subject and activity because I like seeing all the data for a subject at once rather than spread out by activity.
tidy.data <- arrange(tidy.data, subject.id, activity.label)


write.table(tidy.data, file.path(path.to.source, "tidy_data.txt"), row.names = F)
