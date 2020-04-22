library(anytime)
library(data.table)
library(dplyr)
library(ggplot2)


# Specify data file -----------------------------------------------------------

if (file.exists("./data/train.csv")) {
  f_train <- "./data/train.csv"
} else {
  f_train <- "https://recsys2019data.trivago.com/train.csv"
}

if (file.exists("./data/test.csv")) {
  f_test <- "./data/test.csv"
} else {
  f_test <- "https://recsys2019data.trivago.com/test.csv"
}


# Function definitions --------------------------------------------------------

#' Convert hours to POSIXct time format
d_conv <- function(t) {
  as.POSIXct(strptime(t, format = "%Y-%m-%d %H:%M:%S"))  
}


# Data preparation ------------------------------------------------------------

#
# Platform mapping to regions
#
pl_america <- c('AR', 'BR', 'CA', 'CL', 'CO', 'EC', 'MX', 'PE', 'US', 'UY')
pl_asia    <- c('AU', 'CN', 'HK', 'ID', 'IN', 'JP', 'KR', 'MY', 'NZ', 'PH', 
                'SG', 'TH', 'TW', 'VN')	
pl_eur_afr  <- c('AA', 'AE', 'AT', 'BE', 'BG', 'CH', 'CS', 'CZ', 'DE', 'DK',
                 'ES', 'FI', 'FR', 'GR', 'HR', 'HU', 'IE', 'IL', 'IT', 'NL',
                 'NO', 'PL', 'PT', 'RO', 'RS', 'RU', 'SE', 'SI', 'SK', 'TR',
                 'UK', 'ZA')		

DT_region <- data.table(
  platform = c(pl_america, pl_asia, pl_eur_afr),
  world_region = c(rep('America', length(pl_america)),
                   rep('Asia and Oceania', length(pl_asia)),
                   rep('Europe and Africa', length(pl_eur_afr)))
)

#
# Load training and test data
#
cols_num  <- "timestamp"
cols_char <- c("platform", "action_type")
cols <- c(cols_num, cols_char)
col_classes <- list(numeric = cols_num, character = cols_char)

DT_train <- fread(file = f_train, sep = ",", header = TRUE, verbose = TRUE,
                  select = cols, colClasses = col_classes)
DT_test  <- fread(file = f_test, sep = ",", header = TRUE, verbose = TRUE,
                  select = cols, colClasses = col_classes)
DT_train[, time_frame := "train"]
DT_test[, time_frame := "test"]

DT <- rbindlist(list(DT_train, DT_test))

setkey(DT, platform)
setkey(DT_region, platform)

DT <- DT[DT_region]
DT[, t_hour := anytime(timestamp - (timestamp %% 3600))]

# Count interactions and clickouts per hour and region
DT_ans <- DT[, .(interactions = .N,
                 clickouts = sum(action_type == 'clickout item')),
             by = .(time_frame, t_hour, world_region)]
  

# Plots -----------------------------------------------------------------------

DF_plot <- DT_ans %>%
  mutate(t = d_conv(t_hour)) %>%
  select(t, time_frame, world_region, interactions, clickouts)

# Interactions and clickouts over time
fig_3 <- DF_plot %>%
  ggplot(aes(x = t,
             y = interactions,
             shape = world_region,
             color = time_frame)) +
    geom_line() +
    geom_point() +
    scale_shape_manual(values=c(19, 2, 3)) +
    scale_color_manual(values=c("grey50", "black")) +
    geom_vline(xintercept = as.POSIXct("2018-11-07"),
               linetype = "dashed") +
    annotate("text",
             x = as.POSIXct("2018-11-01"),
             y = 90000,
             size = 3,
             color = "black", 
             label = "train") +
    facet_grid(region ~ .) +
    annotate("text",
             x = as.POSIXct("2018-11-07 10:00:00"),
             y = 90000,
             size = 3,
             color = "grey50", 
             label = "test") +
    facet_grid(world_region ~ .) +
    xlab("Time") +
    ylab("Number of interactions") +
    theme_bw(base_size = 10) +
    theme(legend.position = "none")

ggsave(file = './plots/figure_3.pdf', plot = fig_3,
       width = 6, height = 4)


# Conversion per world region
fig_4 <- DF_plot %>%
  filter(time_frame == 'train') %>%
  mutate(Region = world_region) %>%
  ggplot(aes(x = interactions,
             y = clickouts,
             shape = Region)) +
  scale_shape_manual(values=c(19, 2, 3)) +
  geom_point() +
  xlab("Number of interactions") +
  ylab("Number of clickouts") +
  theme_bw(base_size = 10) +
  theme(legend.position = c(0.2, 0.8))

ggsave(file = './plots/figure_4.pdf', plot = fig_4,
       width = 6, height = 4)
