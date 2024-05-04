library(here)
library(fs)
library(tidyverse)
source(here("R/functions.R"))

# Download
# mmash_link <- "https://physionet.org/static/published-projects/mmash/multilevel-monitoring-of-activity-and-sleep-in-healthy-people-1.0.0.zip"
mmash_link <- r3::mmash_data_link
# download.file(mmash_link, destfile = here("data-raw/mmash-data.zip"))

# Unzip
unzip(
  here("data-raw/mmash-data.zip"),
  exdir = here("data-raw"),
  junkpaths = TRUE # extract everything in the folder
)
Sys.sleep(1)
unzip(here("data-raw/MMASH.zip"), exdir = here("data-raw"))

# Remove/tidy up left over files
file_delete(here(c(
  "data-raw/MMASH.zip",
  "data-raw/SHA256SUMS.txt",
  "data-raw/LICENSE.txt"
)))
file_move(here("data-raw/DataPaper"), here("data-raw/mmash"))

# load data for all users
user_info_df <- import_multiple_files("user_info.csv", import_user_info)
saliva_df <- import_multiple_files("saliva.csv", import_saliva)
rr_df <- import_multiple_files("RR.csv", import_rr)
actigraph_df <- import_multiple_files("Actigraph.csv", import_actigraph)

# summarise rr
summarised_rr_df <- rr_df |>
    group_by(file_path_id, day) |>
    summarise(across(ibi_s, list(
        mean = \(x) mean(x, na.rm = TRUE),
        sd = \(x) sd(x, na.rm = TRUE)
    ))) |>
    ungroup()

# summarise actigraph
summarised_actigraph_df <- actigraph_df |>
    group_by(file_path_id, day) |>
    summarise(across(c(hr, steps), list(
        mean = \(x) mean(x, na.rm = TRUE),
        sd = \(x) sd(x, na.rm = TRUE),
        max = \(x) max(x, na.rm = TRUE)
    ))) |>
    ungroup()
# Code pasted here that was made from the above exercise
