## analysisWeaver2.R

## Erich S. Huang
## Sage Bionetworks
## erich.huang@sagebase.org

## An alternative script for weaving the clearScience demonstration

#####
# STEP ONE: The demonstrator clicks on the "Cohort Assignment" code link
#####

attach(entity_299501)
returnOne <- generateCohorts()
names(returnOne)

#####
# STEP TWO: The demonstrator clicks the "Model Build" code link
#####

attach(entity_308266)
returnTwo <- buildModel(returnOne)
names(returnTwo)

## Show a plot of the model fit
returnTwo$trainBoxPlot

#####
# STEP THREE: Validate the built model with the held-out cohort
####

returnThree <- validateModel(returnTwo)
names(returnThree)

## Show a plot of the predicted values
returnThree$validBoxPlot