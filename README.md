# 🌞 Smart-Home Energy Data Platform  
**End-to-End Azure Data Engineering Project (Solar + Heat Pump + Weather Data)**

This project showcases a modern cloud-based **data ingestion + lakehouse storage + processing + analytics platform** built using **Azure** services.  
The platform collects real-time data from:

💡 Solar Inverter (Sunsynk)  
🔥 Heat Pump (Mitsubishi / MELCloud)  
🌦 Weather APIs (for context + modeling)

and turns it into insights about **energy efficiency, grid usage, temperatures, and predictive consumption trends.**

---

## 🎯 Goals of the Project

- Build an end-to-end **production-style data platform**
- Demonstrate skills in **Azure, data engineering, orchestration, ingestion & analytics**
- Ingest time-series IoT/energy telemetry from real devices
- Store & organise data using **data-lake zones (Bronze → Silver → Gold)**
- Transform raw data into analytical data sets
- Visualise insights using **Power BI**
- Keep monthly costs **under £15**

---

## 🏗 Architecture Overview

    ```
        API Sources (Solar / Heat Pump / Weather)
                    │
                    ▼
        Azure Data Factory (Orchestration)
                    │
                    ▼ triggers
            Azure Function Apps (ETL Ingestion)
                    │
                    ▼ writes JSON
        Azure Data Lake Storage Gen2 (Bronze)
                    │
                    ▼ Transform (Python / Databricks CE local)
            Curated Parquet Tables (Silver → Gold)
                    │
                    ▼
                Power BI Dashboards
    ```

---

## 🔧 Tech Stack

| Area | Services |
|---|---|
| Ingestion | Azure Functions, REST APIs |
| Orchestration | Azure Data Factory |
| Storage | Azure Data Lake Gen2 (hierarchical namespaces) |
| Transformations | Python scripts / Notebooks |
| Analytics | Power BI (local dev free) |
| DevOps | GitHub Actions (optional), GitHub Pages |

---

## 🗂 Data Lake Structure

    ```
        /raw (Bronze)
        /raw/solar/yyyy/mm/dd/.json
        /raw/heatpump/yyyy/mm/dd/.json
        /raw/weather/yyyy/mm/dd/*.json

        /curated (Silver)
        /curated/solar_daily.parquet
        /curated/heatpump_usage.parquet
        /curated/weather_hourly.parquet

        /gold (Analytics)
        /gold/energy_summary_daily.parquet
        /gold/solar_vs_consumption.parquet
        /gold/electricity_cost_estimates.parquet
    ```

---

## 📊 Dashboard Ideas

- Solar production vs grid import/export
- Heat pump energy usage vs outside temperature
- COP / efficiency calculation over time
- Weather-adjusted consumption analysis
- Forecast next-day usage (stretch goal)
- Alerts for abnormal usage patterns

**Screenshots will go here:**

> _📌 Coming soon_

---

## 🧩 Features to Implement

### Phase 1 — Foundations ✔️/⬛
- [ ] Set up Azure Subscription resources  
- [ ] Create Storage Account (Data Lake Gen2)  
- [ ] Create Azure Function for Solar API ingestion  
- [ ] Create ADF pipeline to schedule ingestion  

### Phase 2 — Processing
- [ ] Transform raw JSON → Parquet  
- [ ] Create partitioned curated tables  
- [ ] Build daily aggregations (Gold layer)  

### Phase 3 — Analytics & Visualization
- [ ] Build Power BI dashboard  
- [ ] Add trend & seasonal charts  
- [ ] Add forecasting & anomaly detection (optional)  

### Phase 4 — Polish for Portfolio
- [ ] Add architecture diagram  
- [ ] Upload sample dashboards  
- [ ] Add cost estimates + lessons learned section  
- [ ] Publish project summary site via GitHub Pages  

---

## 🚀 Roadmap (Future Enhancements)

- Home battery data integration  
- Real-time streaming ingestion  
- Deploy ETL via CI/CD & IaC (Terraform/Bicep)  
- API authentication renewal automation  
- Add ML model for consumption forecasting  
- Smart-alert notifications to email/phone  

---

## 📝 Documenting the Journey

For employers/interviewers, I will maintain:

- `/docs/architecture.md` — deep-dive into design  
- `/docs/decisions.md` — tradeoffs, learning notes  
- `/docs/costs.md` — real cloud cost tracking  
- `/docs/etl-details.md` — ingestion & pipeline logic  

📍 *This isn't just code — it's a story.*

---

⭐ Contributions & suggestions welcome.

---
