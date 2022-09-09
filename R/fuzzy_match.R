#' Fuzzy match two character vectors
#'
#' Substitutes all elements of `swap_out` with one from `swap_in`. All
#' perfect matches are immediately substituted, with the order of proceeding
#' matches determined by choosing the next element found to minimize the total
#' string distance computed by comparing the remainder of `swap_out` and `swap_in`.
#'
#' When two or more elements of `swap_out` have equivalent total string distances,
#' the first element will proceed. A comparison of this element and
#' the remainder of `swap_in` is then made to assign the final match.
#'
#' @param swap_out A character vector.
#' @param swap_in A character vector >= `length(swap_out)`.
#'
#' @details Implements the running cosine matching algorithm from [stringdist::afind()]
#' with `q = min(nchar(swap_out))` to choose the next element to match, and
#' `q = min(nchar(swap_in))` to choose the best match in `swap_in`. After each
#' match is made, the match is removed from swap_out and swap_in (often resulting in
#' `q` also changing for the next comparison).
#'
#' @return A character list equal in length to `swap_out`.
#'
#' @importFrom stringdist afind
#' @importFrom stringi stri_replace_rstr
#' @export
#' @examples
#' messy_words <- c(
#'   "ID #",               # ID
#'   "Barcode",            # Code
#'   "Product\nName",      # Name
#'   "Day of \n the week", # Day
#'   "Month (MMM) ",       # Month
#'   "Amount $"            # Amount
#' )
#'
#' clean_words <- c(
#'   "Amount",
#'   "Month ",
#'   "Day",
#'   "Name",
#'   "Code",
#'   "ID"
#' )
#'
#' swapped_words <- fuzzy_match(swap_out = messy_words,
#'                              swap_in = clean_words)
#' swapped_words # order preserved, best matches substituted
#'
#'
#' # swap_out must be <= in length as swap_in
#' color_phrases <- c("The sunrise was yellow",
#'                    "There were purple flowers",
#'                    "The water was blue")
#'
#' # swap_in can be any length >= swap_out
#' colors_list <- c("Red",
#'                  "Blue",
#'                  "Green",
#'                  "Yellow",
#'                  "Violet",
#'                  "Purple",
#'                  "Orange")
#'
#' colors_mentioned <- fuzzy_match(color_phrases, colors_list)
#' writeLines(paste0("The colors mentioned were: ",
#'                   paste0(colors_mentioned, collapse = ", ")))
fuzzy_match <- function(swap_out, swap_in) {
  if (length(swap_out) > length(swap_in)) {
    warning("Length of swap_out cannot be greater than swap_in")
  }
  dissimilar_matches <- list()
  origin_list <- swap_out
  new_list <- rep(NA, length(origin_list))

  index_perf_out <- which(swap_out %in% swap_in)
  index_perf_in <- which(swap_in %in% swap_out)
  if (length(index_perf_out) != 0) {
    new_list[index_perf_out] <- swap_out[index_perf_out]
    writeLines("> Perfect Matches")
    for (item in new_list[!is.na(new_list)]) {
      message(paste0("`", item, "`"))
    }
    swap_out <- swap_out[-index_perf_out]
    swap_in <- swap_in[-index_perf_in]
  }
  writeLines("> Fuzzy Matches")
  while (length(swap_out) != 0) {
    out_mat <-
      afind(swap_out,
            swap_in,
            method = "running_cosine",
            q = min(nchar(swap_out))
      )
    swap_out_index <-
      which(rowSums(out_mat$distance) == min(rowSums(out_mat$distance)))[1]
    in_mat <-
      afind(swap_in,
            swap_out[swap_out_index],
            method = "running_cosine",
            q = min(nchar(swap_in))
      )
    swap_in_index <-
      which(in_mat$distance == min(in_mat$distance))[1]
    if (min(in_mat$distance)[1] > 0.9) {
      dissimilar_matches <- append(
        dissimilar_matches,
        paste0(
          "`", swap_out[swap_out_index],
          "` may have a dissimilar fuzzy match"
        )
      )
    }
    loc_push_new <-
      grep(
        stringi::stri_replace_rstr(swap_out[swap_out_index]),
        origin_list
      )
    if (length(loc_push_new) == 0) {
      loc_push_new <-
        grep(
          stringi::stri_replace_rstr(swap_out[swap_out_index]),
          origin_list,
          fixed = TRUE
        )
    }
    new_list[loc_push_new] <- swap_in[swap_in_index]
    message(gsub(
      "\\\n", "\\\\n",
      paste0(
        "`", swap_out[swap_out_index], "` -> `", swap_in[swap_in_index], "`"
      )
    ))

    swap_out <- swap_out[-swap_out_index]
    swap_in <- swap_in[-swap_in_index]
  }
  if (length(dissimilar_matches) != 0) {
    writeLines("> Incompatible?")
    message(
      paste0(gsub(
        "\\\n", "\\\\n", unlist(dissimilar_matches)
      ),
      collapse = "\n"
      )
    )
  }
  return(new_list)
}
