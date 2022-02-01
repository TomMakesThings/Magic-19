# Magic-19

For representing the magic 19 puzzle, all points are assigned a letter A - S (Figure
6). Each of the 12 edges consisting of three points is encoded in a binary matrix. Us-
ing function solveMagic19, the simulated annealing algorithm is repeatedly run until
a solution is found, i.e. when the energy / score reaches zero.
To initialize simulated annealing, points A - S are randomly assigned a unique
value between 1 - 19. The score of this initial tour is calculated by the energy func-
tion, calculateScore. This returns the squared sum of the dierence between the total
of each edge and 22. The residual sum of squares was selected so that the algorithm is
more likely to make swaps that bring the edges closer to the desired value. Squaring
ensures that a negative value can never be added to the score.
The annealing process is run until either a stopping condition is met, or a maximum
number of iterations. The temperature per iteration is determined by calculateTem-
perature using the fast simulated annealing temperature function. This is the initial
temperature divided by the number of iterations (Figure 7).
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

A total of four unique solutions were found: three of which have 2 in the center, one of
which has 4. These can be found when running with seeds 540267, 123456, 10 and 250 below.
Additionally when run multiple times, sometimes a solution was found again but with the
order of the points 
ipped. For example seeds 123456, 999 and 112021 all generate the same
solution but with dierent letter allocations.
