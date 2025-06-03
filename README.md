# Empirical evidence for the spread of cooperation through copying successful groups

This repository contains data and analysis files for the study titled "Empirical evidence for the spread of cooperation through copying successful groups" by Y. Kido and M. Takezawa in preparation.

## Repository Structure

### `data`/

Contains raw and processed data for both experiments and cross-cultural survey.

#### `experiments`/

- `Exp1_raw.csv`: Raw data from Experiment 1 (105 participants)
- `Exp2_raw.csv`: Raw data from Experiment 2 (152 participants)
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

- `mcmc_sampling.R`: Main R script for Bayesian analysis
- `Exp1_Reciprocity.stan`: Stan model for Experiment 1
- `Exp2_Reciprocity.stan`: Stan model for Experiment 2

#### `cross-cultural_survey`/

- `mcmc-sampling.R`: Main R script for cross-cultural analysis
- `m1_rgnRE0_WPF_Democ.stan`: Model 1 (Press Freedom & Democracy)
- `m2_rgnRE0_WPF_RL_Democ.stan`: Model 2 (including Rule of Law)

### Data Structure

For detailed information about data variables and structure, please refer to `codebook.md`.

## Key Variables

### Experimental Data

- `participant.code`: Unique participant ID
- `condition`: Experimental condition (disp/no-disp)
- `block`: Game block (1stBlock/2ndBlock)
- `round`: Round number (1-30 per block)
- `contr`: Participant contribution
- `payoff`: Round payoff

### Cross-Cultural Data

- `Country`: ISO 3-letter country code
- `WPF_mean`: World Press Freedom Index
- `polity2_M`: Polity IV score
- `val`: Average value for World Values Survey items

## Citation

If you use this data or code, please cite:

Kido, Y., & Takezawa, M. (in preparation). Empirical evidence for the spread of cooperation through copying successful groups.

## Contact

For questions about the data or analysis, please contact the authors.
