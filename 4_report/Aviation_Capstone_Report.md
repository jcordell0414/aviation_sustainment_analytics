# Aviation Operational Readiness & Sustainment Analytics
## Project Report

**Author:** Jace Cordell  
**Tools:** Python (pandas) | SQL | Tableau | Excel  
**Dataset:** 1,240 raw maintenance records → 1,200 cleaned  
**Date Range:** January 2024 – May 2025  
**Bases:** Eglin AFB | Fort Worth | Hill AFB | Luke AFB | Nellis AFB  
**Aircraft:** B-2 | C-130 | F-16 | F-22 | F-35A

---

## 1. Ask

### Business Question
Which maintenance categories, suppliers, and operational conditions drive the greatest risk to aviation readiness — and what targeted interventions will reduce downtime, supplier delays, and operational risk across the fleet?

### Stakeholders
- Maintenance Operations Leadership
- Supplier Relationship Management
- Base Commanders / Readiness Officers

### Success Metrics
- Reduce average downtime per maintenance event
- Decrease high-risk event rate (currently 19% of all events)
- Improve fleet-wide readiness score (currently averaging 77.4/100)
- Reduce delayed maintenance events (currently 24.4% of all events)

---

## 2. Prepare

### Data Source
Simulated aviation maintenance records modeled after real-world sustainment operations across five U.S. Air Force bases. The dataset reflects maintenance activity across five aircraft platforms over a 17-month observation window.

### Dataset Overview

| Attribute | Value |
|---|---|
| Raw records | 1,240 |
| Cleaned records | 1,200 |
| Records removed | 40 (3.2%) |
| Date range | January 1, 2024 – May 15, 2025 |
| Aircraft platforms | 5 (B-2, C-130, F-16, F-22, F-35A) |
| Base locations | 5 |
| Maintenance categories | 6 |
| Suppliers | 5 |

### Fields Collected

| Field | Description |
|---|---|
| `maintenance_id` | Unique event identifier |
| `aircraft_id` | Individual aircraft identifier |
| `aircraft_model` | Platform type |
| `base_location` | Operating base |
| `maintenance_type` | Category of maintenance performed |
| `supplier_name` | Parts/service supplier |
| `event_date` | Date of maintenance event |
| `downtime_hours` | Hours aircraft was non-operational |
| `supplier_delay_days` | Days of delay attributable to supplier |
| `maintenance_status` | Completed / In Progress / Delayed / Awaiting Parts |
| `maintenance_cost` | Total cost of event (USD) |
| `readiness_score` | Operational readiness score (0–100) |

---

## 3. Process

### Cleaning Steps (Python — pandas)

| Issue | Action | Records Affected |
|---|---|---|
| Inconsistent date formats (`11/23/2024` vs `2024-02-17`) | Standardized to `YYYY-MM-DD` via `pd.to_datetime()` | Multiple |
| Missing values in `downtime_hours` and `supplier_delay_days` | Removed rows with null critical fields | 40 rows removed |
| Duplicate `maintenance_id` values | Checked — none found | 0 |
| Data type mismatches | Cast `downtime_hours`, `supplier_delay_days`, `maintenance_cost` to numeric | All rows |

### Feature Engineering

Four calculated columns were added to support analysis:

| New Column | Logic |
|---|---|
| `month` | Extracted from `event_date` |
| `year` | Extracted from `event_date` |
| `total_delay` | `downtime_hours + supplier_delay_days` |
| `risk_level` | Classified as `High Risk` if `readiness_score < 70`, otherwise `Normal` |

**Final cleaned record count: 1,200**

---

## 4. Analyze

### 4.1 Fleet Overview

| KPI | Value |
|---|---|
| Total maintenance events | 1,200 |
| Total downtime hours | 21,349 |
| Average downtime per event | 17.79 hours |
| Total maintenance cost | $31,035,362.64 |
| Average cost per event | $25,862.80 |
| Fleet-wide average readiness score | 77.4 / 100 |
| High-risk events | 228 (19.0%) |
| Delayed events | 293 (24.4%) |

---

### 4.2 Downtime by Maintenance Category

Hydraulics generated the highest average downtime across the observation period, followed closely by Electrical and Engine Repair. All six categories averaged above 16 hours, indicating systemic downtime pressure across maintenance types.

| Maintenance Type | Avg Downtime (hrs) | Event Count | Avg Cost |
|---|---|---|---|
| Hydraulics | 18.64 | 214 | $25,813.99 |
| Electrical | 18.13 | 199 | $27,147.95 |
| Engine Repair | 17.94 | 213 | $24,124.42 |
| Landing Gear | 17.91 | 181 | $27,297.53 |
| Avionics | 17.14 | 200 | $25,259.74 |
| Software Update | 16.89 | 193 | $25,789.76 |

**Key finding:** Hydraulics and Electrical maintenance produce the highest average downtime. Landing Gear and Electrical produce the highest average cost per event despite lower downtime, suggesting parts and labor complexity independent of time.

---

### 4.3 High-Risk Event Distribution

228 events (19.0% of all maintenance events) were classified as High Risk based on a readiness score below 70.

**By Maintenance Type:**

| Maintenance Type | High-Risk Events |
|---|---|
| Hydraulics | 49 |
| Engine Repair | 43 |
| Electrical | 41 |
| Landing Gear | 39 |
| Software Update | 32 |
| Avionics | 24 |

**By Base Location:**

| Base | High-Risk Events |
|---|---|
| Luke AFB | 54 |
| Eglin AFB | 50 |
| Hill AFB | 45 |
| Nellis AFB | 45 |
| Fort Worth | 34 |

Luke AFB and Eglin AFB carry the highest concentration of high-risk events — together accounting for 45.6% of all high-risk classifications despite representing 39.3% of total records.

---

### 4.4 Supplier Performance

All five suppliers averaged between 4.48 and 4.98 days of delay per event. GE Aerospace produced the highest average delay and the most total delayed events.

| Supplier | Avg Delay (days) | Events | Delayed Events |
|---|---|---|---|
| GE Aerospace | 4.98 | 261 | 62 |
| Raytheon | 4.70 | 222 | 66 |
| Northrop | 4.56 | 254 | 55 |
| L3Harris | 4.55 | 232 | 65 |
| Boeing | 4.48 | 231 | 45 |

**Key finding:** Raytheon and L3Harris produced the highest number of delayed events (66 and 65 respectively) despite not having the highest average delay per event, suggesting a higher frequency of delay rather than longer individual delays. Boeing had the lowest delayed event count (45) across a comparable event volume.

---

### 4.5 Maintenance Status Breakdown

| Status | Count | % of Total |
|---|---|---|
| In Progress | 328 | 27.3% |
| Completed | 299 | 24.9% |
| Delayed | 293 | 24.4% |
| Awaiting Parts | 280 | 23.3% |

Nearly half of all open events (47.7%) are either Delayed or Awaiting Parts — a significant backlog signal. Only 24.9% of events in the dataset had reached Completed status.

---

### 4.6 Readiness Score by Base

Average readiness scores were relatively compressed across bases, ranging from 76.73 to 77.68 out of 100. Eglin AFB posted the lowest average readiness score despite having the second-highest high-risk event count.

| Base | Avg Readiness Score |
|---|---|
| Eglin AFB | 76.73 |
| Luke AFB | 77.35 |
| Hill AFB | 77.45 |
| Fort Worth | 77.67 |
| Nellis AFB | 77.68 |

---

### 4.7 Year-over-Year Trends

| Metric | 2024 | 2025 (Jan–May) |
|---|---|---|
| Avg Readiness Score | 77.50 | 77.11 |
| Avg Downtime (hrs) | 17.80 | 17.77 |

Readiness scores declined slightly from 2024 to the 2025 observation period. While the difference is modest (0.39 points), the trend warrants monitoring given that partial-year 2025 data reflects only the highest-activity months for some maintenance categories.

---

### 4.8 Downtime by Aircraft Platform

| Aircraft | Avg Downtime (hrs) |
|---|---|
| F-16 | 18.18 |
| F-35A | 17.82 |
| B-2 | 17.75 |
| F-22 | 17.71 |
| C-130 | 17.55 |

The F-16 averaged the highest downtime per maintenance event. All platforms clustered within a 0.63-hour range, indicating cross-platform consistency in maintenance duration rather than platform-specific outliers.

---

## 5. Share

### Dashboard

Interactive Tableau dashboards were developed to communicate findings to maintenance leadership. Three dashboard views were published:

- **Executive Summary** — Fleet-wide KPIs: total events, average downtime, total cost, average readiness score
- **Operational Trends** — Downtime trends by category and year, readiness score trends, supplier delay comparison
- **KPI Reporting** — Interactive filters by base, aircraft type, and maintenance category for targeted operational review

📊 [View Interactive Tableau Dashboards](https://public.tableau.com/views/aviation_maintenance_dashboards/OperationalTrendsDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

---

## 6. Act

### Recommendations

**1. Prioritize preventative maintenance scheduling for Hydraulics and Electrical categories.**

These two categories generated the highest average downtime (18.64 and 18.13 hours respectively) and together account for 39 of 49 high-risk Hydraulics events and 41 Electrical high-risk events. Shifting a portion of these from reactive to scheduled preventative maintenance would reduce unplanned downtime and readiness risk.

*KPI target: Reduce average downtime for Hydraulics and Electrical by 15% within 6 months through increased preventative scheduling frequency.*

**2. Establish supplier performance thresholds and escalation protocols for GE Aerospace and Raytheon.**

GE Aerospace averages 4.98 delay days per event — the highest of any supplier — and Raytheon generated the most total delayed events (66). Both suppliers contribute disproportionately to the 24.4% delayed event rate. Formal delay thresholds with escalation triggers and contingency sourcing options would reduce backlog accumulation.

*KPI target: Reduce delayed events attributable to top-two suppliers by 20% within 12 months.*

**3. Implement targeted readiness intervention at Luke AFB and Eglin AFB.**

These two bases account for 45.6% of all high-risk events. A base-level review of maintenance scheduling, parts inventory levels, and supplier lead times at these locations would identify whether the elevated risk concentration is driven by maintenance type mix, supplier assignments, or resource availability.

*KPI target: Reduce high-risk event rate at Luke AFB and Eglin AFB to fleet average (19%) within 9 months.*

**4. Address the Awaiting Parts backlog through inventory pre-positioning.**

280 events (23.3%) are in Awaiting Parts status — nearly matching the Delayed count. Cross-referencing the most common maintenance types in this status with supplier lead times would identify which parts to pre-position at high-volume bases, reducing wait-driven downtime without additional supplier dependency.

*KPI target: Reduce Awaiting Parts events by 25% at Hill AFB and Luke AFB (highest event volume bases) within 6 months.*

---

## Appendix: Data Cleaning Log

**Raw dataset:** 1,240 records, 12 fields  
**Cleaned dataset:** 1,200 records, 16 fields (4 engineered)  
**Records removed:** 40 (3.2%) — null values in critical numeric fields  
**Date standardization:** Mixed formats resolved to ISO 8601 (`YYYY-MM-DD`)  
**No duplicate maintenance IDs found**

---

*Built as part of a data analytics portfolio project. All data is simulated for analytical demonstration purposes.*  
*Author: Jace Cordell | [GitHub](https://github.com/jcordell0414) | [LinkedIn](https://www.linkedin.com/in/jcordell0414)*
