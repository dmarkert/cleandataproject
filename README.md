# cleandataproject
Coursera Getting and Cleaning Data Final Project

#run_analysis.R documenation
Here are the brief steps I went through to product the submitted tidy data script.  when necessary I will add explanations of decisions I made.  I've also annotated the source code itself if you'd rather read through that.

Steps

1. I first set up pointers to a my data and source code directories.  One of the requirements of the script was that it should be runnable as long as the Samsung data was in the current working directory.  I kept the folder structure of the data as it was given without flattening it because that's not a step anyone running this script should be expected to do.

2. Afterwards, I load up the two reference files included for feature names which tie to variable names used in the data set as well as the activity name lookup table which ties the id of an activity to a more readable name.  For features instead of using features.txt, I created my own version which included more readable names for some of the columns and I used that to populate the column names when loading the datasets later on.

3. The following occurs for both the train and test datasets:
    1. I load up the subject and activity ids for each row in the dataset.  I convert the activity ids to a factor so that I can replace them later on in the script.
    2. Then I load up the dataset containing all of the feature measurements and then use cbind to add in the subject and activity ids for each row in the data.  Because the data, subject, and activity info is all in the same order, I could just call cbind without worrying I was going to be creating data misalignments.

4.  Rbind is then used to merge the test and train datasets.  According to the website where the data is hosted, out of the 30 subjects of the trial, 70% of them were used for the training set and 30% for the test set.  That allowed me to just rbind the dataframes together without worrying about needing to remap subjects to avoid collisions.

5.  I then pulled out just the data I was interested in which included the Subject and ActivityIDs as well as the mean and standard deviation for each signal measured.  

    I only pulled out means and std deviations for the following measurements:
    
    - tBodyAcc-XYZ
    - tGravityAcc-XYZ
    - tBodyAccJerk-XYZ
    - tBodyGyro-XYZ
    - tBodyGyroJerk-XYZ
    - tBodyAccMag
    - tGravityAccMag
    - tBodyAccJerkMag
    - tBodyGyroMag
    - tBodyGyroJerkMag
    - fBodyAcc-XYZ
    - fBodyAccJerk-XYZ
    - fBodyGyro-XYZ
    - fBodyAccMag
    - fBodyAccJerkMag
    - fBodyGyroMag
    - fBodyGyroJerkMag
    
    I left out the meanFrequency as well as
    
    - gravityMean
    - tBodyAccMean
    - tBodyAccJerkMean
    - tBodyGyroMean
    - tBodyGyroJerkMean
    
    I left them out because they weren't plain means or std deviations of the signal measurements but rather more elaborate weighted averages or averages of multiple signals in the window sample which I wasn't interested in.
    
6.  Levels were then replaced with their readable equivalent through factor level replacement.  Because the order of the factors was in the same order as the readable activity names from the dataset, it was easy to replace to levels by using a vector of the activity names.

7.  Then I took the grouped the data by subject and activity and then took the mean of the variables.  I also removed some columns I didn't need and ordered the summarized dataset by Subject and then by Activity so that I could see the summarized data for each subject at once.

8.  I then wrote the tidy dataset to disk.