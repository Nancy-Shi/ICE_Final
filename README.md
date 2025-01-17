# ICE_Final
We share the code and output for each of the pairwise or hyper-edge curves for the information single-layer model. The final plot in the paper combines these curves in a single plot.
The other ipynb files are for the main 3-layer model used to get the simulation outputs. We also share the csv output for the heatmaps. 
Figures in the manuscript are plotted in Matlab using the outputs from the python model. 

# Simulation procedures and layer-connection implementation
Each state transition (or event) has a probability of occurring, and the sum event probabilities is the total probability. For example, the probability for rumour spreading has $\lambda$ multiplied by the number of infected edges. If a state transition is interaction-based, then the probability is the rate multiplied by the relevant edges in the corresponding layer. If a state transition is spontaneous, then the probability equals the rate multiplied by the relevant number of individuals. For instance, disease recovery probability has $\mu$ multiplied by the number of infected. For each event, we draw a event probability from the total probability. Then under that event, we use conditional statements and examine network features to decide if the event will happen. For example, the choice of a gossip spreader node within a gossip spreading event is proportional to the node degree.  The time increment at each step is non-fixed. We follow a continuous time stochastic process to simulate the event. 

For simulation, we follow the idea of Gillespie algorithm with the following main steps:
1. Generate a list with all possible processes (state transitions) with their respective rates.
2. Obtain the time increment, $\tau$, until the next event, by sampling from the exponential distribution. The time step is selected by $\tau = -\ln u/R$, such that $u$ is drawn from a random uniform distribution on $(0,1)$ while $R$ is the total rate of all possible processes. 
3. Select the next process $p$ to happen with probability $\lambda_p/R$ where $\lambda_p$ denotes the rate of the process. Perform the process and update the state of the system.
4. Advance the simulation time by $\tau$, and return to step 1.
   
The Gillespie algorithm was introduced in: Gillespie, Daniel T. "A general method for numerically simulating the stochastic time evolution of coupled chemical reactions." Journal of computational physics 22, no. 4 (1976): 403-434. https://doi.org/10.1016/0021-9991(76)90041-3

How we connect layers is by examining the features of the chosen node in another layer (such as fraction of neighbours of a certain type), and then decide if the transition will happen or not. For example, if we want to shift from protected ($P$) to non-protected ($N$), and we want to base the transition upon the information layer's local feature. We will first randomly choose a protected node. Then we check and record its gossip neighbor fraction ($\rho_\text{G}$) and global infected fraction  ($\rho_\text{G}$) and plug into the state shifting function in our manuscript. Finally, we draw a random uniform number to compare with the function result and decide if the transition will occur.
