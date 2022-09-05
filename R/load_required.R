#' Load or install required packages
#'
#' @export
load_required <- function() {
  required_packs <- c("tidyr", "purrr", "stringr", "dplyr")
  if (!require("librarian")) install.packages("librarian")
  librarian::shelf(required_packs)
}

