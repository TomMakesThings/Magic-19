<div align="center">
  <h1>Simulated Annealing Magic 19 Puzzle Solver</h1>
  <img src="https://images.weserv.nl/?url=avatars.githubusercontent.com/u/61354833?v=4&h=100&w=100&fit=cover&mask=circle&maxage=7d">
  <p><b>⬢⬢⬢ Code by <a href="https://github.com/TomMakesThings">TomMakesThings</a></b> ⬢⬢⬢</p>
  <p><b><sub>October 2021</sub></b></p>
</div>

---

## The Problem
Given 19 dots arranged in a hexagon, the task is to label the dots with the numbers 1 to 19 so that each set of three dots that lie along a straight-line segment add up to 22.

<img src="https://github.com/TomMakesThings/Magic-19/blob/assets/Images/Hexagon.png" width=320>

## Simulated Annealing
Simulated annealing is a iterative, heuristic method for solving optimisation problems. Within each iteration, a random swap between two neighbouring states is proposed. If this swap improves the solution through lowering the system's energy E, it is always accepted. Otherwise, it may still make the change with probability less than 1. This probability is determined by the temperature of the system T. At the beginning, T is initialised as a high value. It then decreases over iterations via an annealing schedule, evenutally reaching zero. This has the effect that at the start, the algorithm explore the search place. As time progresses, the system converging to a minimum energy state.

## Solving the Puzzle through Simulated Annealing

To represent the magic 19 puzzle, all points can be assigned a letter A - S. This allows each of the 12 edges consisting of three points to be encoded in a binary matrix.

<img src="https://github.com/TomMakesThings/Magic-19/blob/assets/Images/Hexagon-Alphabet.png" width=320>
 
To initialise simulated annealing, points A - S are randomly assigned a unique value between 1 - 19. The score of this initial tour is calculated by the Residual sum of squares (RSS) energy function. This is the squared sum of the difference between the total of each edge and the target value 22.

$RSS = \sum_{i=1}^{n}(e - 22)^2$

The annealing process is run until either the energy reaches zero, or a maximum number of iterations is reached. The temperature per iteration is determined using the fast simulated annealing temperature function. This is the initial temperature divided by the number of iterations.

$T = \frac{T_{0}}{iterations}$

<img src="https://github.com/TomMakesThings/Magic-19/blob/assets/Images/Annealing-Schedule.png" width=500>

The probability of acceptance is calculated using the Metropolis acceptance criterion. For temperature greater than zero, this is the exponential of the diverence
between the current and new score divided by temperature. For temperature of zero, if the new tour has a higher score then this is set as 1 allowing it to be kept. Similarly, if the new tour is worse then acceptance is set at 0 so it is discarded. The acceptance rate is then compared against a random number generated from a uniform distribution and if acceptance is higher, then the new tour is accepted as the current tour.

$C(T > 0) = e^{- (score(new) - score(current))/T}$

Before the end of each iteration, the stopping conditions are checked. The process will end if either a solution was found, or the algorithm converged to a local optimum. As simulated annealing doesn't always converge to a global optimum, it can get stuck at a local optimum if temperature is too low. Therefore it is more effective to restart the annealing process and try again until the energy of the system reaches zero.

## Solutions
A total of four unique solutions can be found: three of which have 2 in the center, one of which has 4. When the program is run multiple times, sometimes a solution is found again but with the order of the points fipped.

<img src="https://github.com/TomMakesThings/Magic-19/blob/assets/Images/Hexagon-Solutions.png" width=600>
