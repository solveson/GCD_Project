# R Script for Course Project: Getting and Cleaning Data
# February 2015, KD Solveson

# Before running this script ensure that the "UCI HAR Dataset" has been
#   unzipped into the R working directory.
# Then, start this script from the R working directory.


# Load libraries used in this script
library(reshape2)       ## melt
library(data.table)     ## data.table
library(plyr)           ## ddply


### 1. Merge training and test data into one data set.

# Change into the test directory
setwd("UCI HAR Dataset/test")

# Read test data files
fv <- read.table("X_test.txt")         ## Feature Values
s  <- read.table("subject_test.txt")   ## Subject
a  <- read.table("y_test.txt")         ## Activity (walk, lay, etc.)

# Name subject and activity vector fields
names(s) <- "subject"
names(a) <- "a_id"

# Create data type label (test or train)
t <- data.frame(type=rep("test", dim(s)[1]))

# Combine all test data into a data frame
#   Note the order of concatenation:  561 features, 1 subject
#   1 activity, and 1 type.
test <- data.frame(cbind(fv,s,a,t))


# Change into the train directory
setwd("../train")

# Read train data files
fv <- read.table("X_train.txt")         ## Feature Values
s  <- read.table("subject_train.txt")   ## Subject
a  <- read.table("y_train.txt")         ## Activity (walk, lay, etc.)

# Name subject and activity vector fields
names(s) <- "subject"
names(a) <- "a_id"

# Create data type label (test or train)
t <- data.frame(type=rep("train", dim(s)[1]))

# Combine all train data into a data frame
train <- data.frame(cbind(fv,s,a,t))


# Combine the test and train data frames into one data frame
df.1 <- rbind(test, train)


### 2. Extract mean & standard deviation features/measurements.

# Return to the "UCI HAR Dataset/test" directory
setwd("..")

# Read the feature (summary statistic) labels.
#   Name the feature ID and label columns.
f <- read.table("features.txt")
names(f) <- c("f_id", "feature")

# Identify features containing mean or standard deviation measures
me <- grep("mean()", f$feature, fixed = TRUE)
sd <- grep("std()",  f$feature, fixed = TRUE)

# Recall that there are 561 features.  Employ that fact to extract
#   the subject, activity_id, type of data (test or train), mean 
#   and SD measures into a new data frame
df.2 <- df.1[, c(562, 563, 564, me, sd)]

# Delete large objects no longer needed to release memory
rm(fv, test, train, df.1)


### 3. Uses descriptive activity names to name the activities.

## Read activity label data.  Name the activity ID and label columns
al <- read.table("activity_labels.txt")
names(al) <- c("a_id", "activity")

## Merge the activity labels via the common column 'a_id'
df.3 <- merge(al, df.2)

# Drop the activity ID column, which is now redundant
df.3$a_id <- NULL


### 4. Label the data set with descriptive variable names. 

# Reshape the data frame into tidy data.  That is, reshape it 
#   so that categorical variables (activity, subject, and type) 
#   are retained as rows and quantitative variable labels (for the 
#   measurements involving mean or standard deviation, aka features) 
#   are converted into rows, with the actual measure de-pivoted into 
#   a single column.  By default, the new labels will be called 
#   'variable' and the metric column will be titled 'value'.
df.4 <- melt(df.3, id=c("activity", "subject",  "type"))

# In the new data frame, rename the newly created 'variable' column 
#   as 'f_id' for merging
names(df.4)[4] = "f_id"

# In object f (feature labels), prefix the f_id column index with "V" 
#   to match the contents of the f_id column in the data frame
f$f_id <- paste("V", f$f_id, sep = "")

# Convert data frames to data.tables to conserve memory
dt.1 <- data.table(df.4)
dt.f <- data.table(f)

# Remove large objects no longer needed to clean memory 
rm(df.2, df.3, df.4)

# Add the descriptive variable names (for features/summary stats)
#   by setting the data.table keys and merging the two tables
setkey(dt.1, f_id)
setkey(dt.f, f_id)
dt.tidy <- merge(dt.1, dt.f)  


### 5. From the step 4 data set, create a tidy data set with the 
### average of each variable for each activity and each subject.

# Aggregate the tidy data by the three categorical variables
df.summary <- ddply(dt.tidy, .(activity, subject, feature), 
           summarize, mean = round(mean(value), 4))

# Return to R working directory and ...
setwd("..")

# ... write out the Step 5 data set as specified for GitHub
write.table(df.summary, file = "Step_5_Data.txt", row.name=FALSE)


### END OF SCRIPT
