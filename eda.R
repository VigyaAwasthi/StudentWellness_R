
# EDA utilities (see previous cell for full roxygen-like comments)
load_dataset <- function(path = "data/Student Depression Dataset.csv") {
  if (!file.exists(path)) stop("CSV not found at: ", path)
  read.csv(path, na.strings = c("", "NA"))
}
normalize_names <- function(df) { names(df) <- gsub("\\.+", ".", make.names(names(df))); df }
map_sleep_to_hours <- function(df) {
  if (!"Sleep.Duration" %in% names(df)) return(df)
  df$Sleep_Hours <- NA_real_
  df$Sleep_Hours[grepl("Less", df$Sleep.Duration, ignore.case = TRUE)] <- 4
  df$Sleep_Hours[grepl("5-6", df$Sleep.Duration)] <- 5.5
  df$Sleep_Hours[grepl("7-8", df$Sleep.Duration)] <- 7.5
  df$Sleep_Hours[grepl("More", df$Sleep.Duration, ignore.case = TRUE)] <- 9
  df
}
basic_impute <- function(df) {
  if ("Financial.Stress" %in% names(df)) {
    med <- stats::median(df$Financial.Stress, na.rm = TRUE)
    df$Financial.Stress[is.na(df$Financial.Stress)] <- med
  }
  df
}
factorize_columns <- function(df, cols = c("Gender","Family.History.of.Mental.Illness","Have.you.ever.had.suicidal.thoughts..")) {
  cols <- intersect(cols, names(df)); df[cols] <- lapply(df[cols], as.factor); df
}
eda_overview <- function(df, out_dir) {
  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
  p <- ggplot2::ggplot(df, ggplot2::aes(x = Depression)) + ggplot2::geom_bar() + ggplot2::theme_minimal() + ggplot2::labs(title = "Target Distribution")
  ggplot2::ggsave(file.path(out_dir, "01_target.png"), p, width = 6, height = 4, dpi = 220)
}
eda_boxplots_by_target <- function(df, out_dir, num_cols) {
  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
  plist <- lapply(num_cols, function(col) ggplot2::ggplot(df, ggplot2::aes(x = Depression, y = .data[[col]], fill = Depression)) +
                    ggplot2::geom_boxplot(outlier.alpha = 0.25) + ggplot2::theme_minimal() +
                    ggplot2::labs(title = paste(col, "by Depression"), x = "", y = col) + ggplot2::theme(legend.position = "none"))
  grDevices::png(file.path(out_dir, "02_box_by_target.png"), width = 1200, height = 700); do.call(gridExtra::grid.arrange, c(plist, ncol = 2)); grDevices::dev.off()
}
eda_correlation_heatmap <- function(df, out_dir, num_cols) {
  if (length(num_cols) < 2) return(invisible(NULL))
  cor_mat <- stats::cor(df[, num_cols], use = "complete.obs")
  grDevices::png(file.path(out_dir, "03_correlation.png"), width = 900, height = 800)
  corrplot::corrplot(cor_mat, method = "color", type = "upper", tl.cex = 0.8,
                     col = grDevices::colorRampPalette(c("navy","white","firebrick3"))(200))
  grDevices::dev.off()
}
eda_density_ridge <- function(df, out_dir, var = "Academic.Pressure") {
  if (!var %in% names(df)) return(invisible(NULL))
  df$Depression_Factor <- factor(df$Depression, labels = c("Not Depressed","Depressed"))
  p <- ggplot2::ggplot(df, ggplot2::aes(x = .data[[var]], y = Depression_Factor, fill = Depression_Factor)) +
    ggridges::geom_density_ridges(alpha = 0.7, scale = 2) + ggplot2::theme_minimal() +
    ggplot2::labs(title = paste(var, "by Depression Status"), x = var, y = "Status")
  ggplot2::ggsave(file.path(out_dir, paste0("04_ridge_", gsub("\\\\.","_", var), ".png")), p, width = 7, height = 4.5, dpi = 220)
}
