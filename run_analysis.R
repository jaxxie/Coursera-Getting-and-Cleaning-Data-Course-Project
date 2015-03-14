 setwd('/Users/kindaixin/Dropbox-work/Dropbox/coursera/03 Getting and Cleaning Data/Project');

#1. Load the test, training set 
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
xTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")

subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
xTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("./UCI HAR Dataset/test/Y_test.txt")



#2. Merge them into a set
subjectCombined <-rbind(subjectTrain,subjectTest)
xCombinded <- rbind(xTrain,xTest)
yCombinded <- rbind(yTrain,yTest)
library(plyr) 
dataMerged <- cbind(subjectCombined,yCombinded,xCombinded)

#3. Set meaningful column names
features <- read.table("./UCI HAR Dataset/features.txt")
features[,2] <- gsub("-mean[(][)]","Mean",features[,2] )
features[,2] <- gsub("-std[(][)]","StandardDeviation",features[,2] )
colnames(dataMerged) <- c("Subject","ActivityId",as.character(features$V2))

#3. Join with activities label
activities_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activities_labels) <- c("ActivityId","Activity")
dataAll <- merge(dataMerged,activities_labels,by.x="ActivityId",by.y="ActivityId")

#4. Rearrange the columns to display Subject, ActivityId then Activity and finally all features
dataReordered <- dataAll[c(2,1,564,3:563)]

#5. Select only columns(aka features) with mean and stand deviation
colToAdd <- grep("Mean",names(dataReordered))
dataFiltered <- dataReordered[,c(1:3,colToAdd)]

#6. Create average for each activity and each subject
dataMean <- aggregate(dataFiltered, by = list(Activity = dataFiltered$Activity, Subject = dataFiltered$Subject), mean)
  #remove the subjectId and the duplicated Activity columns
dataFinal <- dataMean[c(1:2,6:45)]

#7. write to file
write.table(dataFinal,file="./tidyData.txt",row.names=FALSE)
