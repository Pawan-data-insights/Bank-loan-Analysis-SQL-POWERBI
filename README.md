<div align="center">

# 🏦 Bank Loan Analysis
### End-to-End Analytics: **SQL Server ➜ Power BI**

*Transforming raw loan records into portfolio-level insight on lending performance, risk and customer behaviour.*

![SQL Server](https://img.shields.io/badge/SQL%20Server-T--SQL-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-Measures-0078D4?style=for-the-badge)
![Domain](https://img.shields.io/badge/Domain-Banking%20%26%20Finance-1F6F5C?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Completed-2EA44F?style=for-the-badge)

</div>

---

## 📑 Table of Contents
1. [Project Overview](#-project-overview)
2. [Business Problem & Objectives](#-business-problem--objectives)
3. [Tech Stack](#-tech-stack)
4. [Workflow Architecture](#-workflow-architecture)
5. [Dataset](#-dataset)
6. [Phase 1: SQL Server Analysis](#-phase-1--sql-server-analysis)
7. [Phase 2: Power BI Development](#-phase-2--power-bi-development)
8. [Dashboard Preview](#-dashboard-preview)
9. [Key Insights](#-key-insights)
10. [Repository Structure](#-repository-structure)
11. [How to Run](#-how-to-run)
12. [Future Enhancements](#-future-enhancements)
13. [Author](#-author)

---

## 📌 Project Overview

This project is a complete **banking and finance analytics solution** built in two phases:

| Phase | Tool | Purpose |
|:--:|:--|:--|
| **1** | **Microsoft SQL Server** | Load the raw loan data, then compute KPIs, Month-to-Date (MTD) and Previous-Month-to-Date (PMTD) metrics, and segment-level aggregations using T-SQL |
| **2** | **Power BI** | Connect to the database, model the data, write DAX measures and publish an interactive 3-page dashboard (**Summary, Overview, Details**) |

The result is a decision-ready report that lets a lending team monitor **portfolio health, track growth month over month and separate good loans from bad loans** in seconds.

---

## 🎯 Business Problem & Objectives

A bank's lending team needs a single source of truth to answer questions such as:

- How many loan applications did we receive, and how much did we **fund** and **collect**?
- What are the **average interest rate** and **debt-to-income (DTI)** across the portfolio?
- What share of the portfolio is **healthy (Good Loan)** versus **at risk (Bad Loan)**?
- How do these metrics change **month over month**?
- Which **states, loan terms, employment lengths, purposes and home-ownership types** drive volume and risk?

**Objectives**
- ✅ Monitor lending KPIs with MTD and MoM comparisons
- ✅ Classify loans into **Good** and **Bad** and quantify each
- ✅ Analyse trends across time, geography and borrower profile
- ✅ Deliver an interactive, filterable dashboard for stakeholders

---

## 🧰 Tech Stack

| Layer | Technology |
|:--|:--|
| Database | Microsoft SQL Server (SSMS) |
| Query Language | T-SQL |
| BI & Visualisation | Power BI Desktop |
| Calculation Language | DAX |
| Version Control | Git & GitHub |

---

## 🧭 Workflow Architecture

```mermaid
flowchart LR
    A[📄 Raw Loan Data<br/>CSV / Excel] --> B[(🗄️ SQL Server<br/>bank_loan_data)]
    B --> C[🔍 T-SQL Analysis<br/>KPIs, MTD, MoM, Segments]
    B --> D[🔌 Power BI<br/>Data Connection]
    D --> E[🧹 Power Query<br/>Cleaning & Typing]
    E --> F[🧩 Data Model<br/>& DAX Measures]
    F --> G[📊 Interactive Dashboard<br/>Summary | Overview | Details]
    C -. validates .-> F
```

---

## 🗃️ Dataset

**Table:** `bank_loan_data` &nbsp;|&nbsp; **Records:** ~38,576 loan applications &nbsp;|&nbsp; **Reference periods:** MTD = Dec 2021, PMTD = Nov 2021

| Column | Description |
|:--|:--|
| `id` | Unique loan application ID |
| `issue_date` | Date the loan was issued |
| `loan_status` | `Fully Paid`, `Current` or `Charged Off` |
| `loan_amount` | Amount funded by the bank |
| `total_payment` | Total amount received from the borrower |
| `int_rate` | Interest rate on the loan |
| `dti` | Debt-to-income ratio of the borrower |
| `term` | Loan term (months) |
| `emp_length` | Borrower's employment length |
| `purpose` | Purpose of the loan |
| `home_ownership` | Rent / Mortgage / Own / Other |
| `address_state` | State of the borrower |
| `grade` | Loan grade |

---

## 🛢️ Phase 1: SQL Server Analysis

### Step 1: Load the data into SQL Server
1. Create a database and import the dataset (CSV/Excel) using the **SSMS Import Flat File / Import Data wizard**.
2. Name the destination table `bank_loan_data`.
3. Verify data types (dates as `DATE`, amounts and ratios as numeric) and run a sanity check:

```sql
SELECT * FROM bank_loan_data;
SELECT COUNT(id) AS total_applications FROM bank_loan_data;
```

### Step 2: Key Performance Indicators (KPIs)

Each KPI is computed in three flavours: **overall**, **MTD** (December 2021) and **PMTD** (November 2021), so month-over-month change can be derived.

| KPI | Logic |
|:--|:--|
| Total Loan Applications | `COUNT(id)` |
| Total Funded Amount | `SUM(loan_amount)` |
| Total Amount Received | `SUM(total_payment)` |
| Average Interest Rate | `ROUND(AVG(int_rate) * 100, 2)` |
| Average DTI | `ROUND(AVG(dti) * 100, 2)` |

```sql
-- Total applications: overall, MTD and PMTD
SELECT COUNT(id) AS total_applications FROM bank_loan_data;

SELECT COUNT(id) AS mtd_total_applications
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

SELECT COUNT(id) AS pmtd_total_applications
FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;
```

### Step 3: Good Loan vs Bad Loan Classification

| Category | Definition |
|:--|:--|
| ✅ **Good Loan** | `loan_status` is **Fully Paid** or **Current** |
| ❌ **Bad Loan** | `loan_status` is **Charged Off** |

```sql
-- Good loan percentage
SELECT
    COUNT(CASE WHEN loan_status IN ('Fully Paid','Current') THEN id END) * 100.0
    / COUNT(id) AS good_loan_percentage
FROM bank_loan_data;

-- Bad loan percentage
SELECT
    COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0
    / COUNT(id) AS bad_loan_percentage
FROM bank_loan_data;
```

For each category the analysis also reports **applications, funded amount and amount received**.

> 💡 **Tip:** multiply by `100.0` (decimal) rather than `100` to avoid T-SQL integer division truncating the percentage.

### Step 4: Loan Status Grid View

```sql
SELECT loan_status,
       COUNT(id)                    AS loan_count,
       SUM(total_payment)           AS total_amount_received,
       SUM(loan_amount)             AS total_funded_amount,
       ROUND(AVG(int_rate * 100),2) AS interest_rate,
       ROUND(AVG(dti * 100),2)      AS dti
FROM bank_loan_data
GROUP BY loan_status;
```

### Step 5: Dimensional Analysis (feeds the Overview page)

| Analysis | Grouped By | Measures |
|:--|:--|:--|
| 📅 Monthly Trend | `MONTH(issue_date)` / `DATENAME(month, issue_date)` | Applications, Funded, Received |
| 🗺️ Regional Analysis | `address_state` | Applications, Funded, Received |
| ⏳ Loan Term Analysis | `term` | Applications, Funded, Received |
| 💼 Employment Length | `emp_length` | Applications, Funded, Received |
| 🎯 Loan Purpose | `purpose` | Applications, Funded, Received |
| 🏠 Home Ownership | `home_ownership` | Applications, Funded, Received |

```sql
-- Example: monthly trend
SELECT MONTH(issue_date)           AS month_number,
       DATENAME(month, issue_date) AS month_name,
       COUNT(id)                   AS total_loan_application,
       SUM(loan_amount)            AS total_funded_amount,
       SUM(total_payment)          AS total_amount_received
FROM bank_loan_data
GROUP BY MONTH(issue_date), DATENAME(month, issue_date)
ORDER BY MONTH(issue_date);
```

📂 The full script is available in [`sql/bank_loan_data_sql_query.sql`](sql/bank_loan_data_sql_query.sql).

---

## 📊 Phase 2: Power BI Development

### Step 1: Connect to SQL Server
`Home ➜ Get Data ➜ SQL Server` ➜ enter the server and database name ➜ select `bank_loan_data` ➜ **Load** (Import mode).

### Step 2: Clean & Transform (Power Query)
- Set correct data types (`issue_date` as Date, amounts as Fixed Decimal, ratios as Decimal)
- Check for nulls, duplicates and inconsistent text in `loan_status`, `purpose` and `emp_length`
- Remove unused columns to keep the model lean

### Step 3: Build a Date Table & Model
- Create a calendar table and relate it to `issue_date`
- Mark it as the official **Date Table** to enable time-intelligence DAX (MTD, PMTD, MoM)

### Step 4: Create DAX Measures

```DAX
-- Core KPIs
Total Loan Applications = COUNT(bank_loan_data[id])
Total Funded Amount     = SUM(bank_loan_data[loan_amount])
Total Amount Received   = SUM(bank_loan_data[total_payment])
Avg Interest Rate       = AVERAGE(bank_loan_data[int_rate])
AVG DTI                 = AVERAGE(bank_loan_data[dti])

-- Month-to-Date and Previous Month-to-Date
MTD Total Funded Amount =
    TOTALMTD([Total Funded Amount], 'Date'[Date])

PMTD Total Funded Amount =
    CALCULATE([Total Funded Amount], DATEADD('Date'[Date], -1, MONTH))

-- Month-over-Month growth
MoM Funded Amount =
    DIVIDE([MTD Total Funded Amount] - [PMTD Total Funded Amount],
           [PMTD Total Funded Amount])

-- Good vs Bad loans
Good Loan Applications =
    CALCULATE([Total Loan Applications],
              bank_loan_data[loan_status] IN {"Fully Paid", "Current"})

Good Loan % = DIVIDE([Good Loan Applications], [Total Loan Applications])

Bad Loan Applications =
    CALCULATE([Total Loan Applications],
              bank_loan_data[loan_status] = "Charged Off")

Bad Loan % = DIVIDE([Bad Loan Applications], [Total Loan Applications])
```

The same pattern is repeated for **Good / Bad Loan Funded Amount** and **Good / Bad Loan Received Amount**.

### Step 5: Design the Dashboard

| Page | Purpose | Key Visuals |
|:--|:--|:--|
| **📌 Summary** | Executive snapshot of KPIs and loan quality | KPI cards (with MTD & MoM), Good vs Bad donut charts, Loan Status matrix |
| **📈 Overview** | Trends and segmentation | Monthly trend (area/line), State map, Term, Employment length, Purpose, Home ownership |
| **🔎 Details** | Record-level drill-down | Detailed table of loan applications |

**Interactivity:** slicers for **State, Grade and Purpose**, page-navigation buttons, cross-filtering and a consistent dark-green theme with a custom bank icon and background.

### Step 6: Validate & Publish
- Reconcile Power BI totals with the SQL results (e.g. 38,576 applications)
- Format numbers (K / M), add tooltips and test the slicers
- Publish to the Power BI Service and share with stakeholders

---

## 🖼️ Dashboard Preview

### Summary Page
![Bank Loan Report: Summary](images/dashboard_summary.png)

> 📸 Add your **Overview** and **Details** page screenshots to the `images/` folder and link them here.

---

## 💡 Key Insights

### Portfolio KPIs (Summary Page)

| Metric | Overall | MTD (Dec 2021) | MoM Change |
|:--|:--:|:--:|:--:|
| 📝 Total Loan Applications | **38.6K** | 4.3K | ▲ 6.91% |
| 💰 Total Funded Amount | **$436M** | $54M | ▲ 13.0% |
| 💵 Total Amount Received | **$473M** | $58M | ▲ 15.8% |
| 📈 Average Interest Rate | **12.05%** | 12.0% | ▲ 3.47% |
| ⚖️ Average DTI | **13.3%** | 13.7% | ▲ 2.7% |

### Loan Quality

| | ✅ Good Loans | ❌ Bad Loans |
|:--|:--:|:--:|
| **Share of portfolio** | **86%** | **13.82%** |
| **Applications** | 33K | 5K |
| **Funded amount** | $370.2M | $65.5M |
| **Amount received** | $435.8M | $37.3M |

### Loan Status Breakdown

| Loan Status | Applications | Avg Interest Rate | Avg DTI |
|:--|--:|:--:|:--:|
| Fully Paid | 32,145 | 11.64% | 13.2% |
| Current | 1,098 | 15.10% | 14.7% |
| Charged Off | 5,333 | 13.88% | 14.0% |
| **Grand Total** | **38,576** | **12.05%** | **13.3%** |

### 🔍 Takeaways
- **Healthy portfolio:** about **86%** of loans are Good, and total receipts (**$473M**) exceed total funding (**$436M**).
- **Strong growth:** December shows double-digit MoM growth in both funded amount (**+13.0%**) and amount received (**+15.8%**).
- **Risk signal:** Charged-Off loans carry a higher interest rate (**13.88%**) and DTI (**14.0%**) than Fully Paid loans (**11.64%** and **13.2%**), pointing to **higher-rate, higher-leverage borrowers** as the riskier segment.
- **Loss exposure:** Bad loans were funded with **$65.5M** but recovered only **$37.3M**.

---

## 📁 Repository Structure

```
📦 bank-loan-analysis
 ┣ 📂 data
 ┃ ┗ 📄 bank_loan_data.csv
 ┣ 📂 sql
 ┃ ┗ 📄 bank_loan_data_sql_query.sql
 ┣ 📂 powerbi
 ┃ ┗ 📄 Bank_Loan_Report.pbix
 ┣ 📂 images
 ┃ ┗ 🖼️ dashboard_summary.png
 ┗ 📄 README.md
```

---

## ▶️ How to Run

1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/bank-loan-analysis.git
   ```
2. **Load the data** into SQL Server and name the table `bank_loan_data`.
3. **Run the SQL script** in `sql/` using SSMS to reproduce the KPIs and segment analysis.
4. **Open** `powerbi/Bank_Loan_Report.pbix` in Power BI Desktop.
5. **Update the data source** (`Home ➜ Transform data ➜ Data source settings`) to point to your SQL Server instance, then **Refresh**.

**Requirements:** SQL Server + SSMS, Power BI Desktop (latest version).

---

## 🚀 Future Enhancements

- 🔄 Schedule automatic refresh via an on-premises data gateway
- 🤖 Add a loan-default prediction model (Python / scikit-learn)
- 🧮 Add risk scoring by grade, DTI band and income bracket
- 🔐 Row-level security by region
- 📱 Optimise a mobile layout

---

## 👤 Author

**Pawan Singh**
MBA (Finance & IT) | Aspiring Data Analyst / Financial Analyst
🛠️ Python • SQL • Excel • Power BI • MIS Reporting

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/your-profile)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/your-username)

---

<div align="center">

⭐ **If you found this project useful, please give it a star!** ⭐

</div>
