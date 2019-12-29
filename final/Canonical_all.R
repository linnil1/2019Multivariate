require(CCA)
require(CCP)

data = read.csv("data/all_merged_A.csv", header=T)

# col_store = c("food_mean_mean", "rate_mean", "food_num_sum", "rate_num_sum", "store_num", "money1", "money2", "money3")
# col_distr = c("cost_inside", "cost_outside", "crash_num", "scooter10810", "crash_scooter", "d_scooter108", "income", "house10811", "population10811", "sex_rate")
col_store = c("food_mean_mean", "rate_mean", "food_num_sum", "rate_num_sum", "store_num", "money1", "money2", "money3")
col_distr = c("cost_inside", "cost_outside", "crash_num", "scooter10810", "crash_scooter", "income", "population10811", "sex_rate")

data_store = data[, col_store]
data_distr = data[, col_distr]

data_store
data_distr

fit = cc(data_store, data_distr)
fit
fit$cor

rho <- fit$cor
## Define number of observations, number of variables in first set, and number of variables in the second set.
n <- dim(data_store)[1]
p <- length(data_store)
q <- length(data_distr)

## Calculate p-values using the F-approximations of different test statistics:
p.asym(rho, n, p, q, tstat = "Hotelling")

