require(ggplot2)

source("../experiment/util.R")

set.seed(101)
N <- 1000
alpha <- c(2, 4, 3)
variation <- FALSE
beta_1 <- 5
beta_2 <- 2
pure <- FALSE
pairing <- FALSE
cost <- 0
bonus <- 0
mortality <- 0.05
generations <- 1500
std_dev <- 0.1

source("../experiment/experiment.R")
qplot(x = 1:generations, y = data$cooperation, geom = "line", ylim = c(0, 1), ylab = "Cooperation Level", xlab = "Generations")

s_data_1 <- data

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
qplot(x = 1:generations, y = data$cooperation, geom = "line", ylim = c(0, 0.3), ylab = "Cooperation Level", xlab = "Generations") # high mutation -> comebacks

s_data_2 <- data

set.seed(106)
N <- 1000
alpha <- c(2, 4, 3)
variation <- FALSE
beta_1 <- 2
beta_2 <- 5
pure <- TRUE
pairing <- FALSE
cost <- 0
bonus <- 0
mortality <- 0.1
generations <- 100
std_dev <- 0

source("../experiment/experiment.R")

s_data_3 <- data


mort <- c(rep("(0.1, 0.1)", times=100), rep("(5.0, 2.0)", times=100), rep("(2.0, 5.0)", times=100))
s_data <- data.frame(cooperation = c(s_data_1$cooperation, s_data_2$cooperation, s_data_3$cooperation), gen = rep(1:generations, times = 3), mort = mort)
g <- ggplot(s_data, aes(x = gen, y = cooperation)) + geom_line(size = 1.5, aes(color = mort)) + xlab('Generations') + ylab('Cooperation Level $p$') #+ ylim(c(0, 1.0))
g + theme(legend.position=c(0.7, 0.7), legend.title = element_text(face = "plain"), legend.title.align = 0.5, legend.text.align = 0.5) + scale_colour_discrete(name = "Shape")