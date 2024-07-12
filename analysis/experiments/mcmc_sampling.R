# cleaning the workspace
rm(list=ls())
graphics.off()

# Load Packages
library(tidyverse)
library(here)
library(rstan)
library(cmdstanr)

#---- Data Load and Shape ----

## df_set1 ----

## load data
# df_cont_recip_Exp1 <- read_csv(here("Data","Converted_Data","Exp1_df_cont_recip.csv"))


## df_set2 ----

## load data
# df_cont_recip_Exp2 <- read_csv(here("Data","Converted_Data","Exp2_df_cont_recip.csv"))


#---- MCMC sampling ----

pars_1H_list <- list(c("mu_a_1", "sigma_a_1", "a_2",
                           "mu_b_1", "sigma_b_1", "b_2", "b_3", 
                           "sigma_y"),
                         c("mu_a_1", "sigma_a_1", "a_2",
                           "mu_b_1", "sigma_b_1", "mu_b_2", "sigma_b_2", "mu_b_3", "sigma_b_3", 
                           "sigma_y"))

## Function ----
create_list <- function(pars_1H) {
   result_list <- list()
   
   for (element in pars_1H) {
      if (grepl("^mu_", element)) {
         result_list[[element]] <- 0
      } else if (grepl("^sigma_", element)) {
         result_list[[element]] <- 1
      }
   }
   
   return(result_list)
}

# Experiment 1----
target_stan_name <- "Exp1_Reciprocity.stan"
target_stan_file <- here("Model_fitting", "Reciprocity_model", target_stan_name)
target_df <- df_cont_recip_Exp1
target_pars_1H <- pars_1H_list[[1]]

dataList <- list(
   N_obs = nrow(target_df), 
   N_sbj = max(target_df$Ind_ID_temp), 
   y = target_df$contr_player, 
   Block = target_df$block_dummy,
   Condition = target_df$cond_dummy,
   Mean_others = target_df$mean_contr_others_prev,
   Iid = target_df$Ind_ID_temp
)

cmd_model <- cmdstan_model(target_stan_file)

## Sampling 
fit <- cmd_model$sample(
   data = dataList,
   seed = 1234,
   chains = 4,
   parallel_chains = 4,
   iter_sampling = 8000,
   iter_warmup = 2000,
   thin = 1, 
   init = function(){
      create_list(target_pars_1H)
   }
)

stanfit_cmd <- rstan::read_stan_csv(fit$output_files()) 

file_name <- paste0(substr(target_stan_name, 1, nchar(target_stan_name) - 5), ".rds")
saveRDS(object = stanfit_cmd, file = here('Data', 'Converted_Data',"stan", file_name))


# Experiment 2----
target_stan_name <- "Exp2_Reciprocity.stan"
target_stan_file <- here("Model_fitting", "Reciprocity_model", target_stan_name)
target_df <- df_cont_recip_Exp2
target_pars_1H <- pars_1H_list[[2]]

dataList <- list(
              N_obs = nrow(target_df),
              N_sbj = max(target_df$Ind_ID_temp), 
              N_grp = max(target_df$Grp_ID_temp),
              y = target_df$contr_player, 
              Block = target_df$block_dummy,
              Condition = target_df$cond_dummy,
              Mean_others = target_df$mean_contr_others_prev,
              Iid = target_df$Ind_ID_temp,
              Gid = target_df$Grp_ID_temp
)

cmd_model <- cmdstan_model(target_stan_file)

## Sampling 
fit <- cmd_model$sample(
   data = dataList,
   seed = 1234,
   chains = 4,
   parallel_chains = 4,
   iter_sampling = 8000,
   iter_warmup = 2000,
   thin = 1, 
   init = function(){
      create_list(target_pars_1H)
   }
)

stanfit_cmd <- rstan::read_stan_csv(fit$output_files()) 

file_name <- paste0(substr(target_stan_name, 1, nchar(target_stan_name) - 5), ".rds")
saveRDS(object = stanfit_cmd, file = here('Data', 'Converted_Data',"stan", file_name))
