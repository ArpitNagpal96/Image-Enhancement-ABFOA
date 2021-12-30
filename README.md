# Image Enhancement Using Modified Bacterial Foraging Algorithm

The Bacterial Foraging Optimization Algorithm (BFOA) is based on the group foraging properties of bacteria such as E.coli and M.xanthus. In other words, the BFOA is based on the
chemotaxical nature of bacteria that will interpret chemical properties in the environment (such as nutrients) and move toward or away from specific signals based on their
interpretation of nutritional changes in different parts of the sample space. The working strategy of the Bacteria Foraging algorithm is to let the cells collectively swarm
toward optima. This gets accomplished through a series of three stages being applied to a population of simulated cells: Chemotaxis, Reproduction and Elimination-Dispersal.

The above algorithm inspired us to divide the foraging procedure into multiple explore/exploit phases. The step size is varied according to the required fitness at each step, and if the best
fitness is found to be lesser than required fitness, the step size is changed. This modification was made in the original BFOA to dynamically improve the step size at
each generation based on the required fitness value at that generation and the best fitness value obtained.

The purpose of our project is to use the adaptive bacterial foraging algorithm for optimization and subsequently using the same for enhancement of images. This goal is achieved using
MATLAB, wherein we define the optimization within the bacterial foraging code. Here, a segment of bacteria is released into the sample space. A nutrient function and cell to cell
attraction function is defined which gives an idea about the fitness and the strength of the signal released amongst the bacteria, instigating either attraction or repulsion respectively.

The adaptive bacterial foraging algorithm functions by releasing a lump of bacteria, then these bacteria move towards the higher nutrition value, and away from the lower nutrition
value. Subsequently the bacteria with the higher fitness will remain, and those having lower fitness will be eliminated, thereby keeping the swarm size constant. Using the swim and
tumble actions to cover the entire space, and running the chemotaxis, reproduction and elimination dispersion loops we obtain the optimised parameters using which defuzzification
of modified membership functions and final image enhancement takes place.