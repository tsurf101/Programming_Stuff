# Tom test try for MC 

library(tidyquant)
library(tidyverse)
library(timetk)
library(broom)

# SPY (S&P500 fund) weighted 50%
# EFA (a non-US equities fund) weighted 10%
# IJS (a small-cap value fund) weighted 15%
# EEM (an emerging-mkts fund) weighted 20%
# AGG (a bond fund) weighted 5%

# Our Funds 
symbols <- c("SPY","EFA", "IJS", "EEM","AGG")

# Getting prices for 4 years from Yahoi
prices <- 
  getSymbols(symbols, src = 'yahoo', 
             from = "2015-09-30",
             to = "2020-09-30",
             auto.assign = TRUE, warnings = FALSE) %>% 
  map(~Ad(get(.))) %>%
  reduce(merge) %>% 
  `colnames<-`(symbols)

# Our weightings 
w <- c(0.50, 0.10, 0.15, 0.20, 0.05)

asset_returns_long <-  
  prices %>% 
  to.monthly(indexAt = "lastof", OHLC = FALSE) %>% 
  tk_tbl(preserve_index = TRUE, rename_index = "date") %>%
  gather(asset, returns, -date) %>% 
  group_by(asset) %>%  
  mutate(returns = (log(returns) - log(lag(returns)))) %>% 
  na.omit()

portfolio_returns_tq_rebalanced_monthly <- 
  asset_returns_long %>%
  tq_portfolio(assets_col  = asset, 
               returns_col = returns,
               weights     = w,
               col_rename  = "returns",
               rebalance_on = "months")

# Finding the mean  & stddev 

mean_port_return <- 
  mean(portfolio_returns_tq_rebalanced_monthly$returns)

stddev_port_return <- 
  sd(portfolio_returns_tq_rebalanced_monthly$returns)


# 120 below is 10 years of simulation 
simulated_monthly_returns <- rnorm(120, 
                                   mean_port_return, 
                                   stddev_port_return)

head(simulated_monthly_returns)

tail(simulated_monthly_returns)

# We examine the growth of a $1 given these random monthly returns 
simulated_returns_add_1 <- 
  tibble(c(1, 1 + simulated_monthly_returns)) %>% 
  `colnames<-`("returns")

head(simulated_returns_add_1)
