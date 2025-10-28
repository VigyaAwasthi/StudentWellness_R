
generate_stage_report <- function(out_dir, title = "Stage Summary", metrics_df = NULL, notes = NULL) {
  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
  lines <- c(paste0("# ", title), "", "## Metrics")
  if (!is.null(metrics_df)) {
    lines <- c(lines, paste0("```\n", paste(capture.output(print(round(metrics_df,4))), collapse="\n"), "\n```"))
  } else lines <- c(lines, "_Metrics table not provided._")
  if (!is.null(notes)) lines <- c(lines, "", "## Notes", notes)
  writeLines(lines, file.path(out_dir, "summary.md"))
  invisible(TRUE)
}
generate_project_report <- function(out_dir, artifacts = character()) {
  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
  lines <- c("# Student Depression — Project Report", "", "Artifacts:", artifacts)
  writeLines(lines, file.path(out_dir, "PROJECT_REPORT.md"))
  invisible(TRUE)
}
