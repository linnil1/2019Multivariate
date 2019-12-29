data = read.csv("data/all_merged.csv")
data

null = lm(store_num ~ 1, data = data)  
# full = lm(store_num ~ food_mean_mean+food_num_mean+rate_num+cost+crash_num+scooter108+income, data = data)
full = lm(store_num ~ food_mean_mean+income+rate_mean+scooter10811+income+crash_num+cost_outside, data = data)

result <- step(null, 
     scope=list(lower=null, upper=full), 
     direction="forward")

summary(result)

