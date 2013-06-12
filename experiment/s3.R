# Generates the data file for the experiment in scenario 3

source("../experiment/util.R")

set.seed(101)
N <- 500
alpha <- c(2, 4, 3)
variation <- FALSE
beta_1 <- 2
beta_2 <- 5
pure <- FALSE
pairing <- FALSE
cost <- 0
bonus <- 0
mortality <- 0.1
generations <- 1500
std_dev <- 0.5

source("../experiment/experiment.R")
s3_data <- data.frame(cooperation = data$cooperation)
save(N, beta_1, beta_2, mortality, std_dev, generations, s3_data, file = "s3.Rdata")