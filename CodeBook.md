Data Code Book
==============

This codebook describes my tidy data set generated in step 5 of the *Getting and Cleaning Data* course project.


For background on this data set, see the README file in this repo.

The file *run_analysis.R* contains the script that generated this data.  The script comments detail the desired results for each operation.


## Format
The data is in a space delimited file named *Step_5_Data.txt*.  The file has one header row and 11,880 data rows.  All text (including the headers) is enclosed in double quotes.  The data was written from R with the following command:

    write.table(df.summary, file = "Step_5_Data.txt", row.name=FALSE)


## Dimensions
There are 11,880 rows and four columns.  The columns are: 

 * Activity.  One of six physical activities:  Walking, walking upstairs, walking downstairs, sitting, standing, and laying.
 * Subject.  One of thirty human subjects that participated in this study.
 * Feature.  One of 66 summary metrics that were calculated from mobile phone sensor data.  These aggregate metrics deal with 33 means and 33 standard deviations.  Features are described in greater detail below.
 * Mean.  The mean value of the feature for each Activity - Subject - Feature tuple.  The means are collapsed over measurement windows (time periods).

The number of rows is a product of the tuples.  Given that 11,880 = 6 activities x 30 subjects x 66 features, all possible combinations are present.


## Data Types

Activity, Subject, and Feature are categorical variables.  

The mean is the arithmetic mean of previous means or standard deviations.  (Yes, that is correct, we are generating summary statistics on summary statistics.)  The initial means and SDs were generated from two types of data: acceleration (Acc) and angular velocity (Gyro).  Acceleration is measured in in standard gravity units 'g'.  Angular velocity is measured in radians/second.  However, the initial summary measures have been normalized between [-1, 1], so the values may no longer be strictly interpreted as physical metrics.  Rather, they are of value in predicting activity in the study model.  See the README file for more details.  One may also consult resources noted below for details on the raw data.  


## Features
The 66 features included are:

 *  tBodyAcc-mean()-X
 *  tBodyGyro-mean()-X
 *  tBodyGyro-mean()-Y
 *  tBodyGyro-mean()-Z
 *  tBodyGyro-std()-X
 *  tBodyGyro-std()-Y
 *  tBodyGyro-std()-Z
 *  tBodyGyroJerk-mean()-X
 *  tBodyGyroJerk-mean()-Y
 *  tBodyGyroJerk-mean()-Z
 *  tBodyGyroJerk-std()-X
 *  tBodyGyroJerk-std()-Y
 *  tBodyGyroJerk-std()-Z
 *  tBodyAcc-mean()-Y
 *  tBodyAccMag-mean()
 *  tBodyAccMag-std()
 *  tGravityAccMag-mean()
 *  tGravityAccMag-std()
 *  tBodyAccJerkMag-mean()
 *  tBodyAccJerkMag-std()
 *  tBodyGyroMag-mean()
 *  tBodyGyroMag-std()
 *  tBodyGyroJerkMag-mean()
 *  tBodyGyroJerkMag-std()
 *  fBodyAcc-mean()-X
 *  fBodyAcc-mean()-Y
 *  fBodyAcc-mean()-Z
 *  fBodyAcc-std()-X
 *  fBodyAcc-std()-Y
 *  fBodyAcc-std()-Z
 *  tBodyAcc-mean()-Z
 *  fBodyAccJerk-mean()-X
 *  fBodyAccJerk-mean()-Y
 *  fBodyAccJerk-mean()-Z
 *  fBodyAccJerk-std()-X
 *  fBodyAccJerk-std()-Y
 *  fBodyAccJerk-std()-Z
 *  tBodyAcc-std()-X
 *  tGravityAcc-mean()-X
 *  tGravityAcc-mean()-Y
 *  fBodyGyro-mean()-X
 *  fBodyGyro-mean()-Y
 *  fBodyGyro-mean()-Z
 *  fBodyGyro-std()-X
 *  fBodyGyro-std()-Y
 *  fBodyGyro-std()-Z
 *  tGravityAcc-mean()-Z
 *  tGravityAcc-std()-X
 *  tGravityAcc-std()-Y
 *  tGravityAcc-std()-Z
 *  tBodyAcc-std()-Y
 *  fBodyAccMag-mean()
 *  fBodyAccMag-std()
 *  fBodyBodyAccJerkMag-mean()
 *  fBodyBodyAccJerkMag-std()
 *  fBodyBodyGyroMag-mean()
 *  fBodyBodyGyroMag-std()
 *  fBodyBodyGyroJerkMag-mean()
 *  fBodyBodyGyroJerkMag-std()
 *  tBodyAcc-std()-Z
 *  tBodyAccJerk-mean()-X
 *  tBodyAccJerk-mean()-Y
 *  tBodyAccJerk-mean()-Z
 *  tBodyAccJerk-std()-X
 *  tBodyAccJerk-std()-Y
 *  tBodyAccJerk-std()-Z

As mentioned above, these measures are summaries of acceleration and angular velocity as measure by mobile phones.  The measurements have been partitioned into three axial components; X, Y, and Z, and for various components thereof, e.g, Body, Total, Jerk, etc.


## Reference
Full details on the raw data may be found at <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

