.KoSpacingEnv <- new.env()


#' @importFrom reticulate import
.onLoad <- function(libname, pkgname) {
  Sys.setenv(TF_CPP_MIN_LOG_LEVEL = 2)
  if (!check_conda_set()) set_env()
  reticulate::use_condaenv("r-kospacing", required = TRUE)
}

.onAttach <- function(libname, pkgname){
  packageStartupMessage("If you install package first fime, ")
  packageStartupMessage("Please set_env() run before using spacing()")
}
