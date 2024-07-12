data{
  
    // data structure
    int<lower=1> N_obs; //Number of observations
    int<lower=1> N_sbj; //Number of participants
    vector<lower=0, upper=20>[N_obs] y; //Dependent variable
    array[N_obs] int<lower=0, upper=1> Block; //Dummy variables for blocks
    array[N_obs] int<lower=0, upper=1> Condition; //Dummy variables for conditions
    vector<lower=0, upper=20>[N_obs] Mean_others; //Mean contribution of others
    
    // grouping factor
    array[N_obs] int<lower=1, upper=N_sbj> Iid; //id representing individuals
    
}

parameters{
    
    // fixed effects
    real mu_a_1; // intercept
    real mu_b_1; // slope

    // random effects
    real<lower=0.> sigma_a_1;
    real<lower=0.> sigma_b_1;
    
    real<lower=0.> sigma_y;
    
    vector[N_sbj] a_1;
    real a_2;
    vector[N_sbj] b_1;
    real b_2;
    real b_3;

}

transformed parameters {
    // regression
    vector[N_obs] mu;
    for (o in 1:N_obs) {
        mu[o] = a_1[Iid[o]] + a_2 * Block[o] + 
        Mean_others[o] * (b_1[Iid[o]] + b_2 * Block[o] + b_3 * Block[o] * Condition[o]);
    }
}

model{
    
    // prior
    target += uniform_lpdf(sigma_a_1 | 0, 100);
    target += uniform_lpdf(sigma_b_1 | 0, 100);
    target += uniform_lpdf(sigma_y | 0, 100);
    
    target += normal_lpdf(mu_a_1 | 0, 100); 
    target += normal_lpdf(mu_b_1 | 0, 100); 

    // likelihood
    for (i in 1:N_sbj) {
        a_1[i] ~ normal(mu_a_1, sigma_a_1);
        b_1[i] ~ normal(mu_b_1, sigma_b_1);
    }
    
    for (o in 1:N_obs) {
        target += normal_lpdf(y[o] | mu[o], sigma_y);
    }

}

generated quantities{
    // parameters
    vector[N_obs] a_1_2;
    vector[N_obs] b_1_2;
    vector[N_obs] b_1_2_3;

    // replicate
    vector[N_obs] y_rep;
    
    for (o in 1:N_obs) {
        a_1_2[o] = a_1[Iid[o]] + a_2;
        b_1_2[o] = b_1[Iid[o]] + b_2;
        b_1_2_3[o] = b_1[Iid[o]] + b_2 + b_3;
        y_rep[o] = normal_rng(mu[o], sigma_y);
    }
}
