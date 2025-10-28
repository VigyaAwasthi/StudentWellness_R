# studentDepressionR

**studentDepressionR** is a production-style R package that analyzes student well-being data and builds predictive models for depression risk. It emphasizes transparent EDA, reproducible preprocessing, multiple model families (Decision Tree, Logistic Regression, Random Forest, SVM-Radial, Neural Net), unsupervised k-means clustering, and concise stage reports with metrics and figures.

> Objective: demonstrate a rigorous end-to-end data science workflow—clear EDA, fair model comparison, and human-readable insights—

## Project flow (single visual)

```mermaid
flowchart TD
  A[Raw dataset - student well-being records] --> B[EDA and profiling - class balance, distributions, correlation, ridge]
  B --> C[Preprocessing - one-hot encoding, scaling, sleep to hours, minimal imputation]

  C --> D1[Stage 1 - Decision Tree - tuned cp, tree plot, ROC/AUC, confusion matrix]
  C --> D2a[Stage 2a - K-Means - elbow, silhouette, K selection, cluster profiles, scatter maps]
  C --> D2b[Stage 2b - Neural Network (nnet) - size and decay tuning, ROC/AUC, calibration]
  C --> E[Stage 3 - Model comparison - Logistic, Random Forest, SVM-Radial, Neural Net, 5-fold CV ROC, test metrics]

  E --> F[Explainability - RF importance, partial dependence]

  D1 --> G[Stage reports - per-stage markdown summaries]
  D2a --> G
  D2b --> G
  E --> G
  F --> G

  G --> H[Insights and takeaways - patterns, tradeoffs, limitations]

## Highlights

- **Expressive EDA**: class balance, per-feature distributions across labels, correlation heatmap, density-ridge overlays.  
- **Feature engineering**: categorical one-hot encoding; `Sleep.Duration → Sleep_Hours`; simple, traceable imputations.  
- **Multiple model families**: interpretable baselines (Decision Tree, Logistic) plus stronger nonlinear models (Random Forest, SVM-Radial, Neural Net).  
- **Unsupervised lens**: k-means with elbow & silhouette diagnostics, cluster profiles (mean/SD), clean cluster visuals.  
- **Consistent evaluation**: Accuracy, Sensitivity, Specificity, F1, ROC/AUC; calibration and partial-dependence for interpretability.  
- **Stage reports**: each stage writes a concise Markdown summary and exports figures/metrics to `outputs/...`.

---

## Structure

```
studentDepressionR/
├─ R/                       # Reusable functions (EDA, preprocess, models, clustering, reports)
├─ inst/scripts/            # Stage runners (S1 tree, S2 k-means, S2 nnet, S3 compare)
├─ outputs/                 # Created at runtime: figures, metrics, summaries
├─ data/                    # Dataset location (kept out of version control by default)
├─ DESCRIPTION, NAMESPACE   # Package metadata
├─ LICENSE (MIT)
└─ README.md
```

---

## Dataset (context)

Anonymized student well-being records with attributes such as academic pressure, study satisfaction, work-study hours, financial stress, sleep duration, CGPA, and a binary **Depression** label.

- **Privacy & scope**: used for demonstration; no attempt is made to identify individuals.  
- **Interpretation**: results are **exploratory** and **not diagnostic**.

---

## Methods (at a glance)

- **EDA**: outcome skew, per-feature distributions by label, correlation heatmap, density-ridge overlays.  
- **Preprocessing**: dummy encoding (`caret::dummyVars`), range scaling for numerics, median imputation for select fields, deterministic train/test split.  
- **Supervised models**:
  - Decision Tree (`rpart`) with `cp` tuning and tree visualization  
  - Logistic Regression baseline  
  - Random Forest (variable importance, partial-dependence)  
  - SVM-Radial (RBF)  
  - Neural Net (`nnet`, size/decay grid)  
  - 5-fold cross-validation with ROC as the selection metric  
- **Unsupervised**: k-means on scaled numerics, **K** selection via elbow/silhouette, cluster profiles and visuals.  

---

## Artifacts produced

- **Figures**: target distribution, per-feature boxplots by label, correlation heatmap, ROC curves per model, Random Forest feature importance, PDPs, elbow/silhouette diagnostics, cluster scatter maps.  
- **Tables**: per-model test metrics (Accuracy, Sensitivity, Specificity, F1, AUC), cross-model comparison table, cluster profiles (mean/SD).  
- **Reports**: per-stage Markdown summaries under `outputs/...` with key findings and links to artifacts.

---

## Representative insights

- Sleep and academic pressure typically show the strongest separation across labels; financial stress exhibits nonlinear effects captured by RF/SVM.  
- Logistic regression provides a transparent baseline; nonlinear learners often improve AUC while trading off interpretability.  
- Neural networks are competitive with careful regularization; calibration sharpens decision thresholds.  
- Unsupervised clusters reveal coherent student profiles (e.g., high-pressure/low-sleep vs. moderate-pressure/adequate-sleep), useful for segmentation and early warning frameworks.

> Exact metrics vary with dataset snapshot and split; the focus is reliability, transparency, and comparability.

---

## Responsible use

This project is not a clinical instrument. Any operational deployment should involve domain experts, representative data, calibration, bias checks, and periodic audits.

---

## Roadmap

- SHAP-style explanations for tree-based models  
- Additional calibration utilities and threshold optimization  
- Optional stacked ensemble head-to-head with single models  
- Lightweight documentation site for function reference and gallery

---

## Maintainer & License

**Vigya Awasthi** — Data & ML ·  
Released under the **MIT License**.
