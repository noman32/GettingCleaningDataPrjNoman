
###############################################################
###################### Downloading data #######################
###############################################################

library(data.table)
fileurl = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('./UCI_HAR_Dataset_Noman.zip')){
  download.file(fileurl,'./UCI_HAR_Dataset_Noman.zip', mode = 'wb')
  unzip("UCI_HAR_Dataset_Noman.zip", exdir = getwd())
}

#############################################################
######### Reading and converting data #######################
#############################################################

# Reading train data
dtFeatures <- read.csv('./UCI_HAR_Dataset_Noman/features.txt', header = FALSE, sep = ' ')
dtFeatures <- as.character(dtFeatures[,2])

dataTrainX <- read.table('./UCI_HAR_Dataset_Noman/train/X_train.txt')
dataTrainActivity <- read.csv('./UCI_HAR_Dataset_Noman/train/y_train.txt', header = FALSE, sep = ' ')
dataTrainSubject <- read.csv('./UCI_HAR_Dataset_Noman/train/subject_train.txt',header = FALSE, sep = ' ')

# Merging train data
dtTrain <-  data.frame(dataTrainSubject, dataTrainActivity, dataTrainX)
names(dtTrain) <- c(c('subject', 'activity'), dtFeatures)

# Reading test data
dataTestX <- read.table('./UCI_HAR_Dataset_Noman/test/X_test.txt')
dataTestActivity <- read.csv('./UCI_HAR_Dataset_Noman/test/y_test.txt', header = FALSE, sep = ' ')
dataTestSubject <- read.csv('./UCI_HAR_Dataset_Noman/test/subject_test.txt', header = FALSE, sep = ' ')

# Merging test data
dtTest <-  data.frame(dataTestSubject, dataTestActivity, dataTestX)
names(dtTest) <- c(c('subject', 'activity'), dtFeatures)

#############################################################
# Task 01: Merging Training and Testing data sets -> dtMerged
#############################################################

dtMerged <- rbind(dtTrain, dtTest)

####################################################################################################
# Task 02: Extracting only the measurements on the mean and standard deviation for each measurement.
####################################################################################################
mean_std_selected <- grep('mean|std', dtFeatures)
dataSubset <- dtMerged[,c(1,2,mean_std_selected + 2)]

##################################################################################
# Task 03: Using descriptive activity names to name the activities in the data set
##################################################################################

activity_labels <- read.table('./UCI_HAR_Dataset_Noman/activity_labels.txt', header = FALSE)
activity_labels <- as.character(activity_labels[,2])
dataSubset$activity <- activity_labels[dataSubset$activity]

##################################################################################
# Task 04. Appropriately labels the data set with descriptive variable names.
##################################################################################

newNames <- names(dataSubset)
newNames <- gsub("[(][)]", "", newNames)
newNames <- gsub("^t", "TimeDomain_", newNames)
newNames <- gsub("^f", "FrequencyDomain_", newNames)
newNames <- gsub("Acc", "Accelerometer", newNames)
newNames <- gsub("Gyro", "Gyroscope", newNames)
newNames <- gsub("Mag", "Magnitude", newNames)
newNames <- gsub("-mean-", "_Mean_", newNames)
newNames <- gsub("-std-", "_StandardDeviation_", newNames)
newNames <- gsub("-", "_", newNames)
names(dataSubset) <- newNames

#########################################################################################################################################################
# Task 05. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#########################################################################################################################################################

data_tidy <- aggregate(dataSubset[,3:81], by = list(activity = dataSubset$activity, subject = dataSubset$subject),FUN = mean)
write.table(x = data_tidy, file = "data_tidy.txt", row.names = FALSE)

