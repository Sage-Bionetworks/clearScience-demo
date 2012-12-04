# validateModel.R

# third piece of code for the clearScience Demo Project
# takes the output from buildModel(), and fits that model
# on held out validation data


validateModel <- function(returnTwo){
  
  # SOURCE LIBRARIES
  require(randomForest)
  require(ggplot2)
  require(ROCR)
  
  # DEFINE VARIABLES
  rfERFit <- returnTwo$rfERFit
  validExpress <- returnTwo$returnOne$validExpress
  validScore <- returnTwo$returnOne$validScore
  
  # VALIDATE & VISUALIZE WITH HELD OUT VALIDATION COHORT
  cat("[1] Evaluating predictions on held out validation set\n")
  validScoreHat <- predict(rfERFit, t(validExpress), type = "prob")
  validScoreHat <- validScoreHat[ , 2]
  validScoreDF <- as.data.frame(cbind(validScore, validScoreHat))
  colnames(validScoreDF) <- c("yValid", "yValidHat")

  cat("[2] Producing diagnostic boxplot of predictions in the held out validation set\n")
  validBoxPlot <- ggplot(validScoreDF, aes(factor(yValid), yValidHat)) + 
    geom_boxplot() +
    geom_jitter(aes(colour = as.factor(yValid)), size = 4) +
    ggtitle("ER Random Forest Model Independent Validation Set\n") +
    ylab("Validation Set ER Prediction") +
    xlab("True ER Status")
  
  # Alternative visualization (density plots)
  cat("[3] Producing diagnostic density plot of predictions in the held out validation set\n")
  validDensPlot <- ggplot(validScoreDF, 
                          aes(yValidHat, 
                              fill = factor(yValid))) + 
                                geom_density(alpha = 0.3) +
                                ylab("Density") +
                                xlab("True ER Status") +
                                ggtitle("Density Plot")
  
  # EVALUATE VALIDATION MODEL PERFORMANCE
  erPred <- prediction(as.numeric(validScoreHat), as.numeric(validScore))
  erPerf <- performance(erPred, "tpr", "fpr")
  erAUC <- performance(erPred, "auc")
  
  # FIND YOUDEN'S J POINT AND OPTIMAL SENSITIVITY AND SPECIFICITY
  erRFPerf <- performance(erPred, "sens", "spec")
  youdensJ <- erRFPerf@x.values[[1]] + erRFPerf@y.values[[1]] - 1
  jMax <- which.max(youdensJ)
  optCut <- erPerf@alpha.values[[1]][jMax]
  
  optSens <- unlist(erRFPerf@x.values)[jMax]
  optSpec <- unlist(erRFPerf@y.values)[jMax]
  
  rankSum <- wilcox.test(validScoreHat[validScore == 0], 
                         validScoreHat[validScore == 1])
  
  ## CREATE A ROC CURVE USING GGPLOT
  cat("[4] Assessing model performance via ROC curve in held out validation set\n")
  dfPerf <- as.data.frame(cbind(unlist(erPerf@x.values),
                                unlist(erPerf@y.values)))
  colnames(dfPerf) <- c("FalsePositiveRate", "TruePositiveRate")
  
  rocCurve <- ggplot(dfPerf, aes(FalsePositiveRate, TruePositiveRate)) +
    geom_line() + 
    geom_abline(slope = 1, colour = "red") +
    ggtitle("Validation Cohort ROC Curve\n") +
    ylab("False Positive Rate") +
    xlab("True Positive Rate")
  
  ## RETURN
  return(list("validScoreDF" = validScoreDF,
         "validBoxPlot" = validBoxPlot,
         "validDensPlot" = validDensPlot,
         "rankSum" = rankSum,
         "rocCurve" = rocCurve,
         "sensitivity" = optSens,
         "specificity" = optSpec,
         "auc" = erAUC@y.values))
  
}
