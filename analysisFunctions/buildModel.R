# buildModel.R

# second piece of code for the clearScience demo project
# takes output from generateCohorts(), and fits a model for ER status


buildModel <- function(returnOne){
  
  # SOURCE NECESSARY LIBRARIES
  require(ggplot2)
  require(randomForest)
  
  ## BINARY MODEL OF 'ER Status' USING rf
  cat("[1] Fitting random forest model for ER on training set\n")
  rfERFit <- randomForest(t(returnOne$trainExpress), 
                           factor(returnOne$trainScore), 
                           ntree = 50,
                           do.trace = 5)
  
  # EVALUATE AND VISUALIZE TRAINING Y-HAT
  cat("[2] Evaluating predictions on training set\n")
  trainScoreHat <- predict(rfERFit, t(returnOne$trainExpress),
                           type = "prob")
  trainScoreHat <- trainScoreHat[ , 2]
  
  trainScoreDF <- as.data.frame(cbind(returnOne$trainScore, trainScoreHat))
  colnames(trainScoreDF) <- c("yTrain", "yTrainHat")
  cat("[3] Producting diagnostic boxplot of predictions on training set\n")
  trainBoxPlot <- ggplot(trainScoreDF, aes(factor(yTrain), yTrainHat)) + 
    geom_boxplot() +
    geom_jitter(aes(colour = as.factor(yTrain)), size = 4) +
    ggtitle("ER rf Model Training Set Hat\n") +
    ylab("Training Set ER Prediction") +
    xlab("True ER Status")
  
  return(list("rfERFit" = rfERFit,
              "trainBoxPlot" = trainBoxPlot,
              "returnOne" = returnOne))
  
}

