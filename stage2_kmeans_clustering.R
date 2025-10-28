#!/usr/bin/env Rscript

# Stage 2 — K-Means using package utilities
suppressPackageStartupMessages({
  library(studentDepressionR); library(tidyverse)
})

csv_path <- "data/Student Depression Dataset.csv"
out_dir  <- "outputs/stage2_kmeans"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

df <- load_dataset(csv_path) %>% normalize_names() %>% map_sleep_to_hours()
num_cols <- intersect(c("Academic.Pressure","CGPA","Study.Satisfaction","Work.Study.Hours","Financial.Stress","Sleep_Hours","Age"), names(df))
res <- kmeans_analysis(df_num = df[, num_cols], k = 4, out_dir = out_dir)
utils::write.csv(res$profiles, file.path(out_dir,"cluster_profiles.csv"), row.names = FALSE)
generate_stage_report(out_dir, title="Stage 2 — K-Means", metrics_df = res$profiles, notes = "See elbow/silhouette for K selection.")
message("Stage 2 K-Means complete → ", out_dir)
