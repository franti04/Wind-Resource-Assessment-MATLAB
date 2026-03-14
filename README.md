Welcome to the repository for our Wind Resource Assessment project, developed as part of the Electrical Energy Engineering curriculum at the University of Bologna. This repository contains a robust MATLAB-based Monte Carlo simulation designed to evaluate wind energy producibility.

The core problem this software addresses is determining the optimal minimum number of wind speed samples required to accurately estimate the scale (α) and shape (β) parameters of a Weibull probability distribution. Accurate parameter estimation is critical for assessing the wind profile of a potential wind farm site.

Starting with known parameters (α=19 m/s and β=3.1), our main MATLAB script runs Monte Carlo simulations ranging from 100 to 10,000 iterations. For each iteration, the program generates small sample batches (from n=3 to n=40) using the inverse transform method. We then calculate the cumulative probability using Blom's estimator.

To estimate the parameters from these small samples, the software linearizes the Weibull function and applies linear regression on a Weibull probability plot. The simulation carefully analyzes the statistical distributions of the estimated parameters, calculating the expected value, median, standard deviation, and 95% confidence intervals for each sample size. Furthermore, the code computes the extractable electrical power using the standard aerodynamic power formula (P=1/2ρAv^3), relying on the median α value as the reference wind speed.

Our rigorous statistical analysis reveals that a minimum of 10 samples is strictly necessary to keep the estimation error for both parameters below 15%. Using fewer samples severely destabilizes the shape parameter (β), leading to a dangerous overestimation of the site's energy potential.

This project demonstrates advanced MATLAB programming concepts, including matrix pre-allocation for memory management, custom function modularity, statistical plotting, and the practical application of the Law of Large Numbers.
