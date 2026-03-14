University of Bologna - Electrical Energy Engineering

Project Overview
This project addresses a critical challenge in wind engineering: determining the reliability of site assessments based on limited data. Using MATLAB, my team and I developed a Monte Carlo simulation to evaluate the minimum number of wind speed samples required to accurately estimate the Weibull distribution parameters (α and β). Our goal was to ensure that the estimation error for both parameters remains below a 15% threshold to prevent incorrect energy production forecasts.

Technical Methodology
Starting with known "true" values (α=19 m/s and β=3.1), the simulation performs the following steps:

Monte Carlo Iterations: The process is repeated for M iterations (ranging from 100 to 10,000) to ensure statistical stability.

Sample Extraction: For each iteration, the program generates sample batches of varying sizes (n=3,5,10,20,40) using the inverse transform method.

Linearization: We calculate the cumulative probability using Blom's estimator: F=(i−0.5)/(n+0.25).

Parameter Estimation: The Weibull function is linearized to fit a Y=mX+q format, where β is the slope and α is derived from the intercept. Linear regression is then applied to estimate the parameters for each batch.

Results and Conclusions
Our analysis highlights the extreme sensitivity of the shape parameter (β). While the scale parameter (α) stabilizes quickly, β requires more data to converge.

Optimal Sample Size: We determined that n=10 is the minimum number of samples needed to achieve an error rate under 15% for both parameters.

Power Impact: Using only 3 samples results in a 57% error in β and a significant overestimation of extractable power (~191 kW vs. the stable ~172 kW).

Stability: High-iteration counts (M≥5,000) are necessary to eliminate numerical noise and validate these statistical thresholds.
