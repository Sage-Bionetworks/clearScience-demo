#####################
## ANALYSIS WEAVER ##
#####################
# clearScience demo
#
# PRESENTERS:
# erich s. huang
# brian m. bot
#
#####

require(synapseClient)

#####
## step 1 - randomly generate the training and validation sets
#####
codeOne <- loadEntity('syn299501')
attach(codeOne)
invisible(edit(generateCohorts))

## run code
returnOne <- generateCohorts()

## explore the output
names(returnOne)


#####
## step 2 - fit a random forest model to the data (A) and then validate on held out samples (B)
#####
codeTwo <- loadEntity('syn308266')
attach(codeTwo)

## substep (A)
#####
invisible(edit(buildModel))

## run code
returnTwoA <- buildModel(returnOne)

## explore the output
names(returnTwoA)
returnTwoA$trainBoxPlot

## substep (B)
#####
invisible(edit(validateModel))

## run code
returnTwoB <- validateModel(returnTwoA)

## explore the output
names(returnTwoB)
returnTwoB$validBoxPlot
returnTwoB$validDensPlot
returnTwoB$rocCurve

