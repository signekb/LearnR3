#' Import MMASH user info data file.
#'
#' @param file_path Path to user info data file.
#'
#' @return Outputs a data frame/tibble.
#'
import_user_info <- function(file_path) {
  info_data <- readr::read_csv(
    file_path,
    col_select = -1,
    col_types = readr::cols(
      gender = readr::col_character(),
      weight = readr::col_double(),
      height = readr::col_double(),
      age = readr::col_double(),
      .delim = ","
    ),
    name_repair = snakecase::to_snake_case
  )
  return(info_data)
}

# user 1
import_user_info(here("data-raw/mmash/user_1/user_info.csv"))

# user 2
import_user_info(here("data-raw/mmash/user_2/user_info.csv"))
