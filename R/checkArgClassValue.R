checkArgClassValue <-
function(
  object, 
  expected.class = NULL, 
  expected.values = NULL, 
  expected.range = NULL, 
  case.sens = TRUE, 
  allow.na = TRUE,
  warn.only = FALSE
  ) {

  if (!allow.na && any(is.na(object))) {
    if(!warn.only) {
      stop('Found NAs in argument ', deparse(substitute(object)), ', where they are not allowed.', call. = FALSE)
    } else {
      warning('Found NAs in argument ', deparse(substitute(object)), ', where they are not allowed.', call. = FALSE)
    }
  }

  if(any(expected.class == 'character') & !case.sens) {
    object <- tolower(object)
    expected.values <- tolower(expected.values)
  }

  # call. set to FALSE so user does not see reference to unknown checkArgClassValue() function.
  if(!is.null(expected.class) && !inherits(object, expected.class))  {
    if(!warn.only) {
      stop('Expect class \"', paste(expected.class, collapse = ', '), '\" for argument ', deparse(substitute(object)), ' but got \"', paste(class(object), collapse = ', '), '\".', call. = FALSE)
    } else {
      warning('Expect class \"', paste(expected.class, collapse = ', '), '\" for argument ', deparse(substitute(object)), ' but got \"', paste(class(object), collapse = ', '), '\".', call. = FALSE)
    }
  } 

  if(!is.null(object) && !is.null(expected.values) && !all(object %in% expected.values)) {
    if(!warn.only) {
      stop('Expect one of the following values \"', paste(expected.values, collapse = ', '), '\" for argument ', deparse(substitute(object)), ' but got \"', paste(object, collapse = ', '), '\".', call. = FALSE)
    } else {
      warning('Expect one of the following values \"', paste(expected.values, collapse = ', '), '\" for argument ', deparse(substitute(object)), ' but got \"', paste(object, collapse = ', '), '\".', call. = FALSE)
    }
  }

  if(!is.null(object) && !is.null(expected.range) && any(na.omit(object)  < min(expected.range) | na.omit(object) > max(expected.range))) {
    if(!warn.only) {
      stop('Expect values within the range \"', paste(expected.range, collapse = ', '), '\" for argument ', deparse(substitute(object)), ' but got \"', paste(range(object), collapse = ', '), '\".', call. = FALSE)
    } else {
      warning('Expect values within the range \"', paste(expected.range, collapse = ', '), '\" for argument ', deparse(substitute(object)), ' but got \"', paste(range(object), collapse = ', '), '\".', call. = FALSE)
    }
  }

  return(invisible(TRUE)) # May be useful
}
