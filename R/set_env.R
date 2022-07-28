#' @importFrom reticulate import import_builtins py_module_available use_condaenv conda_create conda_install conda_list
install_conda_packages <- function() {
  envnm <- 'r-kospacing'

  reticulate::use_condaenv(envnm, required = TRUE)

  if (!reticulate::py_module_available("h5py")) {
    reticulate::conda_install(envnm, packages = c('h5py==2.10.0'))
  }

  if (!reticulate::py_module_available("tensorflow")) {
    reticulate::conda_install(envnm, packages = c('tensorflow==1.9.0'))
  }

  if (!reticulate::py_module_available("keras")) {
    reticulate::conda_install(envnm, packages = c('keras==2.1.5'))
  }

  cat("\nInstallation complete.\n\n")
  invisible(NULL)
}

check_env <- function() {
  reticulate::py_module_available("h5py") &
    reticulate::py_module_available("keras") &
    reticulate::py_module_available("tensorflow")
}

check_model <- function() {
  chk <- try(get("model", envir = .KoSpacingEnv), silent = T)
  return(!inherits(chk, "try-error"))
}

#' @importFrom reticulate import
set_model <- function() {
  w2idx <-
    file.path(system.file(package = "KoSpacing"), "model", 'w2idx')

  w2idx_tbl <- readRDS(w2idx)

  Hash <- sapply(unique(w2idx_tbl$Keys), function(x) {
    w2idx_tbl[w2idx_tbl$Keys == x, 2]
  }, simplify = FALSE)

  assign("Hash", Hash, envir = .KoSpacingEnv)

  model_file <-
    file.path(system.file(package = "KoSpacing"), "model", 'kospacing')

  # model <- keras::load_model_hdf5(model_file, compile = FALSE)
  keras <- reticulate::import("keras")
  model <- keras$models$load_model(model_file, compile = FALSE)
  assign("model", model, envir = .KoSpacingEnv)

  packageStartupMessage("loaded KoSpacing model!")
}

check_conda_set <- function() {
  envnm <- 'r-kospacing'
  chk <-
    try(reticulate::use_condaenv(envnm, required = TRUE), silent = T)
  return(!inherits(chk, "try-error"))
}

#' @importFrom reticulate conda_create
set_env <- function() {
  reticulate::conda_create("r-kospacing",
                           # python_version = "3.6",
                           packages = c("python=3.6", "numpy=1.16.5"),)
  install_conda_packages()
}
