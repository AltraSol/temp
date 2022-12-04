#' Load data from online zipped folders
#'
#' Downloads the zip folder from the provided url, unzips it to a temporary
#' location, reads the first csv into R as a tibble, then deletes the downloaded
#' zip folder and the temporary files.
#'
#' The file to read from within the folder can be altered with `file_type`,
#' `file_name`, and `file_index`. If the file to read is not a "csv", "tsv",
#' "xlsx", "xls", "pdf", or "txt" file type, a function to read the file with
#' must be specified by `reader`.
#'
#' @param url The download link to a zipped folder online.
#' @param file_type A character vector indicating a file extension.
#' @param file_name An optional string to specify which file to read by name.
#' @param file_index An optional index number to specify which of the files to read when `file_name` isn't specified.
#' @param reader A function specified by a string that is called to load the file into R.
#' @return A tibble when the file type is a csv, tsv, xlsx, or xls, and a character vector when the file type is pdf or txt.
#' @importFrom readr read_csv
#' @importFrom readxl read_excel
#' @importFrom pdftools pdf_text
#' @export
#' @examples
#' \dontrun{
#' url <- "url.zip"
#'
#' # load the first csv
#' data <- read_url_zip(url)
#'
#' # load the xlsx file "data 2020.xlsx"
#' data <- read_url_zip(url, file_type = "xlsx", file_name = "data 2020")
#'
#' # load the 2nd txt file and use the `read_csv` function instead of the default txt reader `readLines`
#' data <- read_url_zip(url, file_type = "txt", file_index = 2, reader = "read_csv")
#'
#' }
read_url_zip <- function(url, file_type = "csv", file_name = "", file_index = 1, reader = NULL) {

  if (grepl(".zip", url, fixed = TRUE) == FALSE) {
    stop('\nurl = "', url, '" does not link to a zip file', call. = FALSE)
  }

  if (grepl(".", file_name, fixed = T)) {
    file_name <- strsplit(file_name, ".", fixed = T)[[1]][1]
    file_type <- strsplit(file_name, ".", fixed = T)[[1]][2]
  }

  if (length(file_type) > 1) {
    stop("`file_type` must be specified or included in `file_name`", call. = FALSE)
  }

  if (is.null(reader) == TRUE) {
    if (file_type %in% c("csv", "tsv")) {
      reader <- "read_csv"
    } else if (file_type %in% c("xlsx", "xls")) {
      reader <- "read_excel"
    } else if (file_type %in% c("pdf")) {
      reader <- "pdf_text"
    } else if (file_type %in% c("txt")) {
      reader <- "readLines"
    }
  }

  if (is.null(reader) == TRUE) {
  recognized_types <- c("csv", "tsv", "xlsx", "xls", "pdf", "txt")
    stop(
      'the function name to read the file with must be specified ',
      'with `reader` when the file type is not one of the following types: "',
      paste0(recognized_types, collapse = '", "'),
      '"',
      call. = FALSE
    )
  }

  temp_dir <- tempdir()
  temp_file <- tempfile(tmpdir = temp_dir, fileext = ".zip")
  unzip_dir <- gsub(".zip", "", temp_file, fixed = TRUE)

  dir.create(unzip_dir)
  download.file(url, temp_file, quiet = TRUE)
  unzip(temp_file, exdir=unzip_dir, overwrite=TRUE)

  regex_file_type <- paste0(".", gsub(".", "", file_type, fixed = T), "$")
  regex_pattern <- paste0(ifelse(file_name == "", "", paste0("^", file_name)), regex_file_type)

  matching_files <- list.files(unzip_dir, pattern = regex_pattern)

  if (length(matching_files) == 0) {

    available_files <- paste0(list.files(unzip_dir), collapse = '", "')

    unlink(temp_file, recursive = TRUE)
    unlink(unzip_dir, recursive = TRUE)

    stop(
      'There are no files matching "',
      gsub("^", "", gsub("$", "", regex_pattern, fixed = T), fixed = T),
      '"\nThe files available are: "',
      available_files,
      '"',
      call. = FALSE
    )
  }

  data <- do.call(get(reader), args = list(paste0(unzip_dir, .Platform$file.sep, matching_files[file_index])))

  unlink(temp_file, recursive = TRUE)
  unlink(unzip_dir, recursive = TRUE)

  return(data)

}

