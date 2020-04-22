library(data.table)
library(dplyr)
library(ggplot2)

# Specify data file -----------------------------------------------------------

if (file.exists("./data/train.csv")) {
  f_data <- "./data/train.csv"
} else {
  f_data <- "https://recsys2019data.trivago.com/train.csv"
}


# Data preparation ------------------------------------------------------------
cols_num  <- "step"
cols_char <- c("user_id", "session_id", "action_type", "reference")
cols <- c(cols_num, cols_char)
col_classes <- list(numeric = cols_num, character = cols_char)

DT <- fread(file = f_data, sep = ",", header = TRUE, verbose = TRUE,
            select = cols, colClasses = col_classes)

# Determine previous action type and reference type (same item or other)
setkey(DT, user_id, session_id, step) # order the data.table
DT[, `:=` (prev_action_type = shift(action_type, 1, fill = "no action"),
           is_same_ref      = shift(reference,   1, fill = "NA") == reference),
   by = .(user_id, session_id)]

# Count clicks per previous action type and reference type
DT_ans <- DT[action_type == "clickout item", 
             .N, 
             by = .(prev_action_type, is_same_ref)] 
DT_ans[, frac := N / sum(N)]


# Plot ------------------------------------------------------------------------

# Order factor levels to plot according to total clicks per prev action
f_levels <- DT_ans %>%
  group_by(prev_action_type) %>%
  summarize(n = sum(N)) %>%
  arrange(n) %>%
  pull(prev_action_type)

DF_plot <- DT_ans %>%
  mutate(prev_action_type = factor(prev_action_type, 
                                   levels = f_levels),
         prev_ref_type = ifelse(is_same_ref, "same item", "other item")) %>%
  select(prev_action_type, prev_ref_type, frac)

fig_2 <- DF_plot %>%
  ggplot(aes(x = prev_action_type,
             y = frac,
             fill = prev_ref_type)) +
    geom_col(position = position_dodge2(preserve = "single",
                                        padding = 0.2),
             color = "black",
             size = 0.3) +
    scale_fill_manual(values=c("white", "grey90")) +
    coord_flip() +
    labs(fill = "") +
    xlab("Previous action type") +
    ylab("Frequency") +
    theme_bw(base_size = 12) +
    theme(legend.position = c(0.8, 0.2))

ggsave(file = './plots/figure_2.pdf', plot = fig_2,
       width = 6, height = 4)
