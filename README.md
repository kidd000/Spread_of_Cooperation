# Empirical evidence for the spread of cooperation through copying successful groups

This repository contains data and analysis files for the study titled "Empirical evidence for the spread of cooperation through copying successful groups" by Y. Kido and M. Takezawa in preparation.

## Repository Structure

### `data`/
Contains raw and processed data for both experiments and cross-cultural survey.

#### `experiments`/
- `Exp1_raw.csv`: Raw data from Experiment 1
- `Exp2_raw.csv`: Raw data from Experiment 2
- `Exp1_reciprocity.csv`: Processed data for reciprocity model fitting (Experiment 1)
- `Exp2_reciprocity.csv`: Processed data for reciprocity model fitting (Experiment 2)

#### `cross-cultural_survey`/
- `Dataset_Model1.csv`: Integrated dataset for regression Model 1, including:
  - Average scores of multiple World Value Survey items by country
  - World Press Freedom scores
  - Polity scores
- `Dataset_Model2.csv`: Integrated dataset for regression Model 2, including all Model 1 data plus World Bank's Rule of Law variable

### `analysis`/
Contains files used for Bayesian model estimation, divided into experiments and cross-cultural survey.

#### `experiments`/
- `mcmc-sampling.R`: R script for execution
- Associated RStan files

#### `cross-cultural_survey`/
- `mcmc-sampling.R`: R script for execution
- Associated RStan files
