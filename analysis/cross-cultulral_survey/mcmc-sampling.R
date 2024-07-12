# cleaning the workspace
rm(list=ls())
graphics.off()

# Load Packages
library(tidyverse)
library(here)
library(rstan)
library(cmdstanr)

#---- Data Load and Shape ----

## Model1 ----

## load data
# Dataset_Model1 <- readRDS(file = here("Convert_Data", "Dataset", "Dataset_Model1.rds"))

## shape data
dep_vars_set1 <- c("GeneralTrust_M", "TrustForeigner_M", "TrustPagan_M", "TrustStranger_M", 
              "TrustFamily_M", "FightForCountry_M", "SocialNormObedience_M")

df_list <- list()

for (dep_var in dep_vars_set1){
    Dataset_Model1 %>% 
                filter(col == dep_var) %>%
                select(Entity, val, WPF_mean, polity_Bin, Region_num) %>%
                mutate(obs_id = row_number(),
                       polity_Bin = case_when(
                                polity_Bin == "Democ" ~ 1,
                                polity_Bin == "Autoc" ~ 0,
                                TRUE ~ NA
                       )) %>%
                rename(y = val, x_1 = WPF_mean, x_2 = polity_Bin) %>% 
                filter(if_all(everything(), ~ !is.na(.))) %>% 
                mutate(across(all_of(c("y", "x_1")), standardize))-> df_list[[dep_var]]
}

## Model2 ----
## load data
# Dataset_Model2 <- readRDS(file = here("Convert_Data", "Dataset", "Dataset_Model2.rds"))

## shape data
dep_vars_set1 <- c("GeneralTrust_M", "TrustForeigner_M", "TrustPagan_M", "TrustStranger_M", 
                   "TrustFamily_M", "FightForCountry_M", "SocialNormObedience_M")

df_list <- list()

for (dep_var in dep_vars_set1){
    Dataset_Model2 %>% 
        filter(Series == "Rule of Law: Estimate") %>%
        filter(col == dep_var) %>%
        select(Entity, val, Value, WPF_mean, polity_Bin, Region_num) %>%
        mutate(obs_id = row_number(),
               polity_Bin = case_when(
                   polity_Bin == "Democ" ~ 1,
                   polity_Bin == "Autoc" ~ 0,
                   TRUE ~ NA
               )) %>%
        rename(y = val, x_1 = WPF_mean, x_2 = polity_Bin, x_3 = Value) %>% 
        filter(if_all(everything(), ~ !is.na(.))) %>% 
        mutate(across(all_of(c("y", "x_1", "x_3")), standardize))-> df_list[[dep_var]]
}



#---- MCMC sampling ----

## Model1 ----

# stanファイルのリスト
file_list <- list.files(path = here("Script", "stan"), pattern = "^m1.*\\.stan$", full.names = FALSE)

tmp_pars_1H_vec <- c("b_1", "b_2", "mu_a_1", "sigma_a_1", "a_2", "sigma_y")
tmp_pars_2H_vec <- c("a_1[1]", "a_1[2]", "a_1[3]", "a_1[4]", "a_1[5]", "a_1[6]")

for (target_dep_var in c(dep_vars_set1)){

    target_df <- df_list[[target_dep_var]]
    
    dataList <- list(N_obs = nrow(target_df), 
                     N_rgn = max(target_df$Region_num),
                     y = target_df$y, 
                     x_1 = target_df$x_1,
                     x_2 = target_df$x_2,
                     Rid = target_df$Region_num
    )
    

    for (target_stan_file in "m1_rgnRE0_WPF_Democ.stan"){ 

        cmd_model <- cmdstan_model(here("Script", "stan", target_stan_file))
        
        pars_1H <- tmp_pars_1H_vec 

        pars_2H <- tmp_pars_2H_vec 
        
        ## Sampling 
        fit <- cmd_model$sample(
            data = dataList,
            seed = 1234,
            chains = 4,
            parallel_chains = 4,
            iter_sampling = 80000,
            iter_warmup = 20000,
            adapt_delta = 0.95, 
            thin = 2, 
            init = function(){
                create_list(pars_1H)
            }
        )

        stanfit_cmd <- rstan::read_stan_csv(fit$output_files()) 
        
        file_name <- paste0(substr(target_stan_file, 1, nchar(target_stan_file) - 5), "_", target_dep_var, ".rds")
        saveRDS(object = stanfit_cmd, file = here('Convert_Data',"stan", file_name))
            
    }
        
}


## Model2 ----

# stanファイルのリスト
file_list <- list.files(path = here("Script", "stan", "WPF_RL"), pattern = "\\.stan$", full.names = FALSE)

tmp_pars_1H_vec <- c("b_1", "b_2", "b_3", "b_4", "mu_a_1", "sigma_a_1", "a_2", "sigma_y")
tmp_pars_2H_vec <- c("a_1[1]", "a_1[2]", "a_1[3]", "a_1[4]", "a_1[5]", "a_1[6]")

for (target_dep_var in c(dep_vars_set1)){
    print(paste0("target_dep_var: ", target_dep_var))
    target_df <- df_list[[target_dep_var]]
    
    dataList <- list(N_obs = nrow(target_df), 
                     N_rgn = max(target_df$Region_num), 
                     y = target_df$y, 
                     x_1 = target_df$x_1,
                     x_2 = target_df$x_2,
                     x_3 = target_df$x_3,
                     Rid = target_df$Region_num
    )
    
    for (i in 1:length(file_list)){ 
        target_stan_file <- file_list[[i]]
        print(paste0("target_model: ", target_stan_file))
        cmd_model <- cmdstan_model(here("Script", "stan", "WPF_RL", target_stan_file)) 
        
        pars_1H <- tmp_pars_1H_vec
        pars_2H <- tmp_pars_2H_vec
        
        ## Sampling 
        fit <- cmd_model$sample(
            data = dataList,
            seed = 1234,
            chains = 4,
            parallel_chains = 4,
            iter_sampling = 160000,
            iter_warmup = 40000,
            adapt_delta = 0.95,  
            thin = 2,  
            init = function(){
                create_list(pars_1H)
            }
        )
        
        stanfit_cmd <- rstan::read_stan_csv(fit$output_files()) 
        
        file_name <- paste0(substr(target_stan_file, 1, nchar(target_stan_file) - 5), "_", target_dep_var, ".rds")
        saveRDS(object = stanfit_cmd, file = here('Convert_Data',"stan", file_name))

    }
    
}
