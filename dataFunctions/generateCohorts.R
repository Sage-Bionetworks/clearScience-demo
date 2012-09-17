# generateCohorts.R

# first piece of code for the clearScience demo project
# takes the full TRANSBIG breast cancer dataset and randomly divides it into
# "training" and "validation" cohorts and concomitantly dividing the clinical
# "ER Status" phenotype along with the cohorts

generateCohorts <- function(){
  
  # SOURCE IN NECESSARY LIBRARIES
  require(synapseClient)
  require(Biobase)

  # LOAD THE SYNAPSE ENTITY INTO MEMORY
  cat("[1] Loading TRANSBIG breast cancer dataset\n")
  dataEnt <- loadEntity(169192)
  transbig <- dataEnt$objects$transbig
  expressData <- exprs(transbig)
  pheno <- phenoData(transbig)

  ## CREATE TRAINING AND VALIDATION COHORTS
  cat("[2] Randomly splitting into training and validation sets\n")
  set.seed(931512)
  randVec <- rbinom(dim(transbig)[2], size = 1, prob = 0.5)
  trainExpress <- expressData[ , randVec == 0]
  validExpress <- expressData[ , randVec == 1]
  trainScore <- as.numeric(pheno@data$er[randVec == 0])
  validScore <- as.numeric(pheno@data$er[randVec == 1])
  
  return(list("randVec" = randVec,
              "trainExpress" = trainExpress,
              "validExpress" = validExpress,
              "trainScore" = trainScore,
              "validScore" = validScore))
  
}
