
kmeans_analysis <- function(df_num, k = 4, out_dir = "outputs/stage2_kmeans") {
  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
  scaled <- scale(stats::na.omit(df_num))
  grDevices::png(file.path(out_dir,"elbow.png"), width=800, height=600)
  print(factoextra::fviz_nbclust(scaled, kmeans, method="wss")+ggplot2::ggtitle("Elbow Method"))
  grDevices::dev.off()
  grDevices::png(file.path(out_dir,"silhouette.png"), width=800, height=600)
  print(factoextra::fviz_nbclust(scaled, kmeans, method="silhouette")+ggplot2::ggtitle("Average Silhouette"))
  grDevices::dev.off()
  set.seed(99); km <- stats::kmeans(scaled, centers = k, nstart = 20)
  grDevices::png(file.path(out_dir,"km_scatter.png"), width=900, height=650)
  print(factoextra::fviz_cluster(km, data = scaled, geom="point", ellipse.type="convex", ggtheme=ggplot2::theme_minimal()))
  grDevices::dev.off()
  clusters <- factor(km$cluster)
  profiles <- as.data.frame(df_num) %>% dplyr::mutate(cluster = clusters) %>%
    dplyr::group_by(cluster) %>% dplyr::summarise(dplyr::across(dplyr::everything(), list(mean=mean, sd=sd), .names="{.col}_{.fn}"))
  utils::write.csv(profiles, file.path(out_dir,"cluster_profiles.csv"), row.names = FALSE)
  list(km = km, profiles = profiles)
}
