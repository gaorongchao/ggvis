#' Define size of plot.
#'
#' @param width,height Width and height of plot, in pixels.
#' @param auto_size Should the plot be resized according to the window size? If
#'   FALSE, the plot size will be set to \code{height} and \code{width},
#'   regardless of window size. If TRUE, the plot size will be sized to
#'   the window or to \code{width} and \code{height}, whichever is smaller.
#' @param keep_aspect If the plot is auto-sized, should the aspect ratio be
#'   preserved? (Only useful when \code{auto_size} is \code{TRUE}.)
#' @param resizable If TRUE, allow the user to resize the plot.
#' @param padding A padding object specifying padding on the top, right, left,
#'   and bottom. See \code{\link{padding}}.
#' @param duration Duration of transitions, in milliseconds.
#'
#' @examples
#' ggvis(mtcars, props(x = ~wt, y = ~mpg), mark_symbol(),
#'   opts(width = 300, height = 200, padding = padding(10, 10, 10, 10)))
#'
#' @export
opts <- function(width = NULL, height = NULL, auto_size = NULL,
                 keep_aspect = TRUE, resizable = NULL, padding = NULL,
                 duration = NULL) {
  structure(
    compact(list(
      width = width,
      height = height,
      auto_size = auto_size,
      keep_aspect = keep_aspect,
      resizable = resizable,
      padding = padding,
      duration = duration
    )),
    class = "ggvis_opts"
  )
}

#' @S3method as.vega ggvis_opts
as.vega.ggvis_opts <- function(x) x

# Default options
default_opts <- function() {
  structure(
    list(
      width = 400,
      height = 400,
      auto_size = TRUE,
      keep_aspect = TRUE,
      resizable = TRUE,
      padding = padding(),
      duration = 250
    ),
    class = "ggvis_opts"
  )
}

# Given a ggvis_opts object, merge it into default options
add_default_opts <- function(x) {
  structure(modifyList(default_opts(), x), class = "ggvis_opts")
}

#' Define padding.
#'
#' @param top,right,bottom,left Amount of padding on each border. Can either
#'   be a single number, "auto", or "strict"
#' @export
#' @examples
#' opts(padding = padding())
#' opts(padding = padding(10, 10, 10, 10))
padding <- function(top = NULL, right = NULL, bottom = NULL, left = NULL) {
  assert_that(is_padding(top), is_padding(right), is_padding(bottom),
    is_padding(left))

  structure(
    compact(list(
      top = top,
      right = right,
      bottom = bottom,
      left = left)
    ),
    class = "padding"
  )
}

#' @S3method as.vega padding
as.vega.padding <- function(x) {
  if (length(x) == 0) {
    NULL
  } else {
    unclass(x)
  }
}

is_padding <- function(x) {
  if (is.null(x)) return(TRUE)

  length(x) == 1 && (is.numeric(x) || (x %in% c("auto", "strict")))
}
on_failure(is_padding) <- function(call, env) {
  paste0(deparse2(call$x), " is not a single number, 'auto', or 'strict'.")
}