# Spark Cluster (Docker) — IBDS Labs

A Dockerized Apache Spark 4.2.0 standalone cluster — one master, three workers, a history server, and JupyterLab.

## Prerequisites

- Docker Engine with the Compose plugin (`docker compose version`).
- Several GB of free RAM (each worker is capped at 2 GB, plus the master).
- These host ports free: `9080`, `9082`, `9083`, `9084`, `7077`, `4040`,
  `8888`, `18080`.

## Installation steps

1. Open a terminal in this folder (`/spark`).
2. Build the image and start the whole cluster:

   ```bash
   docker compose -f docker-compose.yml up -d --build
   ```
   This builds `my-spark:4.2.0` from `Dockerfile` (based on the official `spark:4.2.0-java21-python3` image, with NumPy, pandas, SciPy, scikit-learn, Matplotlib, Seaborn, PyArrow, findspark and JupyterLab added) and starts five containers:

   - `spark-master` — Spark Master + JupyterLab
   - `spark-worker-a`, `spark-worker-b`, `spark-worker-c` — 3 workers
   - `spark-history-server` — Spark History Server
3. Check everything is up:

   ```bash
   docker compose -f docker-compose.yml ps
   ```
4. Open in your browser:

   - JupyterLab: `http://localhost:8888` (no token/password required)
   - Spark Master UI: `http://localhost:9080`
   - Worker UIs: `http://localhost:9082`, `http://localhost:9083`, `http://localhost:9084`
   - Spark Application UI (while a job is running): `http://localhost:4040`
   - Spark History Server: `http://localhost:18080`
5. From a notebook or a submitted script, connect to the cluster with:

   ```python
   spark = SparkSession.builder.master("spark://spark-master:7077").getOrCreate()
   ```
   Spark MLlib is included with Apache Spark; the added scikit-learn stack is available for local ML workflows and analysis.
6. Folder layout used by the containers:

   - `apps/` → mounted at `/opt/spark-apps` on every container (Spark scripts; it is also the working directory of the Jupyter kernels).
   - `data/` → mounted at `/opt/spark-data`: Data used for the project.
   - `spark-logs/` → mounted at `/tmp/spark-events` (event logs, read by the history server).
7. Stop the cluster:

   ```bash
   docker compose -f docker-compose.yml down
   ```
