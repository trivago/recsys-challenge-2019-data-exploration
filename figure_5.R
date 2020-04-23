library(data.table)
library(dplyr)
library(ggplot2)
library(gridExtra)


# Specify data file -----------------------------------------------------------

if (file.exists("./data/train.csv")) {
  f_data <- "./data/train.csv"
} else {
  f_data <- "https://recsys2019data.trivago.com/train.csv"
}


# Function definitions --------------------------------------------------------

#' Convert hours to POSIXct time format
d_conv <- function(t) {
  as.POSIXct(strptime(t, format = "%Y-%m-%d %H:%M:%S"))  
}

#' Plot a histogram in 'empty' style without boarders
hist_empty_log <- function(DF, x, y) {
  # Bar chart as the base
  p <- DF %>%
    ggplot(aes_string(x = x, y = y)) +
      geom_bar(stat = "identity")
  
  # Determine axis breaks and labels for log plot
  DF_build <- ggplot_build(p)
  x_breaks <- DF_build$layout$panel_params[[1]]$x.major_source
  x_labels <- 10^x_breaks
  
  # Plot with geom_step
  DF_plot <- DF_build$data[[1]][, c("x", "y")]
  p_out <- DF_plot %>%
    ggplot(aes(x = x, y = y)) +
      geom_step() +
      scale_x_continuous(breaks = x_breaks,
                         labels = x_labels) +
      annotation_logticks(sides = "b") +
      theme_bw(base_size = 10)
  
  p_out
}


# Data preparation ------------------------------------------------------------

cols_num  <- "step"
cols_char <- c("user_id", "session_id", "prices", "action_type")
cols <- c(cols_num, cols_char)
col_classes <- list(numeric = cols_num, character = cols_char)

DT <- fread(input = f_data, sep = ",", header = TRUE, verbose = TRUE,
            select = cols, colClasses = col_classes)

# Interactions (steps) per session

# Number of steps per session
DT_steps <- DT[, .(n_steps = max(step)), by = session_id]

# Bin the data on log scale
bin_size <- 0.1
DT_steps[, step_bin := round(log10(n_steps) / bin_size) * bin_size]
DT_steps_log <- DT_steps[, .N, by = step_bin]

# Fill the bin gaps and center the bins
DT_step_bins <- data.table(step_bin = seq(-0.1, 3.5, by = bin_size))
setNumericRounding(2) # round off last 2 bytes to allow join on numerics
DT_step_bins[DT_steps_log, on = "step_bin", N := i.N]
DT_step_bins[, `:=` (N = coalesce(N, 0L),
                     step_bin = step_bin - bin_size / 2)]

# Prices

# Select clickouts only
DT_clicks <- DT[action_type == "clickout item"]

# "Explode" prices list into a price column
DT_prices <- DT_clicks[, 
    strsplit(prices, "|", fixed = TRUE),
    by = .(user_id, session_id, step, prices)
  ][, prices := NULL
  ][, setnames(.SD, "V1", "price")]

# Bin the data on log scale
bin_size <- 0.1
DT_prices[, price_bin := round(log10(as.numeric(price)) / bin_size) * bin_size]
DT_prices_log <- DT_prices[, .N, by = price_bin]

# Fill the bin gaps and center the bins
DT_price_bins <- data.table(price_bin = seq(0.6, 4.1, by = bin_size))
setNumericRounding(2) # round off last 2 bytes to allow join on numerics
DT_price_bins[DT_prices_log, on = "price_bin", N := i.N]
DT_price_bins[, `:=` (N = coalesce(N, 0L),
                     price_bin = price_bin - bin_size / 2)]


# Plot ------------------------------------------------------------------------

# Interactions per session
fig_5a <- hist_empty_log(DT_step_bins, "step_bin", "N")
fig_5a <- fig_5a +
  xlab("Interactions per sessions") +
  ylab("Count") +
  scale_y_continuous(labels = scales::scientific)

# Prices
fig_5b <- hist_empty_log(DT_price_bins, "price_bin", "N")
fig_5b <- fig_5b +
  xlab("Price [Euros]") +
  ylab("Count")

# Combined
fig_5 <- grid.arrange(fig_5a, fig_5b, ncol = 2)

ggsave(file = './plots/figure_5.pdf', plot = fig_5,
       width = 6, height = 2)
