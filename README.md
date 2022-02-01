# Solving the Magic 19 Puzzle through Simulated Annealing
## The Problem
Given 19 dots arranged in a hexagon, the task is to label the dots with the numbers 1 to 19 so that each set of three dots that lie along a straight-line segment add up to 22.

<img src="https://github.com/TomMakesThings/Magic-19/blob/assets/Images/Hexagon.png" width=350>

## Simulated Annealing
Simulated annealing is a iterative, heuristic method for solving optimisation problems. Within each iteration, a random swap between two neighbouring states is proposed. If this swap improves the solution through lowering the system's energy E, it is always accepted. Otherwise, it may still make the change with probability less than 1. This probability is determined by the temperature of the system T. At the beginning, T is initialised as a high value. It then decreases over iterations via an annealing schedule, evenutally reaching zero. This has the effect that at the start, the algorithm explore the search place. As time progresses, the system converging to a minimum energy state.

## Solving the Puzzle through Simulated Annealing

To represent the magic 19 puzzle, all points can be assigned a letter A - S. This allows each of the 12 edges consisting of three points to be encoded in a binary matrix.

<img src="https://github.com/TomMakesThings/Magic-19/blob/assets/Images/Hexagon-Alphabet.png" width=350>
 
To initialise simulated annealing, points A - S are randomly assigned a unique value between 1 - 19. The score of this initial tour is calculated by the energy function. This returns the squared sum of the difference between the total of each edge and 22. The residual sum of squares was selected so that the algorithm is more likely to make swaps that bring the edges closer to the desired value. Squaring ensures that a negative value can never be added to the score.

<img src="https://render.githubusercontent.com/render/math?math=$RSS = \sum_{i=1}^{n}(v - 22)^2$">

The annealing process is run until either a stopping condition is met, or a maximum number of iterations. The temperature per iteration is determined using the fast simulated annealing temperature function. This is the initial temperature divided by the number of iterations.

<img src="https://github.com/TomMakesThings/Magic-19/blob/assets/Images/Annealing-Schedule.png" width=500>

The probability of acceptance is calculated using the Metropolis acceptance cri-
terion. For temperature greater than zero, this is the exponential of the dierence
between the previous and new score divided by temperature. For temperature of zero,
if the new tour has a higher score then this is set as 1 allowing it to be kept. Similarly, if the new tour is worse then acceptance is set at 0 so it is discarded. The acceptance
rate is then compared against a random number generated from a uniform distribution
and if acceptance is higher, then the new tour is accepted as the current tour.
Before the end of each iteration, the stopping conditions are checked. Simulated
annealing will end if either a solution was found, or if the algorithm converged to a
local optimum. This approach was chosen as the algorithm can get stuck at a local
optimum if temperature is too low it is more eective to restart the annealing process.

As simulated annealing algorithm doesn't always converge to a global optimum, it must be repeatedly run until a solution is found, i.e. when the energy reaches zero.

## Solutions
A total of four unique solutions were found: three of which have 2 in the center, one of which has 4. When run multiple times, sometimes a solution is found again but with the
order of the points fipped.

<img src="https://github.com/TomMakesThings/Magic-19/blob/assets/Images/Hexagon-Solutions.png" width=600>
