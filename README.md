# air-qualuty-SNCF

Data source: https://ressources.data.sncf.com/explore/dataset/qualite-de-lair/information/

## Documentation

Framing, method and data documents are in [docs/](docs/README.md):

- [Product charter](docs/pdf/product-charter.pdf): problem, product, 5W2H, objectives, constraints
- [Method](docs/pdf/method.pdf): evidence rules, bias checklist, phases
- [Data](docs/pdf/data.pdf): source discovery, data handling rule, audit protocol
- [Registers](docs/pdf/registers.pdf): gaps, hypotheses, decision log

Raw data in `spark/data/` is never modified; processed data goes to `spark/lake/`.

## Project Checklist

### 1. Scoping & Data Ingestion

- [x] **Define the objective and constraints:** Lock down the decision to support, the exact target variable, and hard constraints (compute budget, latency, privacy/GDPR, interpretability).
- [ ] **Set evaluation metrics upfront:** Choose one primary optimization metric and secondary guardrail metrics before inspecting model outputs.
- [ ] **Map primary data sources:** Document every source (APIs, SQL/NoSQL databases, event streams, flat files), its owner, update cadence, and licensing terms.
- [ ] **Build idempotent ingestion:** Write automated, repeatable extraction scripts that produce identical outputs when rerun.
- [ ] **Preserve an immutable raw layer:** Store untouched source snapshots in a dedicated Raw/Bronze zone with timestamps and version hashes; never overwrite raw data.
- [ ] **Validate at ingestion:** Enforce automated contract checks on arrival (schema types, primary key uniqueness, expected row counts, null spikes, timezone consistency).

### 2. Cleaning, Auditing & Exploratory Data Analysis (EDA)

- [ ] **Audit sampling and selection bias:** Check whether the dataset under-represents specific time windows, user cohorts, edge cases, or dropped records (survivorship bias).
- [ ] **Standardize the Silver layer:** Deduplicate records, normalize units and encodings, align timestamps to UTC, and resolve entity ID mismatches.
- [ ] **Diagnose missingness:** Classify whether missing values are random or systematic; avoid blind dropping or mean imputation until the mechanism is understood.
- [ ] **Check for target leakage:** Flag any column that contains future information or downstream proxies unavailable at prediction time.
- [ ] **Run structured EDA:** Inspect univariate distributions, extreme outliers, class imbalance, feature-target relationships, and temporal drift across time slices.
- [ ] **Document the data contract:** Maintain a living data dictionary recording column definitions, transformations, and known anomalies.

### 3. Splitting & Feature Engineering

- [ ] **Lock the validation split first:** Choose a split strategy that mirrors real-world inference—chronological splits for time-series, grouped splits for repeated entities, or stratified splits for imbalanced classes. Isolate a final holdout test set and do not touch it during iteration.
- [ ] **Encapsulate all stateful transforms:** Wrap imputation, scaling, categorical encoding, and dimensionality reduction inside a single pipeline object fit strictly on training folds to prevent leakage.
- [ ] **Engineer domain features:** Create aggregations, lag/rolling windows, ratios, and interaction terms; verify that every feature is computable at inference time.
- [ ] **Prune redundant features:** Check multicollinearity, zero-variance columns, and low-signal features to reduce noise and training overhead.
- [ ] **Enforce reproducibility:** Pin library versions, containerize the environment, fix random seeds, and version both feature datasets and pipeline code together.

### 4. Modeling, Evaluation & Results Delivery

- [ ] **Establish a simple baseline:** Build a heuristic, rule-based, or simple linear model first to set a hard performance floor and verify the end-to-end pipeline.
- [ ] **Track every experiment:** Log hyperparameters, dataset versions, git commit hashes, validation scores, and serialized model artifacts systematically.
- [ ] **Iterate and tune systematically:** Benchmark distinct model families (e.g., linear, tree-based, neural) and tune hyperparameters using cross-validation on training/validation folds only.
- [ ] **Run final holdout evaluation:** Score the locked model once on the untouched test set; report confidence intervals or bootstrap ranges rather than single point estimates.
- [ ] **Perform error and slice analysis:** Inspect residuals and failure modes across key subgroups (time periods, demographics, edge cases) to catch hidden degradation.
- [ ] **Verify calibration and explainability:** Check predicted probability calibration (if applicable) and generate global/local feature attributions to confirm the model relies on valid signals.
- [ ] **Deliver decision-ready artifacts:** Package reproducible code, clear visuals tied to the original metrics, explicit model limitations/assumptions, and monitoring thresholds for production handoff.
