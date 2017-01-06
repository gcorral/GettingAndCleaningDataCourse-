
require("data.table")
require("reshape2")

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")


# Merge test and train data
X_data <- rbind(X_test, X_train)
y_data <- rbind(y_test, y_train)
subject_data <- rbind(subject_test, subject_train)


# Use descriptive names 
features <- read.table("./UCI HAR Dataset/features.txt")[,2]
names(X_data) <- features
names(subject_data) = "Subject"


# Only mean and std
meanstd_features <- grepl("mean|std", features)
X_data <-  X_data[,meanstd_features]

# Uses descriptive activity names to name the activities
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
y_data[,2] = activity_labels[y_data[,1]]
names(y_data) = c("ActivityID", "Label")

# tiny data set of variables activities and subjects 
data <- cbind(subject_data, y_data, X_data)

# tidy data set with the average of each variable for each activity and each subject.
data_m <- melt(data, id = c("Subject", "ActivityID", "Label"))
data_result <- dcast(data_m, Subject + Label ~ variable, mean)


write.table(data_result, file = "./data.txt")

