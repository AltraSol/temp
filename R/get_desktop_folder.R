#' Get desktop folder
#'
#' Return the path to the desktop directory regardless of operating system.
#'
#' @return A character file path.
#'
#' @importFrom stringr str_locate_all
#' @importFrom stringr str_trunc
#' @export
#' @examples
#' get_desktop_folder()
get_desktop_folder <- function() {
  last_file.sep <-
    tail(unlist(str_locate_all(
      file.path(path.expand("~")),
      .Platform$file.sep
    )), 1)
  local_desktop <-
    paste0(
      str_trunc(
        file.path(path.expand("~")),
        width = last_file.sep,
        ellipsis = ""
      ), "Desktop"
    )
  return(local_desktop)
}
