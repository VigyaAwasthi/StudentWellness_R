
# studentDepressionR

A polished, portfolio-ready R package for student well-being modeling: EDA, feature engineering, supervised learning (Decision Tree, Logistic, RF, SVM, Neural Net), and k-means clustering. Includes reproducible stage scripts and reporting helpers.

## Install & Run (Local)

```r
# From local folder:
# 1) Open R (or RStudio) in the parent directory of 'studentDepressionR'
install.packages("devtools")           # if needed
devtools::install("studentDepressionR")

library(studentDepressionR)

# Put your CSV at: data/Student Depression Dataset.csv (create 'data/' at project root)
# Then run the stage scripts (see below)
```

### Stage scripts

```bash
# From the repo root in a shell:
Rscript inst/scripts/stage1_decision_tree.R
Rscript inst/scripts/stage2_kmeans_clustering.R
Rscript inst/scripts/stage2_neural_network.R
Rscript inst/scripts/stage3_ensemble_and_inference.R
```

Artifacts land in `outputs/` under each stage.

## GitHub Deployment (Portfolio)

```bash
# Initialize repo and push to GitHub
git init
git add .
git commit -m "Initial commit: studentDepressionR package"
gh repo create vigya-awasthi/studentDepressionR --public --source=. --remote=origin --push  # requires GitHub CLI
# or create a repo on GitHub manually, then:
git remote add origin https://github.com/<your-username>/studentDepressionR.git
git push -u origin main
```

### Optional: Build a docs site with pkgdown

```r
install.packages("pkgdown")
pkgdown::build_site()   # creates docs/ for GitHub Pages
```
