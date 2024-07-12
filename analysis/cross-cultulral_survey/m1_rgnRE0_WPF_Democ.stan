data{
  
    // data structure
    int<lower=1> N_obs; //Number of observations (number of countries)
    int<lower=1> N_rgn; //Number of regions
    vector[N_obs] y; //Dependent variable
    vector[N_obs] x_1; // Average score for WPF 2013-21
    array[N_obs] int<lower=0, upper=1> x_2; //Dummy variable for democracy or not
    
    // grouping factor
    array[N_obs] int<lower=1, upper=6> Rid; //id representing the region
}

parameters{
    
    // fixed effects
    real mu_a_1; // intercept

    // random effects
    real<lower=0.> sigma_a_1;
    
    real<lower=0.> sigma_y;
    vector[N_rgn] a_1;
    real a_2;
    real b_1;
    real b_2;

}

transformed parameters {
    // regression
    vector[N_obs] mu;
    for (i in 1:N_obs) {
        mu[i] = a_1[Rid[i]] + a_2 * x_2[i] + x_1[i] * (b_1 + b_2 * x_2[i]);
    }
}

model{
    
    // prior
    target += uniform_lpdf(sigma_a_1 | 0, 100);
    target += uniform_lpdf(sigma_y | 0, 100);
    
    target += normal_lpdf(mu_a_1 | 0, 100); 

    // likelihood
    for (j in 1:N_rgn) {
        a_1[j] ~ normal(mu_a_1, sigma_a_1);
    }
    
    for (i in 1:N_obs) {
        target += normal_lpdf(y[i] | mu[i], sigma_y);
    }

}

generated quantities{
    // b_1 + b_2
    real b_1_2 = b_1 + b_2;
    
    // replicate
    vector[N_obs] y_rep;
    for (i in 1:N_obs) {
        y_rep[i] = normal_rng(mu[i], sigma_y);
    }
}
