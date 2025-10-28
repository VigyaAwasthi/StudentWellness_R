
split_and_prepare <- function(df, target = "Depression", num_cols = NULL, fac_cols = NULL, p = 0.8) {
  set.seed(123)
  idx <- caret::createDataPartition(df[[target]], p = p, list = FALSE)
  tr <- df[idx, ]; te <- df[-idx, ]
  x_cols <- setdiff(union(num_cols, fac_cols), target)
  dmy <- caret::dummyVars(~ ., data = tr[, x_cols, drop = FALSE])
  tr_x <- predict(dmy, newdata = tr) %>% as.data.frame()
  te_x <- predict(dmy, newdata = te) %>% as.data.frame()
  pp  <- caret::preProcess(tr_x, method = c("range"))
  tr_x <- predict(pp, tr_x); te_x <- predict(pp, te_x)
  list(train_x = tr_x, test_x = te_x, train_y = tr[[target]], test_y = te[[target]], prep = list(dmy = dmy, pp = pp))
}
