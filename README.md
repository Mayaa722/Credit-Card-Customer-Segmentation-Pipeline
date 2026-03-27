# Credit Card Customer Segmentation Pipeline
### CSCI461: Introduction to Big Data — Assignment #1 — Spring 2026
### Nile University

---

## Team Members
Maya Anwar 231000241
Manar Bassiouni 231000281

## Project Overview

This project builds a fully Dockerized Big Data pipeline that performs end-to-end analysis on a Credit Card Customer dataset. The pipeline segments ~9,000 credit card holders into behavioral clusters using K-Means clustering, enabling data-driven marketing strategies.

**Dataset:** [Credit Card Customer Segmentation — Kaggle](https://www.kaggle.com/datasets/arjunbhasin2013/ccdata)

- 8,950 rows × 18 columns
- Raw data with missing values in `MINIMUM_PAYMENTS` and `CREDIT_LIMIT`

---

## Project Structure

```
customer-analytics/
├── Dockerfile              # Docker container setup
├── ingest.py               # Load dataset and save raw copy
├── preprocess.py           # Clean, transform, reduce, discretize
├── analytics.py            # Generate 3 textual insights
├── visualize.py            # Generate 3 meaningful plots
├── cluster.py              # K-Means clustering
├── summary.sh              # Copy outputs from container to host
├── README.md               # This file
└── results/                # All generated outputs
    ├── data_raw.csv
    ├── data_preprocessed.csv
    ├── data_clustered.csv
    ├── insight1.txt
    ├── insight2.txt
    ├── insight3.txt
    ├── clusters.txt
    ├── summary_plot.png
    └── elbow_plot.png
```

---

## Execution Flow

```
data_raw.csv
      │
      ▼
 ingest.py         → Loads dataset, saves data_raw.csv
      │
      ▼
 preprocess.py     → Cleans, scales, applies PCA, discretizes
      │              Saves data_preprocessed.csv
      ▼
 analytics.py      → Generates insight1.txt, insight2.txt, insight3.txt
      │
      ▼
 visualize.py      → Generates summary_plot.png, elbow_plot.png
      │
      ▼
 cluster.py        → Applies K-Means, saves clusters.txt, data_clustered.csv
      │
      ▼
 summary.sh        → Copies all outputs to host, stops & removes container
```

---

## Docker Commands

### 1. Build the Docker Image
```bash
docker build -t credit-analytics .
```

### 2. Run the Container (interactive, with dataset mounted)
```bash
docker run -it \
  --name credit-analytics \
  -v $(pwd)/CC_GENERAL.csv:/app/pipeline/CC_GENERAL.csv \
  credit-analytics
```

### 3. Run the Full Pipeline (inside container)
```bash
python ingest.py CC_GENERAL.csv
```

### 4. Copy outputs and clean up (from host, in a new terminal)
```bash
bash summary.sh
```

### 5. All-in-one command (run + execute pipeline)
```bash
docker run -it \
  --name credit-analytics \
  -v $(pwd)/CC_GENERAL.csv:/app/pipeline/CC_GENERAL.csv \
  credit-analytics \
  bash -c "python ingest.py CC_GENERAL.csv"
```

---

## 🔧 Preprocessing Steps

### Stage 1 — Data Cleaning
- Dropped `CUST_ID` (not useful for clustering)
- Filled missing values in `MINIMUM_PAYMENTS` and `CREDIT_LIMIT` with median
- Removed duplicate rows

### Stage 2 — Feature Transformation
- Applied `StandardScaler` to all 17 numeric features
- No categorical encoding needed (all features are numeric)

### Stage 3 — Dimensionality Reduction
- Applied **PCA** to reduce 17 features → 6 principal components
- 6 components explain ~80% of variance

### Stage 4 — Discretization
- `TENURE` → binned into: Short-term / Mid-term / Long-term
- `BALANCE` → binned into: Low / Medium / High
- `CREDIT_LIMIT` → binned into: Bronze / Silver / Gold

---

##  Analytics Insights

### Insight 1 — Full Payment Behavior
Only a small percentage of customers pay their full balance monthly.
The majority carry a revolving balance, creating both revenue and default risk.

### Insight 2 — Cash Advance vs Purchases
A significant portion of customers rely on cash advances rather than purchases,
indicating potential financial stress and higher default risk.

### Insight 3 — Tenure vs Credit Limit
Long-term customers have significantly higher credit limits than short-term ones,
confirming that loyalty is rewarded and tenure is a key predictor of creditworthiness.

---

##  Clustering Results (K=4)

| Cluster | Name | Description |
|---------|------|-------------|
| 0 | Inactive / Low Activity | Low balance, few purchases, minimal activity |
| 1 | VIP High Spenders | High balance, high purchases, high credit limit |
| 2 | Risky Cash Advance Users | High cash advance, low payments |
| 3 | Responsible Moderate Users | Moderate usage, good payment behavior |

**Optimal K** was determined using the **Elbow Method** (WCSS plot).

---

##  Visualizations

Three plots saved in `summary_plot.png`:
1. **Histogram** — Distribution of customer balances
2. **Correlation Heatmap** — Relationships between all 17 features
3. **Scatter Plot** — Purchases vs Credit Limit colored by credit tier

---

##  Bonus

- [ ] Docker image pushed to Docker Hub: `docker push <username>/credit-analytics`
- [ ] Project pushed to GitHub with detailed README

---

## Requirements

All dependencies are installed automatically via Dockerfile:
- Python 3.11
- pandas, numpy, matplotlib, seaborn
- scikit-learn, scipy, requests
