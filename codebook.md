# Codebook for "Spread of Cooperation" Data Repository

## Overview

This document provides a comprehensive mapping between data files and analysis codes for the study "Empirical evidence for the spread of cooperation through copying successful groups" by Y. Kido and M. Takezawa.

## 1. Experimental Data

### 1.1 Raw Data Files

#### Exp1_raw.csv (Experiment 1 Raw Data)

**Location**: `data/experiments/Exp1_raw.csv`
**Description**: Raw data from Experiment 1 (public goods game with human participants playing with 3 computer agents)
**Number of observations**: 25,200 rows (105 participants)

**Variables**:

- `ID`: Participant identifier (5-digit code)
- `session`: Session number
- `cond`: Experimental condition ('disp' = displayed successful group info, 'no-disp' = control)
- `round`: Round number (1-30 for each block)
- `block`: Block number (1 or 2)
- `player`: Player identifier within group (A, B, C, or 'P' = real participant)
- `contribution`: Player's contribution in the round (0-20 tokens)
- `payoff`: Player's payoff in the round
- `mean_contr_disp`: Mean contribution of the group displayed
- `mean_payoff_disp`: Mean payoff of the group displayed

#### Exp2_raw.csv (Experiment 2 Raw Data)

**Location**: `data/experiments/Exp2_raw.csv`
**Description**: Raw data from Experiment 2 (public goods game with human participants playing in groups of 4)
**Number of observations**: 36,480 rows (152 participants)

**Variables**:

- `ID`: Participant identifier (5-digit code)
- `session`: Session number
- `cond`: Experimental condition ('disp' = displayed successful group info, 'no-disp' = control)
- `group_id`: Group identifier (1-38)
- `round`: Round number (1-30 for each block)
- `block`: Block number (1 or 2)
- `player`: Player identifier within group (A, B, C, or 'P' = real participant)
- `contribution`: Player's contribution in the round (0-20 tokens)
- `payoff`: Player's payoff in the round
- `mean_contr_disp`: Mean contribution of the group displayed
- `mean_payoff_disp`: Mean payoff of the group displayed

### 1.2 Processed Data Files

#### Exp1_reciprocity.csv

**Location**: `data/experiments/Exp1_reciprocity.csv`
**Description**: Processed data for reciprocity analysis in Experiment 1
**Used by**: `analysis/experiments/Exp1_Reciprocity.stan`

#### Exp2_reciprocity.csv

**Location**: `data/experiments/Exp2_reciprocity.csv`
**Description**: Processed data for reciprocity analysis in Experiment 2
**Used by**: `analysis/experiments/Exp2_Reciprocity.stan`

## 2. Cross-Cultural Survey Data

### 2.1 Dataset_Model1.csv

**Location**: `data/cross-cultulral_survey/Dataset_Model1.csv`
**Description**: Integrated dataset for cross-cultural analysis Model 1
**Used by**: `analysis/cross-cultulral_survey/m1_rgnRE0_WPF_Democ.stan`

**Variables**:

- `Country`: Country code (ISO 3-letter)
- `col`: Variable name from World Values Survey
- `n`: Sample size
- `val`: Average value for the variable
- `Year`: Survey year(s)
- `WPF_mean`: World Press Freedom Index (averaged)
- `polity2_M`: Polity IV score (mean)
- `democ_M`: Democracy score (mean)
- `autoc_M`: Autocracy score (mean)
- `Entity`: Country name
- `Region`: Geographic region
- `Region_num`: Region numeric code
- `polity_Bin`: Binary polity classification ('Democ' or 'Autoc')

### 2.2 Dataset_Model2.csv

**Location**: `data/cross-cultulral_survey/Dataset_Model2.csv`
**Description**: Extended dataset including Rule of Law variable
**Used by**: `analysis/cross-cultulral_survey/m2_rgnRE0_WPF_RL_Democ.stan`

**Additional Variables**:

- `RL_mean`: World Bank Rule of Law indicator (mean)

## 3. Analysis Code Files

### 3.1 Experimental Analysis

#### mcmc_sampling.R

**Location**: `analysis/experiments/mcmc_sampling.R`
**Purpose**: Main R script for Bayesian analysis of experimental data
**Dependencies**:

- RStan package
- Exp1_reciprocity.csv
- Exp2_reciprocity.csv
- Exp1_Reciprocity.stan
- Exp2_Reciprocity.stan

**Key Functions**:

1. Data preprocessing for Stan models
2. MCMC sampling configuration
3. Model fitting and diagnostics
4. Result extraction and visualization

#### Exp1_Reciprocity.stan

**Location**: `analysis/experiments/Exp1_Reciprocity.stan`
**Purpose**: Stan model for reciprocity analysis in Experiment 1
**Model Type**: Hierarchical Bayesian model with individual-level reciprocity parameters

#### Exp2_Reciprocity.stan

**Location**: `analysis/experiments/Exp2_Reciprocity.stan`
**Purpose**: Stan model for reciprocity analysis in Experiment 2
**Model Type**: Same structure as Exp1_Reciprocity.stan

### 3.2 Cross-Cultural Survey Analysis

#### mcmc-sampling.R

**Location**: `analysis/cross-cultulral_survey/mcmc-sampling.R`
**Purpose**: Main R script for cross-cultural survey analysis
**Dependencies**:

- RStan package
- Dataset_Model1.csv
- Dataset_Model2.csv
- m1_rgnRE0_WPF_Democ.stan
- m2_rgnRE0_WPF_RL_Democ.stan

#### m1_rgnRE0_WPF_Democ.stan

**Location**: `analysis/cross-cultulral_survey/m1_rgnRE0_WPF_Democ.stan`
**Purpose**: Model 1 - Analyzing relationship between press freedom and prosocial behavior
**Key Variables**: World Press Freedom, Democracy/Autocracy

#### m2_rgnRE0_WPF_RL_Democ.stan

**Location**: `analysis/cross-cultulral_survey/m2_rgnRE0_WPF_RL_Democ.stan`
**Purpose**: Model 2 - Extended model including Rule of Law
**Key Variables**: World Press Freedom, Democracy/Autocracy, Rule of Law
