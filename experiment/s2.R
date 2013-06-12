# Generates the data file for the experiment in scenario 2

source("../experiment/util.R")

set.seed(109)
N <- 200
alpha <- c(2, 4, 3)
variation <- FALSE
beta_1 <- 5
beta_2 <- 2
pure <- FALSE
pairing <- FALSE
cost <- 0
bonus <- 0
mortality <- 0.1
generations <- 600
std_dev <- 0

source("../experiment/experiment.R")

const <- pop[27,1]
s2_data <- data.frame(cooperation = data$cooperation)
save(N, beta_1, beta_2, const, generations, mortality, s2_data, file = "s2.Rdata")