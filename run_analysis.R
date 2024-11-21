##############################################################################
#
# FILE
#   run_analysis.R
#
# OVERVIEW
#   Using data collected from the Human Activity Recognition Using Smartphones
#   Dataset, process the data and create a tidy data set, outputting the
#   resulting tidy data to a file named "TidyData.txt".
#   See README.md for details.
#
##############################################################################

##############################################################################
# STEP 1 - Set up the working environment - Get data

##############################################################################
library(data.table)

fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileurl, destfile = "G:\\temp\\HARdata.zip", method = "curl")

unzip("G:\\temp\\HARdata.zip")

##############################################################################
# STEP 2 - Merging the training and test sets
##############################################################################

subject_train <- read.table("./train/subject_train.txt", header = FALSE)
names(subject_train)<-"subjectID"
subject_test <- read.table("./test/subject_test.txt", header = FALSE)
names(subject_test)<-"subjectID"

## Reading and labeling the activities 

y_train <- read.table("./train/y_train.txt", header = FALSE)
names(y_train) <- "activity"
y_test <- read.table("./test/y_test.txt", header = FALSE)
names(y_test) <- "activity"

## Reading the function names
FeatureNames<-read.table("features.txt")

## Reading and labeling features  
X_train <- read.table("./train/X_train.txt", header = FALSE)
names(X_train) <- FeatureNames$V2
X_test <- read.table("./test/X_test.txt", header = FALSE)
names(X_test) <- FeatureNames$V2

##############################################################################
# Step 3 - Merge the training and the test sets to create one data set
##############################################################################

train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)

##merging test and train data into "ttdata" data set
ttdata <- rbind(train, test)


## Extracting the columns which have "mean" and "std" in the variable name
meancol<-ttdata[,grep('mean()', names(ttdata), fixed=TRUE)]
stdcol<-ttdata[,grep('std()', names(ttdata), fixed=TRUE)]
keycol<-ttdata[,(1:2)]
meanstd_data<-cbind(keycol,meancol,stdcol)

## Reading the activity labels
actlbl<-read.table("activity_labels.txt")
## Encode activities and adding the labels
ttdata$activity <- factor(ttdata$activity, labels=actlbl$V2)

##############################################################################
# Step 4 - Appropriately label the data set with descriptive variable names
##############################################################################

names(ttdata)<-gsub("tBody","TimeDomainBody",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("tGravity","TimeDomainGravity",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("fBody","FrequencyDomainBody",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("Acc","Acceleration",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("Gyro", "AngularVelocity",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-XYZ","3AxialSignals",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-X","XAxis",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-Y","YAxis",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-Z","ZAxis",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("Mag","MagnitudeSignals",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-mean()","MeanValue",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-std()","StandardDeviation",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-mad()","MedianAbsoluteDeviation ",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-max()","LargestValueInArray",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-min()","SmallestValueInArray",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-sma()","SignalMagnitudeArea",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-energy()","EnergyMeasure",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-iqr()","InterquartileRange ",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-entropy()","SignalEntropy",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-arCoeff()","AutoRegresionCoefficientsWithBurgOrderEqualTo4",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-correlation()","CorrelationCoefficient",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-maxInds()", "IndexOfFrequencyComponentWithLargestMagnitude",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-meanFreq()","WeightedAverageOfFrequencyComponentsForMeanFrequency",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-skewness()","Skewness",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-kurtosis()","Kurtosis",names(ttdata), fixed=TRUE)
names(ttdata)<-gsub("-bandsEnergy()","EnergyOfFrequencyInterval.",names(ttdata), fixed=TRUE)

##############################################################################
# Step 5 - Creating a tidy set. Saving the file tidy.txt 
##############################################################################

DT<-data.table(ttdata)
tidy<-DT[,lapply(.SD,mean),by="activity,subjectID"]
write.table(tidy, file="TidyData.txt", row.name=FALSE, col.names=TRUE)
print ("The script 'run_analysis.R was executed successfully.  As a result, the file TidyData.txt has been saved in the working directory, in folder UCI HAR Dataset.")
rm(list=ls())

