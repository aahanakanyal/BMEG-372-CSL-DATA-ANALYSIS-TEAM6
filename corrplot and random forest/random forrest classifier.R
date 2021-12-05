#setwd(file location) #change the file location to wherever the First_Responder_Reporting_2016-2020_Formstack.csv is stored
library(randomForest)
library(ggplot2)
library(corrplot)
library(tidyverse)
first_responder = read.csv("First_Responder_Reporting_2016-2020_Formstack.csv", stringsAsFactors = TRUE)

first_responder <- first_responder %>% 
  rename(
    company = Company.Name,
    type = First.Responder.Type,
    other = If.Other..please.describe.list,
    BeginReport = Reporting.Period...BEGIN.DATE,
    EndReport = Reporting.Period...END.DATE,
    instancesUsed = Number.instances.naloxone.used,
    oneDose = Number.instances.requiring.one..1..dose,
    lifeSaved = Number.instances.that.resulted.in.a.life.saved,
    twoDoses = Number.instances.requiring.two..2..doses,
    CombativeInstances = Number.instances.where.individual.became.combative.after.receiving.naloxone,
    twoDosesOrMore = Number.instances.requiring.more.than.two..2..doses.,
    HospitalInstances = Hospital.transport.....Instances,
    JailInstances = Jail.transport.....Instances,
    Male = X..of.Male,
    Female = X..Female,
    XU15 = Under.15.....instances,
    X15to24 = X15.24.....instances,
    X25to34 = X25.34.....instances,
    X35to44 = X35.44.....instances,
    X45to54 = X45.54.....instances,
    X55to64 = X55.64.....instances,
    X65andUp = X65......instances,
    submission = Submission.Date,
  )

M <- cor(first_responder[,8:24])
corrplot(M, method = 'circle')

#for(i in 1:nrow(first_responder)) {
#  if (first_responder$type[i] == "Other") {
#    first_responder$type[i] <- 0
#  }
#  if (first_responder$type[i] == "Law Enforcement") {
#    first_responder$type[i] <- 1
#  }
#  if (first_responder$type[i] == "Fire Department") {
#    first_responder$type[i] <- 2
#  }
#  if (first_responder$type[i] == "EMS") {
#    first_responder$type[i] <- 3
#  }
#  if (first_responder$type[i] == "Ambulance Service") {
#    first_responder$type[i] <- 4
#  }
#}

chunk <- sample(nrow(first_responder), 0.7 * nrow(first_responder)) # 70% of the data is used for training, 30% for testing
training_dataset <- first_responder[chunk, c(3, 8:24)]
testing_dataset <- first_responder[-chunk, c(3, 8:24)]

#training_dataset <- c(data.frame(apply(training_dataset[1], 2, function(x) as.integer(x))), data.frame(apply(training_dataset[-1], 2, function(x) as.numeric(as.character(x)))))
#testing_dataset <- c(data.frame(apply(testing_dataset[1], 2, function(x) as.integer(x))), data.frame(apply(testing_dataset[-1], 2, function(x) as.numeric(as.character(x)))))


model <- randomForest(type ~ ., data = training_dataset, importance = TRUE)

trainingPrediction <- predict(model, training_dataset, type = "response")
table(trainingPrediction, training_dataset$type)

testPrediction <- predict(model, testing_dataset, type = "response")
#write.csv(table(testPrediction, testing_dataset$type), file location) #change to the location and file where you want there to be a csv output

PCA <- prcomp(training_dataset[-1], center = TRUE, scale. = TRUE)
PCdata <- as.data.frame(PCA$x)

ggplot(data = PCdata, aes(x=PC1, y=PC2)) + geom_point(aes(colour = training_dataset$type)) + labs(color = "First Responder Type")

ggplot(data = PCdata, aes(x=PC3, y=PC4)) + geom_point(aes(colour = training_dataset$type)) + labs(color = "First Responder Type")
ggplot(data = PCdata, aes(x=PC5, y=PC6)) + geom_point(aes(colour = training_dataset$type)) + labs(color = "First Responder Type")
ggplot(data = PCdata, aes(x=PC7, y=PC8)) + geom_point(aes(colour = training_dataset$type)) + labs(color = "First Responder Type")
ggplot(data = PCdata, aes(x=PC9, y=PC10)) + geom_point(aes(colour = training_dataset$type)) + labs(color = "First Responder Type")
ggplot(data = PCdata, aes(x=PC11, y=PC12)) + geom_point(aes(colour = training_dataset$type)) + labs(color = "First Responder Type")
ggplot(data = PCdata, aes(x=PC13, y=PC14)) + geom_point(aes(colour = training_dataset$type)) + labs(color = "First Responder Type")
ggplot(data = PCdata, aes(x=PC15, y=PC16)) + geom_point(aes(colour = training_dataset$type)) + labs(color = "First Responder Type")
ggplot(data = PCdata, aes(x=PC16, y=PC17)) + geom_point(aes(colour = training_dataset$type)) + labs(color = "First Responder Type")

countytrainData <- first_responder[, c(5, 8:24)] #no test data because set is too small

PCA <- prcomp(countytrainData[-1], center = TRUE, scale. = TRUE)
PCdata <- as.data.frame(PCA$x)

ggplot(data = PCdata, aes(x=PC1, y=PC2)) + geom_point(aes(colour = countytrainData$County)) + labs(color = "County")

model <- randomForest(County ~ ., data = countytrainData, importance = TRUE)

trainingPrediction <- predict(model, countytrainData, type = "response")
#write.csv(table(trainingPrediction, countytrainData$County), file location) #change to the location and file where you want there to be a csv output

#testPrediction <- predict(model, countytestData, type = "response")
#table(testPrediction, countytestData$County)
