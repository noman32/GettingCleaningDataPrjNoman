---
title: "CodeBook"
author: "noman"
date: "27/12/2021"
output: html_document
---

## Tasks performed on data:

- created a data dir named ./Project
- downloaded the zip file from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip to ./data
- extracted the zip file ing zip file into ./Project/UCI_HAR_Dataset_Noman
- read the train data files on X variable, activity and subject and merged them into one single train dataframe. Do the same for test data files
- merged the train and test data frames into one single dataframe: dtMerged
- created a subset data frame dataSubset from dtMerged keeping only the columns and features containing std or mean
- appended activity labels from merged activity_labels.txt dataSubset
- melt dataSubset into newNames, based on key columns
- split feature column variable into 7 seperate colums (for each sub feature), and added it to newNames
- renamed newNames to dataSubset
- saved dataSubset into data_tidy with the average of each variable for each activity and each subject dimensions
- written data_tidy to file ./Project/data_tidy.txt
