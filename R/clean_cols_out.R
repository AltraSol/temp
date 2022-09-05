clean_cols_out <- function(column_names, case = c("upper", "lower", "proper")) {
  column_names <- gsub("_", " ", column_names)
  column_names <- gsub("[.]", "/\\", column_names)
  if (missing(case)) {
  } else if (tolower(case) == "upper") {
    column_names <- toupper(column_names)
  } else if (tolower(case) == "lower") {
    column_names <- tolower(column_names)
  } else if (tolower(case) == "proper") {
    column_names <- gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(column_names), perl=TRUE)
  }
  return(column_names)
}
