# Introduction

* 1. The program assumes the data from the project has been downloaded into "UCI HAR Dataset" directory
* 2. It cleans the current environment
* 3. Loads the appropriate files from the test and training directories
* 4. Merges the data sets of training and test
* 5. Appropriately names the data subject_test
* 6. Provides descriptive names to each variables of the combined data set
* 7. Find the mean for each variables activity and subject
* 8. Write the mean values into a text file called project_tidy_data_output.txt and is uploaded to this repo

# Main Variables and their Transformations

* All the file names or url to the file names start with "file_"
* All tables loaded will start with the name "table_"
* Filtered Mean and Standard Deviations are stored into selected_x data frame. The rest are loaded into all_y and all_subject
* selected_x, all_y and all_subject gets merged into a single data set as "my_tidy_data_input"
* Used ddply on "my_tidy_data_input" from plyr package to find the Mean and stored into a data frame "mean_by_activity_and_subject"
* File project_tidy_data_output.txt is a dump of "project_tidy_data_output.txt"
