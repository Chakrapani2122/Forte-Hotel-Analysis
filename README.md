# Forte Hotel Analysis: Conjoint Study & Market Segmentation

A comprehensive R-based conjoint analysis project for the Forte Hotel brand. This analysis identifies which hotel attributes drive customer preferences, discovers distinct customer segments, and simulates market share outcomes for different hotel concepts.

## 📋 Table of Contents

- [Overview](#overview)
- [Problem & Objectives](#problem--objectives)
- [Features](#features)
- [Project Structure](#project-structure)
- [Prerequisites & Installation](#prerequisites--installation)
- [Usage & Running the Analysis](#usage--running-the-analysis)
- [Key Findings & Outputs](#key-findings--outputs)
- [Data Files](#data-files)
- [Configuration](#configuration)
- [Dependencies & Technologies](#dependencies--technologies)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

The **Forte Hotel Analysis** project is a complete conjoint analysis case study designed to translate customer preferences into actionable marketing recommendations. Using survey data from hotel guests, this analysis:

1. **Quantifies preference drivers** through part-worth utility estimation
2. **Identifies customer segments** with different preference structures
3. **Simulates market outcomes** under different hotel concept scenarios
4. **Generates marketing recommendations** for product design, positioning, and pricing

This project demonstrates best practices in conjoint analysis, data preparation, segmentation modeling, and market simulation—all implemented in R using the `conjoint` package.

---

## Problem & Objectives

### Marketing Problem
Forte Hotel needs to understand:
- **Which attribute combinations** drive customer preference?
- **Do distinct customer segments** exist with different needs?
- **Which hotel concepts** are most attractive to the market?

### Marketing Objectives
- Translate conjoint outputs into **positioning and product-design recommendations**
- Identify **attribute trade-offs** to guide pricing strategy
- Support **go/no-go decision-making** for new hotel concepts

### Business Context
The analysis covers a **full factorial design of 216 possible hotel concepts**, with customer ratings collected on a targeted subset of profiles. Results enable the marketing team to make data-driven decisions about hotel features and service offerings.

---

## Features

✅ **Complete Conjoint Pipeline**
- Orthogonal factorial design generation
- Part-worth utility estimation (respondent-level)
- Total utility calculation and interpretation

✅ **Customer Segmentation**
- K-means clustering on preference structures
- Support for 2, 3, or more segment solutions
- Segment visualization and discrimination

✅ **Market Simulation**
- Logit-based market share modeling
- Multi-concept comparison
- Stability-enhanced utility calculations

✅ **Comprehensive Outputs**
- Importance scores by respondent
- Conjoint summary statistics
- Cluster visualizations
- Market share rankings

✅ **Data Validation**
- Automatic consistency checks between profiles and preferences
- Robust error handling for missing or malformed data

---

## Project Structure

```
Forte-Hotel-Analysis/
├── README.md                                          # This file
├── LICENSE                                            # GNU General Public License v3
│
├── conjoint forte hotel final.R                       # Main analysis script
│
├── Data Files (CSV)
│   ├── forte_profiles.csv                             # 16 rated hotel profiles
│   ├── forte_preferences.csv                          # Customer ratings (respondents × profiles)
│   ├── forte_levels.csv                               # Attribute level descriptions
│   ├── forte_simulation1.csv                          # Simulation 1: candidate profiles
│   └── forte_simulation2.csv                          # Simulation 2: candidate profiles
│
├── Excel Reference Data
│   ├── Forte Hotel Data (Conjoint, 1 Ratings).xls     # Original survey ratings
│   ├── Forte Hotel Data (Conjoint, 2 Partworths).xls   # Estimated part-worth utilities
│   └── Forte Hotel Data (Conjoint, 3 Analysis).xls     # Segmentation & simulation results
│
└── Forte Hotel Design Case (Conjoint).pdf             # Original case study document
```

### Key Files Explained

| File | Purpose | Format |
|------|---------|--------|
| `conjoint forte hotel final.R` | Main analysis script implementing all analyses | R script (220 lines) |
| `forte_profiles.csv` | 16 hotel profiles used in survey (rows) × 5 attributes (columns) | CSV |
| `forte_preferences.csv` | Customer ratings: respondents (rows) × profiles (columns) | CSV |
| `forte_levels.csv` | Mapping of attribute indices to human-readable level names | CSV |
| `forte_simulation1.csv` | Test scenario 1: candidate hotel concepts for market share simulation | CSV |
| `forte_simulation2.csv` | Test scenario 2: candidate hotel concepts for market share simulation | CSV |

---

## Prerequisites & Installation

### System Requirements

- **R 3.6+** (recommended: R 4.0 or later)
- **RStudio** (recommended for interactive development)
- 2+ GB RAM (for clustering and simulations)

### Step 1: Install R

Download and install from [CRAN](https://cran.r-project.org/):

```bash
# macOS (via Homebrew)
brew install r

# Ubuntu/Debian
sudo apt-get install r-base r-base-dev

# Windows
# Download from https://cran.r-project.org/bin/windows/base/
```

### Step 2: Install Required R Packages

Install the required packages in R:

```r
# Install from CRAN
install.packages(c("conjoint", "fpc", "broom", "ggplot2"))
```

**Package Descriptions:**

| Package | Version | Purpose |
|---------|---------|---------|
| `conjoint` | Latest | Core conjoint analysis functions (utilities, segmentation, simulation) |
| `fpc` | Latest | Flexible procedures for clustering & discriminant analysis |
| `broom` | Latest | Tidying model outputs into data frames |
| `ggplot2` | Latest | Data visualization (optional, for enhanced plots) |

### Step 3: Clone or Download the Repository

```bash
git clone https://github.com/Chakrapani2122/Forte-Hotel-Analysis.git
cd Forte-Hotel-Analysis
```

Or download as ZIP and extract.

---

## Usage & Running the Analysis

### Running the Complete Analysis

Execute the main R script in RStudio or from the R console:

```r
setwd("/path/to/Forte-Hotel-Analysis")
source("conjoint forte hotel final.R")
```

Or from the command line:

```bash
Rscript "conjoint forte hotel final.R"
```

### What the Script Outputs

The script runs 7 major sections:

#### **Section 1: Data Understanding & Design Reference**
- Generates full factorial design (216 profiles)
- Loads survey data and validates structure
- Prints data dimensions: profiles, respondents, attributes

**Console Output:**
```
--- Data Structure ---
preferences: 26 respondents x 16 profiles
profiles: 16 rated profiles x 5 attributes
level names: 15 rows
simulation 1: 3 candidate profiles
simulation 2: 3 candidate profiles
```

#### **Section 2: Data Preparation**
- Validates alignment between preferences and profiles
- Checks simulation data conformity
- Ensures data integrity before analysis

#### **Section 3: Estimating Conjoint Utilities**
- Calculates **part-worth utilities** (attribute-level coefficients)
- Calculates **total utilities** (profile-level preferences)
- Outputs importance scores

**Console Output:**
```
--- Part-Worth Utilities (first 6 respondents) ---
             intercept room.1 room.2 ... delivery.1
Respondent1      50.23   8.45  -3.22 ...     -5.12
Respondent2      48.91  -2.10   5.67 ...      3.45
...

--- Total Utilities (first 6 respondents) ---
             Profile1 Profile2 Profile3 ...
Respondent1     56       48       31   ...
Respondent2     25       58       49   ...
```

#### **Section 4: Respondent-Level Analysis (Example: Respondent 26)**
- Shows individual preference structure
- Demonstrates interpretation for marketing teams

**Console Output:**
```
--- Attribute Importance for Respondent 26 ---
       room   amenity leisure  extras delivery
         22       18      35      15       10

--- Conjoint Summary for Respondent 26 ---
[Individual profile utilities and attribute-level importances]
```

#### **Section 5: Respondent Segmentation**
- Performs K-means clustering on preference structures
- Tests 2-segment and 3-segment solutions
- Generates cluster visualizations (if interactive)

**Console Output:**
```
--- Two-Segment Solution ---
Segment Sizes: Group1: 15, Group2: 11

--- Three-Segment Solution ---
Segment Sizes: Group1: 10, Group2: 9, Group3: 7

--- Segmentation Summary ---
[Cluster quality metrics and within-group homogeneity]
```

#### **Section 6: Market Share Simulation**
- Estimates profile utilities for candidate hotel concepts
- Calculates logit-based market shares
- Ranks profiles by competitive strength

**Console Output:**
```
--- Simulation 1 Market Share ---
     profile logit_share
Profile 2     0.4521
Profile 1     0.3847
Profile 3     0.1632

--- Simulation 2 Market Share ---
     profile logit_share
Profile 1     0.5123
Profile 3     0.3245
Profile 2     0.1632
```

#### **Section 7: Conclusion**
- Summary recommendations based on analysis

### Interactive Mode (Recommended)

For enhanced exploration in RStudio:

```r
# Load the script interactively
setwd("/path/to/Forte-Hotel-Analysis")
source("conjoint forte hotel final.R")

# The script includes interactive plotting if running in RStudio:
# - K-means cluster visualization
# - Discriminant coordinate projection
# - Segment membership plot
```

### Custom Analysis Examples

After sourcing the main script, you can perform additional analyses:

```r
# Example 1: Extract part-worth utilities
utilities_matrix <- part_utilities
head(utilities_matrix)

# Example 2: Check segment assignments for a specific respondent
respondent_id <- 5
segment_assignment <- segments_3$segm$cluster[respondent_id]
print(paste("Respondent", respondent_id, "is in Segment", segment_assignment))

# Example 3: Calculate importance scores for all respondents
all_importance <- t(apply(preferences, 1, 
    function(prefs) caImportance(prefs, profiles)))
head(all_importance)

# Example 4: Manual simulation for a custom profile
custom_profile <- data.frame(
    room = 2, amenity = 1, leisure = 3, extras = 2, delivery = 1
)
custom_utilities <- estimate_profile_utilities(part_utilities, custom_profile)
custom_share <- estimate_logit_shares(custom_utilities)
print(paste("Market share:", round(custom_share, 3)))
```

---

## Key Findings & Outputs

### Typical Conjoint Analysis Findings

The analysis typically produces:

1. **Part-Worth Utilities**
   - Positive values: attribute levels that increase preference
   - Negative values: attribute levels that decrease preference
   - Example: "Room office" might have +8.5 utility, "small suite" -3.2

2. **Attribute Importance Scores**
   - Percentage contribution of each attribute to overall preference
   - Used to prioritize product features for development
   - Example: "Leisure amenities" (35%), "Room type" (22%), etc.

3. **Customer Segments**
   - 2-segment solution: Value vs. Premium seekers
   - 3-segment solution: Finer differentiation for targeted marketing
   - Each segment has distinct utility patterns

4. **Market Share Predictions**
   - Logit model predicts choice probability for candidate profiles
   - Enables go/no-go decision-making
   - Supports competitive positioning analysis

### Interpretation Guidelines

- **Higher part-worth = stronger preference driver**
- **Wider range across levels = more important attribute**
- **Negative importances = "nice-to-have" attributes**
- **Segment heterogeneity = targeting opportunity**

---

## Data Files

### Input Data Formats

#### `forte_profiles.csv`
Describes the 16 profiles shown to customers:

```
room,amenity,leisure,extras,delivery
1,1,1,1,1
2,2,3,1,2
3,1,2,3,1
...
```

**Column Meanings:**
- `room`: 1=small suite, 2=large room, 3=room office
- `amenity`: 1=internet, 2=speaker phone, 3=room fax
- `leisure`: 1=exercise room, 2=pool, 3=exercise+pool
- `extras`: 1=shoe shine, 2=tape library, 3=fruit cheese, 4=newspaper
- `delivery`: 1=yes, 2=no

#### `forte_preferences.csv`
Customer ratings (1-100 scale) for each profile:

```
profile01,profile02,profile03,...,profile16
56,48,31,47,24,69,34,22,28,30,76,36,27,16,29,58
25,58,49,71,58,63,38,36,34,52,38,80,49,74,13,58
```

**Format:**
- Rows = respondents (N=26)
- Columns = profiles (P=16)
- Values = preference ratings (1-100)

#### `forte_levels.csv`
Human-readable attribute level descriptions:

```
levels
small suite
large room
room office
internet
speaker phone
room fax
...
```

#### Simulation Files
`forte_simulation1.csv` and `forte_simulation2.csv` follow the same format as `forte_profiles.csv` but can contain alternative candidate profiles.

### Loading Data in R

```r
# All data loading is handled automatically by the script, but you can also do:
profiles <- read.csv("forte_profiles.csv", header = TRUE)
preferences <- read.csv("forte_preferences.csv", header = TRUE, check.names = FALSE)
levelnames <- read.csv("forte_levels.csv", header = TRUE)

# Inspect data
str(profiles)
head(preferences)
```

---

## Configuration

### Customizing the Analysis

#### 1. Change Segmentation Levels

```r
# Instead of 2 and 3 segments, try 4 and 5
segments_4 <- caSegmentation(preferences, profiles, c = 4)
segments_5 <- caSegmentation(preferences, profiles, c = 5)
```

#### 2. Add Custom Attributes

If extending the analysis with new hotel features:

```r
# Redefine hotel_attributes with additional levels
hotel_attributes <- expand.grid(
    room = c("small suite", "large room", "room office"),
    amenity = c("internet", "speaker phone", "room fax"),
    leisure = c("exercise room", "pool", "exercise + pool"),
    extras = c("shoe shine", "tape library", "fruit cheese", "newspaper", "mini bar"),  # NEW
    delivery = c("yes", "no"),
    stringsAsFactors = FALSE
)
```

#### 3. Adjust Visualization Colors

```r
# Customize cluster plot colors
ggplot(segment_assignments) +
    geom_point(aes(x = X1, y = X2, color = .cluster), size = 3) +
    scale_color_brewer(palette = "Set1") +
    labs(title = "Segmentation Results")
```

#### 4. Filter by Segment for Targeted Analysis

```r
# Analyze only Segment 1 respondents
segment_1_ids <- which(segments_3$segm$cluster == 1)
segment_1_prefs <- preferences[segment_1_ids, ]
segment_1_utils <- caPartUtilities(segment_1_prefs, profiles, levelnames)
```

---

## Dependencies & Technologies

### Core Dependencies

| Tool | Version | Role |
|------|---------|------|
| **R** | 3.6+ | Statistical programming language |
| **conjoint** | 0.92+ | Conjoint analysis algorithms |
| **fpc** | 2.2+ | Clustering & discrimination |
| **broom** | 0.7+ | Data frame tidying utilities |
| **ggplot2** | 3.3+ | Publication-quality visualization |

### Technology Stack

- **Language:** R (statistical computing)
- **Analysis Type:** Conjoint Analysis (preference-based trade-off modeling)
- **Segmentation:** K-means Clustering
- **Market Simulation:** Multinomial Logit Model
- **Visualization:** ggplot2, base R graphics

### Installation Verification

```r
# Verify all packages are installed
packages <- c("conjoint", "fpc", "broom", "ggplot2")
installed <- all(packages %in% rownames(installed.packages()))
print(installed)  # Should return TRUE

# Check package versions
packageVersion("conjoint")
packageVersion("ggplot2")
```

---

## Contributing

### How to Contribute

1. **Report Issues:** Open an issue describing the problem with reproducible steps
2. **Submit Enhancements:** Propose new features or analysis improvements
3. **Code Contributions:**
   - Fork the repository
   - Create a feature branch (`git checkout -b feature/your-feature`)
   - Make changes with clear commit messages
   - Push to your fork and create a Pull Request

### Contribution Guidelines

- Keep analysis reproducible (use `set.seed()` for random operations)
- Add comments for complex code sections
- Test changes against all data files
- Update documentation when adding new features
- Follow R style conventions (camelCase for variables, snake_case for files)

### Areas for Contribution

- Enhanced visualization functions
- Sensitivity analysis on segment count
- Additional market simulation scenarios
- Performance optimization for larger datasets
- Python or Julia implementations

---

## License

This project is licensed under the **GNU General Public License v3.0** — see the [LICENSE](LICENSE) file for details.

**Summary:**
- ✅ Free to use, modify, and distribute
- ✅ Modifications must remain open-source
- ✅ Must include original license and copyright notices
- ❌ No warranty or liability

---

## Getting Help

### Common Issues

**Q: "Package 'conjoint' not found"**
```r
install.packages("conjoint")
library(conjoint)
```

**Q: "CSV not found" error**
- Ensure your working directory is set correctly: `setwd("/path/to/Forte-Hotel-Analysis")`
- Verify CSV files exist in the project directory

**Q: Different results each run?**
- Add `set.seed(42)` at the top of the script for reproducibility

**Q: Can't create cluster plots?**
- Ensure `ggplot2` and `fpc` are installed and loaded
- Run in RStudio or an interactive R session

### Resources

- [Conjoint Analysis Best Practices](https://www.sawtooth.com/education)
- [R for Data Science](https://r4ds.had.co.nz/)
- [ggplot2 Documentation](https://ggplot2.tidyverse.org/)
- Original case study: See `Forte Hotel Design Case (Conjoint).pdf` in the repository

---

**Last Updated:** 2026-06-02
**Maintained by:** Chakrapani2122
**Project Repository:** [Forte-Hotel-Analysis](https://github.com/Chakrapani2122/Forte-Hotel-Analysis)
