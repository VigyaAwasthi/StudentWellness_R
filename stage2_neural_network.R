#!/usr/bin/env Rscript

# Stage 2 — Neural Network using package utilities
suppressPackageStartupMessages({
  library(studentDepressionR); library(tidyverse)
})

csv_path <- "data/Student Depression Dataset.csv"
out_dir  <- "outputs/stage2_nnet"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

df <- load_dataset(csv_path) %>% normalize_names() %>% map_sleep_to_hours() %>% basic_impute()
if (!is.numeric(df$Depression)) df$Depression <- ifelse(df$Depression %in% c("Yes","1",1,TRUE), 1, 0)
df$Depression <- factor(df$Depression, levels=c(0,1))
df <- factorize_columns(df)

num_cols <- intersect(c("Academic.Pressure","CGPA","Study.Satisfaction","Work.Study.Hours","Financial.Stress","Sleep_Hours","Age"), names(df))
sp <- split_and_prepare(df, target = "Depression", num_cols = num_cols, fac_cols = c("Gender","Family.History.of.Mental.Illness","Have.you.ever.had.suicidal.thoughts.."))
nn <- fit_neural_net(sp$train_x, sp$train_y, tuneLength = 8)
saveRDS(nn, file.path(out_dir,"nnet.rds"))
metrics <- evaluate_binary(nn, sp$test_x, sp$test_y, name="Neural_Net", out_dir=out_dir)
write.csv(round(metrics,4), file.path(out_dir,"metrics_nnet.csv"), row.names = FALSE)
generate_stage_report(out_dir, title="Stage 2 — Neural Network", metrics_df = metrics)
message("Stage 2 Neural Net complete → ", out_dir)
