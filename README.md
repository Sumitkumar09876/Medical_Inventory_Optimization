# Medical Inventory Optimization

## Overview
The **Medical Inventory Optimization** project aims to reduce the **bounce rate** in a healthcare organization, which directly impacts patient satisfaction. The primary goal is to **reduce the bounce rate by at least 30%** through data-driven insights and optimization strategies.

## Objectives
- Address the increasing bounce rate in a healthcare organization.
- Achieve a **minimum reduction of 30%** in bounce rate.

## Project Phases
### 1. Data Pre-processing
- Involves **cleaning and preparing** data for analysis.
- Detailed instructions and code are provided in the **"Pre-processing Code SQL"** file.

### 2. Exploratory Data Analysis (EDA)
- Analyze various data points to derive **actionable insights**.
- Identify key factors contributing to high bounce rates.

## Key Insights
### Subcategories
- **Injections, tablets, IV fluids, electrolytes, and TPN** have the highest number of returns.

### Departments
- **Department 1** has the **highest average returns**.
- **Specialization 41** has the **highest average sales**.
- **Department 1** also has the highest **average sales** among all departments.

### Forms
- **Form 1** has the **most return quantity**.
- **Form 3** has the **lowest return quantities**.

### Sales Trends
- **December** records the **highest sales** compared to other months.

## Business Insights
- The analysis helps in understanding the **patterns of product returns and sales**.
- Provides **actionable insights** for improving **inventory management**.
- Helps in **reducing bounce rates** in healthcare organizations.

## Repository Structure
```
├── data/                 # Contains raw and processed datasets
├── scripts/              # SQL and Python scripts for data processing and analysis
├── notebooks/            # Jupyter notebooks for EDA and insights
├── reports/              # Business insights and visualization reports
├── README.md             # Project overview and documentation
```

## Technologies Used
- **SQL** for data pre-processing
- **Python (Pandas, NumPy, Matplotlib, Seaborn)** for data analysis
- **Machine Learning** techniques for predictive insights (if applicable)

## How to Run the Project
1. Clone the repository:
   ```sh
   git clone https://github.com/your-repo/Medical_Inventory_Optimization.git
   cd medical-inventory-optimization
   ```
2. Install dependencies:
   ```sh
   pip install -r requirements.txt
   ```
3. Run the pre-processing script:
   ```sh
   python scripts/preprocessing.py
   ```
4. Perform Exploratory Data Analysis (EDA) using the Jupyter notebook.
5. Review insights and implement strategies for inventory optimization.

