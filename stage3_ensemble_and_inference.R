#!/usr/bin/env Rscript

# Stage 3 — Ensemble Comparison & Inference using package utilities
suppressPackageStartupMessages({
  library(studentDepressionR); library(tidyverse); library(randomForest); library(pdp); library(gridExtra)
})

csv_path <- "data/Student Depression Dataset.csv"
out_dir  <- "outputs/stage3"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

df <- load_dataset(csv_path) %>% normalize_names() %>% map_sleep_to_hours() %>% basic_impute()
if (!is.numeric(df$Depression)) df$Depression <- ifelse(df$Depression %in% c("Yes","1",1,TRUE), 1, 0)
df$Depression <- factor(df$Depression, levels=c(0,1))
df <- factorize_columns(df)

num_cols <- intersect(c("Academic.Pressure","CGPA","Study.Satisfaction","Work.Study.Hours","Financial.Stress","Sleep_Hours","Age"), names(df))
sp <- split_and_prepare(df, target = "Depression", num_cols = num_cols, fac_cols = c("Gender","Family.History.of.Mental.Illness","Have.you.ever.had.suicidal.thoughts.."))

mods <- cv_compare_models(sp$train_x, sp$train_y)
saveRDS(mods, file.path(out_dir,"models_list.rds"))

met_list <- lapply(names(mods), function(nm) evaluate_binary(mods[[nm]], sp$test_x, sp$test_y, name = nm, out_dir = out_dir))
metrics <- do.call(rbind, met_list)
write.csv(round(metrics,4), file.path(out_dir,"test_metrics_comparison.csv"), row.names = FALSE)

rf_model <- mods$rf$finalModel
png(file.path(out_dir,"rf_importance.png"), width=800, height=600)
randomForest::varImpPlot(rf_model, main="Random Forest — Variable Importance")
dev.off()

imp <- randomForest::importance(rf_model) %>% as.data.frame()
imp$Feature <- rownames(imp)
top_vars <- head(imp %>% arrange(desc(MeanDecreaseGini)) %>% pull(Feature), 3)
plots <- list()
for (v in intersect(top_vars, colnames(sp$train_x))) {
  pd <- pdp::partial(rf_model, pred.var = v, train = sp$train_x, prob=TRUE)
  plots[[v]] <- autoplot(pd) + ggtitle(paste("PDP —", v))
}
if (length(plots)>0) {
  png(file.path(out_dir,"rf_pdp_top.png"), width=1100, height=650)
  do.call(gridExtra::grid.arrange, c(plots, ncol=2))
  dev.off()
}

generate_stage_report(out_dir, title="Stage 3 — Model Comparison & Insights", metrics_df = metrics,
                      notes = c("- See ROC_*.png for curves", "- Feature importance and PDPs clarify drivers"))
message("Stage 3 complete → ", out_dir)
