gatherData <- function(type = 'test') {
  # Read activity tables. Since activities are numbered from 1
  # in ascending order, the nth row gives us the label for the nth activity.
  activity_labels <- read.table('activity_labels.txt', header = FALSE,
                               col.names=c("number", "label"))
  
  # Read the features list. The same concept as activity above is applicable.
  features <- read.table('features.txt', header = FALSE,
                         col.names=c("number", "label"))
  
  # Initialize paths
  base_path <- file.path(getwd(), type)
  subject_path <- file.path(base_path, paste0("subject_", type, ".txt"))
  X_path <- file.path(base_path, paste0("X_", type, ".txt"))
  y_path <- file.path(base_path, paste0("y_", type, ".txt"))
  
  # Load data
  subjects <- read.table(subject_path, header = FALSE, col.names=c("subjectnumber"))
  
  # We remove any column that does not have "mean" or "std" in its
  # name, since we're only extacting mean and std deviation columns.
  X_values <- read.table(X_path, header = FALSE, col.names=features[,'label'])
  
  required_X_columns <- grepl("(mean)|(std)", names(X_values), ignore.case=TRUE)
  X_values <- X_values[,required_X_columns]
  
  y_values <- read.table(y_path, header = FALSE, col.names=c("activitynumber"))

  # Construct a dataset with all of the above things
  clean_dataset = data.frame(
    subjectnumber=subjects[,'subjectnumber'],
    activitynumber=y_values[,'activitynumber']
  )
  
  clean_dataset = cbind(clean_dataset, X_values)
  
  # Add activity name from number
  clean_dataset$activityname <- sapply(clean_dataset$activitynumber,
                                       function(x) {activity_labels[x,][['label']]})
  
  # Remove activitynumber since it's redundant
  clean_dataset <- within(clean_dataset, rm(activitynumber))
  
  # Return the clean data set
  clean_dataset
}

test_data <- gatherData('test')
train_data <- gatherData('train')

merged_data <- rbind(test_data, train_data)

# Beautify column names
names(merged_data) <- sub("([.]{2,})|([.]+$)", "", names(merged_data))

# Create the tidy data set by activityname and subjectnumber
# Ignore columns 1 and 88, which is the activityname and subjectnumber itself
tidy_data <- aggregate(merged_data[,2:87],
                       by=list(activityname=merged_data$activityname,
                               subjectnumber=merged_data$subjectnumber),
                       mean)

# Write the tidy output to a file
write.table(tidy_data, "tidy_data.txt", row.names=FALSE)
