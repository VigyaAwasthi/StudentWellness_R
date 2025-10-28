
fit_decision_tree <- function(train_x, train_y, tuneLength = 10) {
  ctrl <- caret::trainControl(method="cv", number=5, classProbs=TRUE, summaryFunction=twoClassSummary)
  tr_df <- cbind(train_x, Depression = factor(ifelse(train_y=="1","Yes","No")))
  set.seed(7)
  caret::train(Depression ~ ., data = tr_df, method = "rpart", trControl = ctrl, tuneLength = tuneLength, metric = "ROC")
}
fit_logistic_regression <- function(train_x, train_y) {
  ctrl <- caret::trainControl(method="cv", number=5, classProbs=TRUE, summaryFunction=twoClassSummary)
  tr_df <- cbind(train_x, Depression = factor(ifelse(train_y=="1","Yes","No")))
  caret::train(Depression ~ ., data = tr_df, method = "glm", family = binomial(), trControl = ctrl, metric="ROC")
}
fit_random_forest <- function(train_x, train_y, tuneLength=4) {
  ctrl <- caret::trainControl(method="cv", number=5, classProbs=TRUE, summaryFunction=twoClassSummary)
  tr_df <- cbind(train_x, Depression = factor(ifelse(train_y=="1","Yes","No")))
  caret::train(Depression ~ ., data = tr_df, method = "rf", tuneLength = tuneLength, trControl = ctrl, metric="ROC")
}
fit_svm_radial <- function(train_x, train_y, tuneLength=4) {
  ctrl <- caret::trainControl(method="cv", number=5, classProbs=TRUE, summaryFunction=twoClassSummary)
  tr_df <- cbind(train_x, Depression = factor(ifelse(train_y=="1","Yes","No")))
  caret::train(Depression ~ ., data = tr_df, method = "svmRadial", tuneLength = tuneLength, trControl = ctrl, metric="ROC")
}
fit_neural_net <- function(train_x, train_y, tuneLength=8) {
  ctrl <- caret::trainControl(method="cv", number=5, classProbs=TRUE, summaryFunction=twoClassSummary)
  tr_df <- cbind(train_x, Depression = factor(ifelse(train_y=="1","Yes","No")))
  caret::train(Depression ~ ., data = tr_df, method="nnet", tuneLength=tuneLength, trControl=ctrl, metric="ROC", trace=FALSE, maxit=1000)
}
evaluate_binary <- function(model, test_x, test_y, name = "model", out_dir = NULL) {
  prob <- predict(model, newdata = test_x, type = "prob")[,"Yes"]
  cls  <- factor(ifelse(prob >= .5, 1, 0), levels = c(0,1))
  cm <- caret::confusionMatrix(cls, test_y, positive = "1")
  roc_obj <- pROC::roc(response = test_y, predictor = prob, levels = rev(levels(test_y)))
  auc <- as.numeric(pROC::auc(roc_obj))
  if (!is.null(out_dir)) {
    if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
    grDevices::png(file.path(out_dir, paste0("ROC_", name, ".png")), width = 700, height = 500)
    plot.roc(roc_obj, main = paste("ROC -", name, sprintf("(AUC=%.3f)", auc)))
    grDevices::dev.off()
  }
  data.frame(Model = name, Accuracy = cm$overall[["Accuracy"]],
             Sensitivity = cm$byClass[["Sensitivity"]],
             Specificity = cm$byClass[["Specificity"]],
             F1 = cm$byClass[["F1"]], AUC = auc)
}
cv_compare_models <- function(train_x, train_y) {
  list(glm  = fit_logistic_regression(train_x, train_y),
       rf   = fit_random_forest(train_x, train_y),
       svm  = fit_svm_radial(train_x, train_y),
       nnet = fit_neural_net(train_x, train_y))
}
