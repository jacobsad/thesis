##' Requires that the following be defined: 
##' 
##' @param N The size of the population.
##' @param alpha The alpha value for the Dirichlet distribution.
##' @param beta_1 The first parameter for the Beta distribution.
##' @param beta_2 The first parameter for the Beta distribution.
##' @param variation Whether or not to include variation in the delta values.
##' @param base_fitness Unused.
##' @param pure Whether to use pure strategies. If `true`, generates p and t values of 1 or 0 uniformly.
##' 
##' @param cost The cost of forming a new pair.
##' @param bonus The bonus for remaining in a pair.
##' @param pairing Whether pairing takes place at all.
##' @param mortality The average number of games per lifetime.
##' @param generations The number of generations to run the experiment.
##' @param std_dev The standard deviation of the mutation. Set to zero to disable mutation.
##' 

base_fitness <- 0
pop <- new.population(N, alpha, beta_1, beta_2, base_fitness, variation, pure)
init_avg <- c(mean(pop[,1]), mean(pop[,2]))
data <- data.frame(cooperation = numeric(generations),
                   threshhold = numeric(generations),
                   pairs = numeric(generations))

for (n in 1:generations) {
    
    # Finds everyone with no partner
    cand <- as.integer(names(pop[!complete.cases(pop),7]))
    if (length(cand) %% 2 != 0) {
        stop(cat("Pair matching error in generation ", n, ".", sep = ""))
    }
    
    # Finds those with partners... holy fuck this is overly-complicated.    
    if (length(cand) < nrow(pop)) {
        old.pairs <- 1:nrow(pop) # Change to N later
        old.pairs <- old.pairs[-cand]
        old.pairs <- c(old.pairs, as.vector(pop[old.pairs,7]))
        op <- matrix(old.pairs, ncol = 2, byrow = FALSE)
        op <- t(apply(op, 1, sort))
        op <- op[!duplicated(op),]
        
        # Plays games among partners. They remain in pairs, obviously.
        if (length(nrow(op)) == 0) { # Happens when there is only one pair
            data$pairs[n] <- 1
            a <- op[1]
            b <- op[2]
            fit <- play.game(pop[a,], pop[b,])
            pop[a,6] <- fit[1] + bonus
            pop[b,6] <- fit[2] + bonus
        } else {
            data$pairs[n] <- nrow(op)
            for (i in 1:nrow(op)) {
                a <- op[i,1]
                b <- op[i,2]
                fit <- play.game(pop[a,], pop[b,])
                pop[a,6] <- fit[1] + bonus
                pop[b,6] <- fit[2] + bonus
            }
        }
    }
    
    # Pairs up currently single players. They play. Fitness is assigned. Divorces are made.
    pairs <- matrix(sample(cand), ncol = 2, byrow = TRUE)
    for (i in 1:nrow(pairs)) { 
        a <- pairs[i,1]
        b <- pairs[i,2]
        fit <- play.game(pop[a,], pop[b,])
        pop[a,6] <- fit[1] + bonus - cost
        pop[b,6] <- fit[2] + bonus - cost
        
        # If pairing is possible, allow pairing
        if (pairing && pop[a,1] >= pop[b,2] && pop[b,1] >= pop[a,2]) {
            pop[a,7] <- b
            pop[b,7] <- a        
        }
        
        if (pairing && pop[a,6] == pop[a,4] && pop[b,6] == pop[b,4]) {
            # ??
        }
    }
    
    
    # Mark players out for death
    deaths <- runif(nrow(pop)) < mortality
    n_deaths <- sum(deaths, na.rm = TRUE)
    if (n_deaths != 0) {
        pop[as.integer(pop[as.integer(pop[na.omit(pop[deaths,7]),7]),7]),7] <- NA # Unpair from the dead!
        
        # Pick replacements based on fitness
        fit <- pop[,"fit"]
        cumFit <- cumsum(fit / sum(fit))
        replacements <- runif(n_deaths)
        p <- findBucket(replacements, cumFit, n)
        
        # Replace dead players with new ones (with no partners)
        pop[deaths,] <- pop[p,]
        pop[deaths,7] <- NA
        
        # Mutation in p1 and p2
        pop[deaths,1] <- plogis(rnorm(n_deaths, mean = qlogis(pop[deaths,1]), sd = std_dev))
        pop[deaths,2] <- plogis(rnorm(n_deaths, mean = qlogis(pop[deaths,2]), sd = std_dev))
    }
    
    # Add means to collected data
    data$cooperation[n] <- mean(pop[,1])
    data$threshhold[n] <- mean(pop[,2])
}
final_avg <- c(mean(pop[,1]), mean(pop[,2]))
init_avg
final_avg

#qplot(x = 1:generations, y = data$cooperation, geom = "line", ylim = c(0, 1), ylab = "Cooperation Level", xlab = "Generations")
#qplot(x = 1:generations, y = data$pairs, geom = "line", ylab = "Number of Pairs", xlab = "Generations")