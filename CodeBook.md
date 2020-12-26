# CodeBook.md
Code book for tidy data.

## Variable-Description
The following files were read to process the raw data.

* feature_list - features.txt file

* activity - activity_labels.txt file

* subject_test - subject_test.txt file

* x_test - X_test.txt

* y_test - Y_test.txt

* subject_train - subject_train.txt

* x_train - train/X_train.txt

* y_train -train/Y_train.txt

### Intermediate variables
* y_test_label - it matches the y_test labels with the corresponding activities.

* tidy_test - containes the combined test subject, test activity and test data.

* y_train_label - it matches the y_train labels with the corresponding activities.

* tidy_train - contains the combined train subject, train activity and train data.

* tidy_data - the final merged test and train data.

* mean_and_std - is the data set 'with only measurements of the mean and standard deviation for each measurement'.

* tidy_data_average - 'independent tidy data set with the average of each variable for each activity and each subject.'