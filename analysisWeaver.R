## PROGRAM TO PULL TOGETHER AN ENTIRE ANALYSIS
#####
## clearScience-demo GITHUB REPOSITORY
## 
## erich s. huang
## brian m. bot
## SAGE BIONETWORKS
#####

options(stringsAsFactors=F)

require(synapseClient)
require(rGithubClient)

#####
## GET THE clearScience GITHUB REPOSITORY
#####
clearScienceRepo <- getRepo("Sage-Bionetworks/clearScience-demo",
                            ref="tag", refName="v0.9-11")
clearScienceRepo
view(clearScienceRepo)

#####
## PULL IN THE FUNCTION TO GENERATE TRAINING AND TESTING COHORTS
#####
generationCode <- sourceRepoFile(repository=clearScienceRepo, 
                                 repositoryPath="dataFunctions/generateCohorts.R")

cohorts <- generationCode$generateCohorts()
names(cohorts)

#####
## PULL IN THE FUNCTION FOR FITTING A TRAINING MODEL
#####
buildCode <- sourceRepoFile(repository=clearScienceRepo, 
                            repositoryPath="analysisFunctions/buildModel.R")

trainOutput <- buildCode$buildModel(cohorts)
names(trainOutput)
trainOutput$trainBoxPlot

#####
## PULL IN THE FUNCTION FOR VALIDATING MODEL IN HELD OUT TESTING SET
#####
view(clearScienceRepo, "analysisFunctions/validateModel.R")
validateCode <- sourceRepoFile(repository=clearScienceRepo, 
                               repositoryPath="analysisFunctions/validateModel.R")

valOutput <- validateCode$validateModel(trainOutput)
names(valOutput)
valOutput$validBoxPlot
valOutput$validDensPlot
valOutput$rocCurve

