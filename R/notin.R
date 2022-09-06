#' Negate value matching
#'
#' An intuitive counterpart to `%in%` using `Negate()` to return a logical
#' vector indicating if the left operand is \emph{not in} the right operand.
#' @param x Vector or NULL: the values to be matched.
#' @param y Vector or NULL: the values to be matched against.
#' @return A vector of the same length as x.
#' @export
#' @seealso [base::match()] [base::Negate()]
#' @examples
#' 1:10 %notin% c(1,3,5,9)
`%notin%` <- function(x, y) base::Negate(base::match(x, y, nomatch = 0) > 0)
