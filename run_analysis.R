## Assigning each data to variables
features <- read.table("C:\\Users\\Dell-pc\\Desktop\\UCI HAR Dataset\\features.txt", col.names = c("n", "functions") )
activities <- read.table("C:\\Users\\Dell-pc\\Desktop\\UCI HAR Dataset\\activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("C:\\Users\\Dell-pc\\Desktop\\UCI HAR Dataset\\test\\subject_test.txt", col.names = c("subject"))
xtest <- read.table("C:\\Users\\Dell-pc\\Desktop\\UCI HAR Dataset\\test\\X_test.txt", col.names = features$functions )
ytest <- read.table("C:\\Users\\Dell-pc\\Desktop\\UCI HAR Dataset\\test\\y_test.txt", col.names = c("code") ) 
subject_train <- read.table("C:\\Users\\Dell-pc\\Desktop\\UCI HAR Dataset\\train\\subject_train.txt", col.names = c("subject") ) 
xtrain <- read.table("C:\\Users\\Dell-pc\\Desktop\\UCI HAR Dataset\\train\\X_train.txt", col.names = features$functions )
ytrain <- read.table("C:\\Users\\Dell-pc\\Desktop\\UCI HAR Dataset\\train\\y_train.txt", col.names = c("code"))


## Merges the training and test sets to create one data set
test_data <- cbind(as.data.table(subject_test), ytest, xtest)

train_data <- cbind(as.data.table(subject_train), xtrain, ytrain)

data = rbind(test_data, train_data) 


## Extracts only the subject, code, and the measurements on the mean and standard deviation for each measurement
TidyData <- data %>% select(subject, code, contains("mean"), contains("std"))

TidyData$code <- activities[TidyData$code, 2]

## Setting the descriptive variable names
names(TidyData)[2] = "activity"
names(TidyData) <- gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData) <- gsub("Gyro" , "Gyroscope", names(TidyData))
names(TidyData) <- gsub("BodyBody", "Body", names(TidyData))
names(TidyData) <- gsub("Mag", "Magnitude", names(TidyData))
names(TidyData) <- gsub("^t", "Time", names(TidyData))
names(TidyData) <- gsub("^f", "Frequency", names(TidyData))
names(TidyData) <- gsub("tbody" , "TimeBody", names(TidyData))
names(TidyData) <- gsub("angle" , "Angle", names(TidyData))
names(TidyData) <- gsub("gravity", "Gravity", names(TidyData))
names(TidyData) <- gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData) <- gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData) <- gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)


## Tidy data set with average of each variable for each activity and each subject 
FinalData <- TidyData %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.names = FALSE)
str(FinalData)

