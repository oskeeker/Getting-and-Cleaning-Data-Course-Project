
	#-- We need to download first the reshape2 library to use it later --#
	
	library(reshape2)

	# Load the activities from the .txt file
	activity_labels <- read.table("./activity_labels.txt",col.names=c("activity_id","activity_name"))
	features <- read.table("features.txt")
	feature_names <-  features[,2]
	
	# Store de X_test
	data <- read.table("./test/X_test.txt")
	colnames(data) <- feature_names
	# Store the X_train
	train <- read.table("./train/X_train.txt")
	colnames(train) <- feature_names
	
	# Store the Subject Cases
	subjectTest <- read.table("./test/subject_test.txt")
	colnames(subjectTest) <- "subject_id"
	# Store the y_test
	yTest <- read.table("./test/y_test.txt")
	colnames(yTest) <- "activity_id"
	subjectTrain <- read.table("./train/subject_train.txt")
	colnames(subjectTrain) <- "subject_id"
	# Store the y_train
	yTrain <- read.table("./train/y_train.txt")
	colnames(yTrain) <- "activity_id"

	# Bind the data
	dataT <- cbind(subjectTest , yTest , data)
	trainD <- cbind(subjectTrain , yTrain , train)
	bindD <- rbind(trainD,dataT)
		
	# Establish the means
	meanG <- grep("mean",names(bindD),ignore.case=TRUE)
	nameMean <- names(bindD)[meanG]
	
	# Stablish the desviation
	std <- grep("std",names(bindD),ignore.case=TRUE)
	stdN <- names(bindD)[std]
	
	# We resolve and make the merge
	meanstddata <-bindD[,c("subject_id","activity_id",nameMean,stdN)]
	mergeNames <- merge(activity_labels,meanstddata,by.x="activity_id",by.y="activity_id",all=TRUE)
	meltD <- melt(mergeNames,id=c("activity_id","activity_name","subject_id"))
	
	# Finally, the result
	result <- dcast(meltD,activity_id + activity_name + subject_id ~ variable,mean)
   	write.table(result,"./tidy_movement_data.txt")
