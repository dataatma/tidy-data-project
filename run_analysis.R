#Step 1. First thing...make sure to download the data into this direcotry and unzip
# Manually download and unzip from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# Though we could download and unizip, I dont think I need to do for this project submission.
#Step 2. Let us clean up the environment 
rm(list=ls())

#Step 3. Load all the required packages, assuming we have already installed using install.packages("plyr")
library(plyr)

#Step 4. Initialize all our directories and files
dir_uci_base <- file.path(getwd(),"tidy-data","UCI\ HAR\ Dataset")
file_features_txt <- file.path(dir_uci_base, "features.txt")
file_activity_labels_txt <- file.path(dir_uci_base, "activity_labels.txt")
file_X_train_txt <- file.path(dir_uci_base, "train","X_train.txt")
file_y_train_txt <- file.path(dir_uci_base, "train","y_train.txt")
file_subject_train_txt <- file.path(dir_uci_base, "train", "subject_train.txt")
file_X_test_txt <- file.path(dir_uci_base,"test","X_test.txt")
file_y_test_txt <- file.path(dir_uci_base,"test", "y_test.txt")
file_subject_test <- file.path(dir_uci_base,"test", "subject_test.txt")

#Step 5. Load all relevant files as data.frame tables
#File has NA values and use colClasses to remove them
table_features <- read.table(file_features_txt, colClasses = c("character"))

table_x_train <- read.table(file_X_train_txt)
table_y_train <- read.table(file_y_train_txt)
table_subject_train <- read.table(file_subject_train_txt)

table_x_test <- read.table(file_X_test_txt)
table_y_test <- read.table(file_y_test_txt)
table_subject_test <- read.table(file_subject_test)

#Step 6. Follow the five assignments

#Assigment 1:Merge the training and the test sets to create one data set.
all_x <- rbind(table_x_train, table_x_test)
all_y <- rbind(table_y_train, table_y_test)
all_subject <- rbind(table_subject_train, table_subject_test)

#Assignment 2: Extract only the measurements on the mean and standard deviation for each measurement.
names_means_stds <- grep("-(mean|std)\\(\\)", table_features[, 2])
selected_x <- all_x[,names_means_stds]

#Assignment 3: Use descriptive activity names to name the activities in the data set

#Missing Names from the file
names(selected_x) <- table_features[names_means_stds, 2]

table_activity_lables <- read.table(file_activity_labels_txt, col.names = c("AcivityId","Activity"))
all_y[, 1] <- table_activity_lables[all_y[, 1], 2]
#Provide correct names to the data fields
names(all_y) <- "Activity"
names(all_subject) <- "Subject"

#Join all the data into a single data set
my_tidy_data_input <- cbind(selected_x, all_y, all_subject)

#Assignment 4: Appropriately label the data set with descriptive variable names.

##Remove () in the names
names(my_tidy_data_input) <- gsub('\\(|\\)',"",names(my_tidy_data_input), perl = TRUE)

##Assign a syntatically valid names out of character vectors.
names(my_tidy_data_input) <- make.names(names(my_tidy_data_input))

names(my_tidy_data_input) <- gsub('^t',"TimeDimension.",names(my_tidy_data_input))
names(my_tidy_data_input) <- gsub('^f',"FrequencyDimension.",names(my_tidy_data_input))

names(my_tidy_data_input) <- gsub('Acc',"Acceleration",names(my_tidy_data_input))
names(my_tidy_data_input) <- gsub('GyroJerk',"AngularAcceleration",names(my_tidy_data_input))
names(my_tidy_data_input) <- gsub('Gyro',"AngularSpeed",names(my_tidy_data_input))
names(my_tidy_data_input) <- gsub('Mag',"Magnitude",names(my_tidy_data_input))

names(my_tidy_data_input) <- gsub('\\.mean',".Mean",names(my_tidy_data_input))
names(my_tidy_data_input) <- gsub('\\.std',".StandardDeviation",names(my_tidy_data_input))

#Assignment 5:Create a second, independent tidy data set with the average of each variable for each activity and each subject.
mean_by_activity_and_subject <- ddply(my_tidy_data_input, c("Subject","Activity"), numcolwise(mean))
##Also write to a file to upload to git repo
write.table(mean_by_activity_and_subject, file = "project_tidy_data_output.txt")
