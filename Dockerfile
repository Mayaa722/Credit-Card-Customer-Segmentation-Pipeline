# Base image
FROM python:3.11-slim

# Install required Python libraries
RUN pip install --no-cache-dir \
    pandas \
    numpy \
    matplotlib \
    seaborn \
    scikit-learn \
    scipy \
    requests

# Create working directory inside container
WORKDIR /app/pipeline/

# Copy all project scripts into the container
COPY . /app/pipeline/

# Start an interactive bash shell when the container runs
CMD ["/bin/bash"]
