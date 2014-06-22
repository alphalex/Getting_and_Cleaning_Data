library(plyr)

# set working path and dir
path <- "E:/Data Science-JHU/3 Getting and Cleaning Data/Project/UCI HAR Dataset"
setwd(path)

# set related path where filed located
testFolder <- file.path(path, "test")
trainFolder <- file.path(path, "train")
summaryFolder <- file.path(path, "summary")

# create output folder if not existed
if (!file.exists(summaryFolder)) dir.create(summaryFolder)

# read feature file
features <- read.table("features.txt")[,2]

# select measure on the mean and standard deviation
# according to mean() and std()
measure <- grep(".+mean\\(\\)|.+std\\(\\)", features)

# read activity labes
activityLabels=read.table("activity_labels.txt")

# read  subject files
subjectTrain <- read.table(file.path(trainFolder, "subject_train.txt"))
subjectTest  <- read.table(file.path(testFolder,  "subject_test.txt"))

# read training and testing data set
XTrain <- read.table(file.path(trainFolder, 'X_train.txt'))
XTest  <- read.table(file.path(testFolder,  "X_test.txt"))

# select only measures only on the mean and standard deviation columns
XTrain.select <- XTrain[, measure]
XTest.select <- XTest[, measure]

# read training and testing lables
yTrain <- read.table(file.path(trainFolder, 'y_train.txt'))
yTest  <- read.table(file.path(testFolder,  "y_test.txt"))


# merge data sets
x <- rbind(XTrain.select,XTest.select)
y <- rbind(yTrain, yTest)
subject <- rbind(subjectTrain, subjectTest)

masterData <- cbind(subject, y, x)

# rename column names
colnames(masterData) <- c("subject", "activity",as.character(features[measure]))

# summarize masterdata by (activity, subject)
summaryData <- ddply(masterData, .(subject, activity), numcolwise(mean))

# rename activity names
summaryData$activity <- factor(summaryData$activity, labels = activityLabels[,2])

# export summarydata to current working dir as a csv file
write.csv(summaryData,row.names=FALSE, file=file.path(summaryFolder,"summary.csv"))