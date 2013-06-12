##' 
##' Modification of findInterval() to get the first bucket, as opposed to the last
##' 
findBucket <- function(x, array, n) {
    last <- findInterval(x, array)    
    if (length(last) == 0) {
        stop(cat("Error in findInterval() at generation ", n, ".", sep = ""))
    }
    t <- last == 0 # Check for zeros
    last[t] <- 1
    
    # Shift to buckets (the point of this function)
    for (i in 1:length(last)) {
        while(last[i] > 1 && array[last[i]] == array[last[i] - 1]) {
            last[i] <- last[i] - 1
        }
    }    
    return(last)
}

##' 
##' Accepts players A and B in the form (p, t, \delta_1, 2\delta_2, 3\delta_3)
##' 
##' @return a pair corresponding to A and B's respective payoffs
##' 
play.game <- function(A, B) {
    # Note: P = \delta_3, R = \delta_2 + P, and T = \delta_1 + R
    if (runif(1) <= A[1]) { # A cooperates
        if (runif(1) <= B[1]) { # B cooperates
            A_r <- A[5] / 3 + A[4] / 2
            B_r <- B[5] / 3 + B[4] / 2
            return (c(A_r, B_r)) # Return (R, R)
        } else { # B defects
            B_t <- B[5] / 3 + B[4] / 2 + B[3]
            return(c(0, B_t)) # Return (S, T)
        }
    } else { # A defects
        if (runif(1) <= B[1]) { # B cooperates
            A_t <- A[5] / 3 + A[4] / 2 + A[3]
            return (c(A_t, 0)) # Return (T, S)
        } else { # B defects
            A_p <- A[5] / 3
            B_p <- B[5] / 3
            return(c(A_p, B_p)) # Return (P, P)
        }
    }
}

##' 
##' Generates an individual as a row of the population matrix
##' 
##' @param alpha The alpha value for the Dirichlet distribution.
##' @param beta_1 The first parameter for the Beta distribution.
##' @param beta_2 The first parameter for the Beta distribution.
##' @param variation Whether or not to include variation in the delta values.
##' @param base_fitness Unused.
##' @param pure Whether to use pure strategies. If `true`, generates p and t values of 1 or 0 uniformly.
##' 
##' @return An individual in the form (p, t, \delta_1, 2\delta_2, 3\delta_3, base_fitness, pair = NA)
##' 
new.individual.row <- function(alpha = c(2, 4, 3), beta_1 = 1, beta_2 = 1, variation = TRUE, base_fitness = 0, pure = FALSE) {
    require(MCMCpack)
    v <- rep(variation, times = 3)
    iv <- ifelse(v, sum(alpha) * rdirichlet(1, alpha = alpha), alpha)
    p <- ifelse(c(pure, pure), c(sample(2, 1), sample(2, 1)) - 1, rbeta(2, beta_1, beta_2))
    return(c(p, iv, base_fitness, NA))
}

##'
##' Generates a population of size N with row entries of new.individual.row().
##' 
##' @param N The size of the population.
##' @param alpha The alpha value for the Dirichlet distribution.
##' @param beta_1 The first parameter for the Beta distribution.
##' @param beta_2 The first parameter for the Beta distribution.
##' @param variation Whether or not to include variation in the delta values.
##' @param base_fitness Unused.
##' @param pure Whether to use pure strategies. If `true`, generates p and t values of 1 or 0 uniformly.
##' 
##' @return A matrix whose entries are individuals in the population.
##' 
new.population <- function(N, alpha = c(2, 4, 3), beta_1 = 1, beta_2 = 1, base_fitness = 0, variation = TRUE, pure = FALSE) {
    new_data <- t(replicate(N, new.individual.row(alpha, beta_1, beta_2, variation, base_fitness, pure)))
    matrix(new_data, nrow = N, ncol = 7, dimnames = list(seq(1:N), c("p", "t", "d1", "2d2", "3d3", "fit", "pair")))
}