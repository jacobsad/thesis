# Generates the data file for the experiment in scenario 1

source("../experiment/util.R")

N <- 1000
alpha <- c(2, 4, 3)
variation <- FALSE
beta_1 <- 1
beta_2 <- 1
pure <- TRUE
pairing <- FALSE
cost <- 0
bonus <- 0
generations <- 100
std_dev <- 0

# Run experiment 1.1
set.seed(102)
mortality <- 0.05
source("../experiment/experiment.R")
s1_data_1 <- data

# Run experiment 1.2
set.seed(104)
mortality <- 0.1
source("../experiment/experiment.R")
s1_data_2 <- data

# Run experiment 1.3
set.seed(106)
mortality <- 0.2
source("../experiment/experiment.R")
s1_data_3 <- data

cooperation <- c(s1_data_1$cooperation, s1_data_2$cooperation, s1_data_3$cooperation)
save(N, beta_1, beta_2, generations, cooperation, file = "s1.Rdata")