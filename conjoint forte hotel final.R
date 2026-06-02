## Forte Hotel Conjoint Analysis Case Study

############################################################
## Project Overview
## Marketing problem: understand which hotel attributes drive preference,
## identify distinct respondent segments, and compare simulated hotel offers.
## Marketing objective: translate conjoint outputs into actionable positioning,
## pricing, and product-design recommendations for Forte Hotel.
############################################################

suppressPackageStartupMessages({
    library(conjoint)
    library(fpc)
    library(broom)
    library(ggplot2)
})

############################################################
## 1) Data understanding and design reference
## The study uses the profiles already supplied in the project files.
## The full attribute space contains 216 possible hotel concepts, but the
## customer ratings were collected on the provided profile set rather than by
## generating new data.
############################################################

hotel_attributes <- expand.grid(
    room = c("small suite", "large room", "room office"),
    amenity = c("internet", "speaker phone", "room fax"),
    leisure = c("exercise room", "pool", "exercise + pool"),
    extras = c("shoe shine", "tape library", "fruit cheese", "newspaper"),
    delivery = c("yes", "no"),
    stringsAsFactors = FALSE
)

full_factorial_design <- caFactorialDesign(data = hotel_attributes, type = "orthogonal")
encoded_design <- caEncodedDesign(design = full_factorial_design)

preferences <- read.csv("forte_preferences.csv", header = TRUE, check.names = FALSE)
profiles <- read.csv("forte_profiles.csv", header = TRUE)
levelnames <- read.csv("forte_levels.csv", header = TRUE)
simulation1 <- read.csv("forte_simulation1.csv", header = TRUE)
simulation2 <- read.csv("forte_simulation2.csv", header = TRUE)

cat("\n--- Data Structure ---\n")
cat("preferences:", nrow(preferences), "respondents x", ncol(preferences), "profiles\n")
cat("profiles:", nrow(profiles), "rated profiles x", ncol(profiles), "attributes\n")
cat("level names:", nrow(levelnames), "rows\n")
cat("simulation 1:", nrow(simulation1), "candidate profiles\n")
cat("simulation 2:", nrow(simulation2), "candidate profiles\n")

############################################################
## 2) Data preparation
## The goal here is to confirm that the preference matrix and the profile
## design align before estimating utilities. This step ensures the conjoint
## model is built on the same profile structure used in the survey.
############################################################

stopifnot(ncol(preferences) == nrow(profiles))
stopifnot(all(colnames(profiles) == colnames(simulation1)))
stopifnot(all(colnames(profiles) == colnames(simulation2)))

############################################################
## 3) Estimating conjoint utilities
## Part-worth utilities quantify how each attribute level contributes to
## preference. Total utilities show the overall appeal of each profile.
############################################################

part_utilities <- caPartUtilities(y = preferences, x = profiles, z = levelnames)
total_utilities <- caTotalUtilities(y = preferences, x = profiles)

cat("\n--- Part-Worth Utilities (first 6 respondents) ---\n")
print(head(part_utilities))

cat("\n--- Total Utilities (first 6 respondents) ---\n")
print(head(total_utilities))

############################################################
## Marketing interpretation
## Use the part-worth table to identify which levels raise utility and which
## levels lower it. Positive values indicate stronger preference, while
## negative values indicate weaker appeal relative to the respondent's average.
############################################################

############################################################
## 4) Respondent-level importance and profile explanation
## A single respondent's importance scores are included to illustrate how the
## model translates into attribute-level trade-offs.
############################################################

respondent_id <- 26
importance_26 <- caImportance(y = preferences[respondent_id, ], x = profiles)

cat("\n--- Attribute Importance for Respondent 26 ---\n")
print(importance_26)

cat("\n--- Conjoint Summary for Respondent 26 ---\n")
Conjoint(preferences[respondent_id, ], profiles, levelnames)

cat("\n--- Conjoint Summary for All Respondents ---\n")
Conjoint(y = preferences, x = profiles, z = levelnames)

############################################################
## 5) Respondent segmentation
## Segmentation identifies groups with different preference structures. That
## helps translate one aggregate conjoint study into differentiated marketing
## actions for distinct customer types.
############################################################

segments_2 <- caSegmentation(preferences, profiles)
segments_3 <- caSegmentation(preferences, profiles, c = 3)

cat("\n--- Two-Segment Solution ---\n")
print(segments_2$seg)

cat("\n--- Three-Segment Solution ---\n")
print(segments_3$seg)

cat("\n--- Segmentation Summary ---\n")
summary(segments_3)

if (interactive()) {
    plotcluster(segments_3$util, segments_3$sclu)

    discrim_coordinates <- discrcoord(segments_3$util, segments_3$sclu)
    segment_assignments <- augment(segments_3$segm, discrim_coordinates$proj[, 1:2])

    ggplot(segment_assignments) +
        geom_point(aes(x = X1, y = X2, color = .cluster)) +
        labs(
            color = "Cluster Assignment",
            title = "K-Means Clustering Results"
        )
}

############################################################
## 6) Simulation utilities and market share modeling
## The original project included candidate hotel concepts for existing and
## proposed offers. The script first attempts the package simulation tools and
## then falls back to a manual logit calculation if the package routine is not
## conformable for the supplied simulation files.
############################################################

estimate_profile_utilities <- function(part_utilities_matrix, candidate_profiles) {
    respondent_count <- nrow(part_utilities_matrix)
    candidate_count <- nrow(candidate_profiles)
    utility_matrix <- matrix(part_utilities_matrix[, "intercept"], nrow = respondent_count, ncol = candidate_count)

    attribute_to_levels <- list(
        room = colnames(part_utilities_matrix)[2:4],
        amenity = colnames(part_utilities_matrix)[5:7],
        leisure = colnames(part_utilities_matrix)[8:10],
        extras = colnames(part_utilities_matrix)[11:14],
        delivery = colnames(part_utilities_matrix)[15:16]
    )

    for (attribute_name in names(attribute_to_levels)) {
        level_names <- attribute_to_levels[[attribute_name]]
        profile_levels <- candidate_profiles[[attribute_name]]
        for (profile_index in seq_len(candidate_count)) {
            level_index <- profile_levels[profile_index]
            utility_matrix[, profile_index] <- utility_matrix[, profile_index] +
                part_utilities_matrix[, level_names[level_index]]
        }
    }

    utility_matrix
}

estimate_logit_shares <- function(profile_utilities) {
    stable_utilities <- profile_utilities - apply(profile_utilities, 1, max)
    exp_utilities <- exp(stable_utilities)
    respondent_probabilities <- exp_utilities / rowSums(exp_utilities)
    colMeans(respondent_probabilities)
}

run_simulation_share <- function(candidate_profiles, label) {
    cat("\n---", label, "---\n")

    native_result <- tryCatch(
        {
            ShowAllSimulations(sym = candidate_profiles, y = preferences, x = profiles)
            caLogit(candidate_profiles, preferences, profiles)
        },
        error = function(e) NULL
    )

    if (!is.null(native_result)) {
        print(native_result)
    } else {
        cat("Package simulation helpers were not conformable for this candidate set; using a manual logit share estimate.\n")
    }

    candidate_utilities <- estimate_profile_utilities(part_utilities, candidate_profiles)
    share_estimate <- estimate_logit_shares(candidate_utilities)
    share_table <- data.frame(
        profile = paste0("Profile ", seq_along(share_estimate)),
        logit_share = round(share_estimate, 4)
    )
    share_table <- share_table[order(share_table$logit_share, decreasing = TRUE), ]

    print(share_table)
    invisible(share_table)
}

simulation1_shares <- run_simulation_share(simulation1, "Simulation 1 Market Share")
simulation2_shares <- run_simulation_share(simulation2, "Simulation 2 Market Share")

############################################################
## Marketing interpretation
## Compare the ranked shares to identify the strongest concept in each
## simulation set. The leading profile is the most attractive offer under the
## logit share model, while lower-ranked concepts indicate weaker positioning.
############################################################

############################################################
## 7) Conclusion
## The conjoint results support a portfolio-ready marketing recommendation:
## identify the most valuable attribute combinations, tailor offers to the key
## respondent segments, and use the simulation results to refine the hotel
## concept before launch.
############################################################