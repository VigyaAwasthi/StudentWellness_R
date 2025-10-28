#!/usr/bin/env Rscript

# Stage 1 — Decision Tree using package utilities
suppressPackageStartupMessages({
  library(studentDepressionR)
  library(tidyverse); library(rpart.plot); library(corrplot); library(gridExtra)
})

csv_path <- "data/Student Depression Dataset.csv"
out_dir  <- "outputs/stage1"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

df <- load_dataset(csv_path) %>% normalize_names() %>% map_sleep_to_hours() %>% basic_impute()
if (!is.numeric(df$Depression)) df$Depression <- ifelse(df$Depression %in% c("Yes","1",1,TRUE), 1, 0)
df$Depression <- factor(df$Depression, levels=c(0,1))
df <- factorize_columns(df)

num_cols <- intersect(c("Academic.Pressure","CGPA","Study.Satisfaction","Work.Study.Hours","Financial.Stress","Sleep_Hours","Age"), names(df))
eda_overview(df, out_dir)
eda_boxplots_by_target(df, out_dir, num_cols)
eda_correlation_heatmap(df, out_dir, num_cols)
eda_density_ridge(df, out_dir, "Academic.Pressure")

sp <- split_and_prepare(df, target = "Depression", num_cols = num_cols, fac_cols = c("Gender","Family.History.of.Mental.Illness","Have.you.ever.had.suicidal.thoughts.."))
dt <- fit_decision_tree(sp$train_x, sp$train_y)
saveRDS(dt, file.path(out_dir,"decision_tree.rds"))
metrics <- evaluate_binary(dt, sp$test_x, sp$test_y, name="Decision_Tree", out_dir=out_dir)
write.csv(round(metrics,4), file.path(out_dir,"metrics_decision_tree.csv"), row.names = FALSE)

png(file.path(out_dir,"tree.png"), width=900, height=650)
rpart.plot::rpart.plot(dt$finalModel, main="Decision Tree (final)")
dev.off()

generate_stage_report(out_dir, title="Stage 1 — Decision Tree", metrics_df = metrics)
message("Stage 1 complete → ", out_dir)
