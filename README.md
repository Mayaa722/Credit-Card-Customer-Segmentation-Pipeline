# bigdata-customer-insights
# Customer Analytics Pipeline

## How to Run

docker build -t my_image .
docker run -it --name my_container my_image

python ingest.py data/your_dataset.csv

## Pipeline Flow
ingest → preprocess → analytics → visualize → cluster

## Outputs
- data_raw.csv
- data_preprocessed.csv
- insights
- plots
- clustering results
