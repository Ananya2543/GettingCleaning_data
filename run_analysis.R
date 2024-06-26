# load libraries
library(dplyr) 
setwd("UCI HAR Dataset")

#defining x and y training sets
x_train   <- read.table("./train/X_train.txt")
y_train   <- read.table("./train/Y_train.txt") 
sub_train <- read.table("./train/subject_train.txt")

# read test data 
x_test   <- read.table("./test/X_test.txt")
y_test   <- read.table("./test/Y_test.txt") 
sub_test <- read.table("./test/subject_test.txt")

# read features 
features <- read.table("./features.txt") 

# read activity labels 
activity_labels <- read.table("./activity_labels.txt") 

# merging the x, y and sub data 
x_total   <- rbind(x_train, x_test)
y_total   <- rbind(y_train, y_test) 
sub_total <- rbind(sub_train, sub_test) 

# Filtering to only keep measurements for mean and sd 
sel_features <- variable_names[grep(".*mean\\(\\)|std\\(\\)", features[,2], ignore.case = FALSE),]
x_total <- x_total[,sel_features[,1]]

# setting the new names for columns
colnames(x_total) <- sel_features[,2]
colnames(y_total) <- "activity"
colnames(sub_total) <- "subject"

# merging final data
total <- cbind(sub_total, y_total, x_total)

# converting activities & subjects into factors 
total$activity <- factor(total$activity, levels = activity_labels[,1], labels = activity_labels[,2]) 
total$subject  <- as.factor(total$subject) 

# creating a summarized independent tidy dataset from final dataset 
# contains (average of each variable for each activity and each subject) 
total_mean <- total %>% group_by(activity, subject) %>% summarize_all(funs(mean)) 

# making a new table with summary dataset
setwd("..")
if (!file.exists("tidy_table.txt")){
  file.create("tidy_table.txt")
  write.table(total_mean, file = "tidy", row.names = FALSE, col.names = TRUE)
  }else {
  write.table(total_mean, file = , row.names = FALSE, col.names = TRUE) 
}
