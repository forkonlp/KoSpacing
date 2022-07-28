.KoSpacingEnv <- new.env()


#' @importFrom reticulate import
.onLoad <- function(libname, pkgname) {
  Sys.setenv(TF_CPP_MIN_LOG_LEVEL = 2)
  if (!check_conda_set()) set_env()
  reticulate::use_condaenv("r-kospacing", required = TRUE)
}

