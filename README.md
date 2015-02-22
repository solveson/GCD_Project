Get and Clean Data Course Project
=================================

This repo contains my four files submitted for the GCD course project.

 - This README file, which provides an overview of the project.
 - The R script that converts the provided raw data into the final data.
 - A Data Codebook that documents the final data set.
 - And the final tidy data set itself.


## Background

Raw data was collected to train algorithms to predict human physical activity recognition using smartphone sensors.  30 human subjects participated in six activities.  Measurements on those activities form the basis for this data.  The activities were WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, and LAYING.  Activity codes are found in the file activity_labels.txt.

Data was collected at a rate of 50Hz using the smartphone's accelerometer and gyroscope sensors.  Both metrics were collected in three axial domains: X, Y, and Z.  Gravimetric acceleration was mathematically separated from total acceleration, allowing the calculation of body acceleration.

The raw data was cleaned using mathematical algorithms and divided into fixed-width sliding time windows of 2.56 seconds with a 50% overlap; which results in 128 readings per time window / row.

This results in three types of inertial data:

 - body_gyro - Body gyroscopic angular velocity
 - body_acc -  Body acceleration
 - total_acc - Total acceleration = body + gravity

Each data type has three axial components: X, Y, and Z.  This give us nine major inertial data files.  

There are also two accompanying categorical data files which identify the activity (Y) and the subject (Subject) for each window.  

There is also a statistics file (X), which contains 561 summary statistics (known as features in the original documentation) for each time window / row.  Details on the summary stats/features are found in the file features.txt.

Finally, the data was randomly divided into two sets by subject.  70% of the data (21 subjects) was designed for training the activity recognition model, while 30% ( 9 subjects) was reserved for testing the model.


## Raw Data Files

The large data files and their dimensions are:

    FileName========Test===========Train=====Content==========Data Size======   
    X          561c x 2947r   561c x 7352r   Features         16 chars/nbr   
    y            1c x 2947r     1c x 7352r   Activity ID      1 char/ID   
    subject      1c x 2947r     1c x 7352r   Subject ID       1 or 2 chars/ID   
    Data(x9)   128c x 2947r   128c x 7352r   Initial data     16 chars/nbr   

The small data files and their dimensions are:

    FileName==============Size========Content===========Data Size=============   
    activity_labels.txt   2c x   6r   Activity Labels   integers, text strings   
    features.txt          2c x 561r   Feature  Labels   integers, text strings   

The other files in the data set provide documentation on the collection and formatting of the data.


## Data Transformation Process

### Goal

Though the data set does contain cleaned 'raw' data, this project's focus is on reformatting the provided summary statistics, know as *features*, into a tidy subset of those statistics.  The training and test data sets each contain a features file, along with their accompanying *subject* and *activity* ('y') file.  

Our goal is to transform the data as follows:

1. Merge the training and test sets
2. Extract only features based on mean or standard deviation
3. Label the activities with descriptive names
4. Label the features with descriptive names
5. From the step 4 data set, create another tidy data set with the average for each feature, activity and subject tuple

### Process

*Step 1.* For both the test and the training data sets, we first combine the features with the subjects and activities.  The features file has 561 columns, with each column representing a particular summary statistics.  For example, column 121 contains the mean body radial velocity in the X axial domain.  The subject file contains one column with an integer representing the subject.  The y file contains one column with an integer representing the activity being performed.  In test there are 2947 rows, while train has 7352 rows.  So we will bind these three files by column.  I also generated another column, which indicates whether the features are from the test or training data sets.  This data type could be used later if there are questions about the similarity of the test and training data sets.  Thus, at this point, our data sets each have 564 columns.  Lastly, we perform a row-wise bind to combine the training and test sets into a single data set that is 564 columns by 10299 rows.

*Step 2.* Now we will extract those features that are based on mean or standard deviation.  As noted above, the features.txt file contains an index with the meaning of each column in the features data.  The feature names are in uniform format, with mean metrics ending in "mean()" and standard deviation metrics ending in "std()".  Thus, we can use standard string functions to identify those feature names and generate indices for the desired columns.  We use those indices to extract the relevant feature columns, bringing along the associated subject, activity, and type of data source (test or train).  As there were 33 means and 33 standard deviations, our data set is now only 69 columns wide.

*Step 3.* To label the activities, recall that the test and training activity files ("y") each actually contained a column of integers representing the activity.  This was most likely done to condense the size of the data set.  A single integer takes less space than the corresponding activity labels.  However, as our activity label file contains both the integer and the corresponding label, it is a straightforward step to merge our current data set with the activity label file.  After doing so, I discard the integer column, as it is no longer needed.  Note that with the activity label file, I could recreate it if desired.  By dropping the activity integer column, our data set retains the same dimensions as in step 2:  69 columns by 10299 rows.

*Step 4.* To label the features is a bit more complex.  Features were originally identified by their columnar position in the feature ("X") data file.  This file had no header row.  When the data is read, R provides each column with a name.  The first column is V1, the second V2, and so on until the last column which was named V561.  When I extracted the mean and standard deviation features, the column positions were changed, but the column names remained as assigned when originally read.  I then melt the data, changing each feature from a column to a row factor, again bringing along the subject, activity, and data type.  The actual value/metric of the feature is now in a single column, labelled 'value'.  Melting produces a very long data set, my dimensions are now 5 columns by 679734 rows.

Now I prefix each index in the feature label file with "V", so it matches the feature labels generated by R.  Then the merge is identical in logic to that used in step 3.  The only difference is that, due to the size of our current data set, I used data.table instead of data.frame to process the merge.  data.table is more memory and CPU efficient than data.frame.  The result (retaining the feature index) is 6 columns by 679734 rows.

Please note that at this point we have a 'long' tidy data set.  Each column contains a single type of data; either activity, feature, feature ID, subject ID, data type (test or train), and the mean value of that respective tuple.  However, each tuple is not distinct.  What is missing is the time when the underlying data was recorded for each tuple.  It is possible that this was denoted by the row placement in the initial feature files.  However the documentation does not so state, so I chose not to make that assumption.

*Step 5.* The final requirement is to condense the data from step 4 into another tidy summary data set.  This is done by calculating the mean for each distinct tuple, disregarding data type: test or train.  This results in a data set with four columns: three categorical variables (feature, activity, and subject) and the arithmetic mean of all rows with that combination of factors.

This is the data set in this repo.
