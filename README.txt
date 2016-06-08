# README

The original README of the dataset explains all the data that's stored, and how it's stored. We have only one R script, `run_analysis.R`, which has to be run in the same directory as the dataset.

The original dataset has columns of data being stored in separate files. We merge these columns using `cbind`, and we also
merge the test and train dataset using `rbind`.

Finally, the mean of all columns by activityname and by subject is calculated, and saved in a file called `tidy_data.txt`.

Please refer the codebook for details on each variable.
