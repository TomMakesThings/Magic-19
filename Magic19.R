# Number of points and 3 point edges
n_dots <- 19
n_edges <- 12

# Initial temperature and maximum number of iterations to run simulated annealing
start_temperature <- 10
maximum_iterations <- 25000

# First 6 are outer edges, last 6 are inner edges
edge_matrix <- matrix(c(1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  # A,B,C
                        0,0,1,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,  # C,G,L
                        0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,1,  # L,P,S
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,  # S,R,Q
                        0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,1,0,0,  # Q,M,H
                        1,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,  # H,D,A
                        1,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,  # A,E,J
                        0,0,1,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,  # C,F,J
                        0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,  # L,K,J
                        0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,1,  # S,O,J
                        0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,0,  # Q,N,J
                        0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0), # H,I,J
                      nrow = n_edges, byrow = T)

# Assign a letter to each point
dot_names <- LETTERS[1:n_dots]
dimnames(edge_matrix) <- list(c(), dot_names)

# Convert from binary to get the three letters on each edges
letter_edges <- t(apply(edge_matrix, 1, function(x) LETTERS[(which(x == 1))]))

# Fast simulated annealing temperature function
calculateTemperature <- function(initial_temp, iteration) {
  return(initial_temp / (iteration + 1))
}

# The objective function, i.e. a metric to evaluate the tour
calculateScore <- function(edges, new_tour) {
  # Set initial score as lowest possible score
  score <- 0
  
  # Loop over each edge and calculate residual sum of squares
  for (i in 1:nrow(edges)) {
    # Get the values assigned to each dot on an edge
    edge_values <- edges[i,]
    
    # Add difference to score
    score <- score + ((sum(new_tour[edge_values,]) - 22) ^ 2)
  }
  
  return(score)
}

# Metropolis acceptance criterion
calculateAcceptance <- function(score_new, score_current, temperature) {
  if (temperature > 0) {
    return(exp(-(score_new - score_current) / temperature))
  }
  else {
    return(as.numeric(score_new < score_current))
  }
}

# Solve the puzzle using simulated annealing
magic19SimulatedAnnealing <- function(edges, initial_temp = 10, max_iterations = 10000,
                                      tolerance = 2500) {
  # Create empty vector to record scores over iterations
  tour_scores <- c()
  
  # Set random initial values for dots between 1 and 19
  tour <- data.frame(value = sample(1:19))
  row.names(tour) <- dot_names
  
  # Calculate and record the initial score
  score <- calculateScore(edges, tour)
  tour_scores <- c(tour_scores, score)
  
  # Run simulated annealing up to a maximum of n times
  for (i in 1:max_iterations) {
    # Get the temperature for the iteration
    temperature <- calculateTemperature(initial_temp, i)
    new_tour <- tour
    
    # Randomly select two dots
    switch_dot_names <- sample(row.names(new_tour), 2)
    value_1 <- new_tour[switch_dot_names[1], ]
    value_2 <- new_tour[switch_dot_names[2], ]
    
    # Switch the two values in the new tour
    new_tour[switch_dot_names[1], ] <- value_2
    new_tour[switch_dot_names[2], ] <- value_1
    
    # Re-evaluate score for the new values
    new_score <- calculateScore(edges, new_tour)
    # Calculate the acceptance score
    acceptance <- calculateAcceptance(new_score, score, temperature)
    
    # Generate random number from normal distribution and compare to acceptance rate
    if ((runif(1) < acceptance)) {
      # Set the current tour as the new tour
      tour <- new_tour
      score <- new_score
    }
    
    if (i %% 10 == 0) {
      # Record the new score
      tour_scores <- c(tour_scores, score)
    }
    
    # Stop if a solution is found or it has converged to a local optimum
    if (score == 0 || max(table(tour_scores)) >= (tolerance/10)) {
      break
    }
  }
  
  return(list(tour = tour, scores = tour_scores))
}

# Plot the magic 19 graph
plotMagic19 <- function(point_labels = NULL, title = "") {
  # x and y coordinates for a hexagon
  hex_coords <- data.frame(x = c(-2, 2, 4, 2, -2, -4),
                           y = c(3.5, 3.5, 0, -3.5, -3.5, 0))
  # x and y for rotated hexagon
  rotated_hex_coords <- data.frame(x = c(0, 3, 3, 0, -3, -3),
                                   y = c(3.5, 1.75, -1.75, -3.5, -1.75, 1.75))
  # Create all points for magic 19
  hex_points <- do.call("rbind", list(hex_coords, # Outer hexagon
                                      rotated_hex_coords, # Rotated outer hexagon
                                      hex_coords * 0.5, # Innter hexagon
                                      c(0, 0))) # Center
  # Name each point with a letter
  row.names(hex_points) <- c("A", "C", "L", "S", "Q", "H",
                             "B", "G", "P", "R", "M", "D",
                             "E", "F", "K", "O", "N", "I",
                             "J")
  # Order the points alphabetically and add the values found in the best tour
  hex_points <- hex_points[order(row.names(hex_points)), ]
  hex_points$values <- point_labels
  
  # Create blank plot
  plot(hex_coords$x, hex_coords$y, type = "n", axes = FALSE,
       xlab = "", ylab = "", main = title)
  
  # Plot outer dots, inner dots and center dot
  points(hex_points$x, hex_points$y, pch = 19)
  
  # Plot inner lines
  for (i in 1:3) {
    segments(x0 = hex_coords[i,]$x, y0 = hex_coords[i,]$y,
             x1 = hex_coords[i+3,]$x, y1 = hex_coords[i+3,]$y)
  }
  # Plot outer lines
  for (j in 1:6) {
    segments(x0 = hex_coords[j,]$x, y0 = hex_coords[j,]$y,
             x1 = hex_coords[(j%%6)+1,]$x, y1 = hex_coords[(j%%6)+1,]$y)
    points(hex_coords$x, hex_coords$y, pch = 19)
  }
  
  # Add text to dots
  if (is.null(point_labels)) {
    text(hex_points$x, hex_points$y, row.names(hex_points), cex = 2, col = "red")
  } else {
    text(hex_points$x, hex_points$y, hex_points$value[,], cex = 2, col = "red")
  }
}

# Run simulated annealing until solution found
solveMagic19 <- function(initial_temp, max_iterations, tolerance = 2500,
                         verbose = 0) {
  # Keep track of the lowest score
  best_energy <- Inf
  
  # Repeat until score of 0 reached
  while (best_energy != 0) {
    results <- magic19SimulatedAnnealing(letter_edges,
                                         initial_temp = initial_temp,
                                         max_iterations = max_iterations,
                                         tolerance = tolerance)
    final_score <- tail(results$scores, n = 1)
    
    # Display progress
    if (verbose > 0) {
      if (final_score != 0) {
        message(paste("Converged at", tail(results$scores, n = 1)))
        # print(table(results$scores))
      } else {
        message("Solution found")
      }
    }
    
    if (min(results$scores) < best_energy) {
      best_energy <- min(results$scores)
    }
  }
  
  return(results)
}

# Plot annealing schedule
temp_over_time <- lapply(1:maximum_iterations, calculateTemperature, initial_temp = start_temperature)
plot(1:maximum_iterations, temp_over_time, type = "l", lty = 1, xlab = "Time", ylab = "Temperature",
     main = "Annealing Schedule")

# Plot unsolved puzzle labelled with letters
par(mfrow = c(2, 3), mar = c(2,3,1.5,1))
plotMagic19(NULL, "Point Letter Allocations")

# First unique solution with 2 in center
# Solution with 2 in center
set.seed(540267)
solved_puzzle_1 <- solveMagic19(start_temperature, maximum_iterations)
plotMagic19(solved_puzzle_1$tour, "Solution 1")

# Second unique solution with 4 in center
set.seed(123456)
solved_puzzle_2 <- solveMagic19(start_temperature, maximum_iterations)
plotMagic19(solved_puzzle_2$tour, "Solution 2")
# # Reverse of solution above
# set.seed(999)
# solved_puzzle_2b <- solveMagic19(start_temperature, maximum_iterations)
# plotMagic19(solved_puzzle_2b$tour, "Solution 2")
# # Rotation of solution above
# set.seed(112021)
# solved_puzzle_2c <- solveMagic19(start_temperature, maximum_iterations)
# plotMagic19(solved_puzzle_2c$tour, "Solution 2")

# Third unique solution with 2 in center
set.seed(10)
solved_puzzle_3 <- solveMagic19(start_temperature, maximum_iterations)
plotMagic19(solved_puzzle_3$tour, "Solution 3")

# Forth unique solution  with 2 in center
set.seed(250)
solved_puzzle_4 <- solveMagic19(start_temperature, maximum_iterations)
plotMagic19(solved_puzzle_4$tour, "Solution 4")
