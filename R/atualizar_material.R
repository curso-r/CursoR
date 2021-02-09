#' Atualiza o material de um curso
#'
#' Esta função baixa o repositório do curso no Github e atualiza o material
#' criando ou substituindo apenas os arquivos novos. Para funcionar
#' corretamente, você precisa estar com o projeto do curso aberto.
#'
#' @examples
#' \dontrun{
#' # Com o projeto do seu curso aberto, rode:
#' atualizar_material()
#' }
#'
#' @export
atualizar_material <- function() {

  if (!existe_proj_aberto()) {
    usethis::ui_info(paste0(
      "Essa fun\u00e7\u00e3o pode n\u00e3o funcionar corretamente se voc\u00ea n\u00e3o ",
      "estiver no reposit\u00f3rio do curso. Deseja continuar?"
    ))
    res <- utils::menu(c("N\u00e3o", "Sim"))
    if (res == 1) {
      usethis::ui_stop("Abra o reposit\u00f3rio do curso antes de atualizar o material.")
    }
  }

  cursos <- c(
    "Introdução à programação com R",
    "R para Ciência de Dados 1",
    "R para Ciência de Dados 2",
    "Relatórios e visualização de dados",
    "Regressão Linear",
    "Introdução ao Machine Learning com R",
    "Dashboards com R",
    "Faxina de dados",
    "Pacotes",
    "Web Scraping em R",
    "XGBoost",
    "Deep Learning",
    "Deploy",
    "Rcpp"
  )

  curso <- select.list(cursos)

  temp <- tempfile(fileext = ".zip")

  repo <- switch(
    curso,
    `Introdução à programação com R` = "main-intro-programacao",
    `R para Ciência de Dados 1` = "main-r4ds-1",
    `Web Scraping em R` = "main-web-scraping",
    `R para Ciência de Dados 2` = "main-r4ds-2",
    `Introdução ao Machine Learning com R` = "main-intro-ml",
    `Dashboards com R` = "main-dashboards",
    `Regressão Linear` = "main-regressao-linear",
    `Deploy` = "main-deploy",
    `Rcpp` = "main-rcpp",
    `Deep Learning` = "main-deep-learning",
    `XGBoost` = "main-xgboost",
    `Relatórios e visualização de dados` = "main-visualizacao",
    `Faxina de dados` = "main-faxina",
    `Pacotes` = "main-pacotes",
    NULL
  )

  if (is.null(repo)) {
    usethis::ui_stop("O curso {usethis::ui_value(curso)} não existe.")
  }

  options(timeout = 600)

  utils::download.file(
    url = paste0(
      "https://github.com/curso-r/",
      repo,
      "/archive/master.zip"
    ),
    destfile = temp
  )

  utils::unzip(temp)

  arquivos_para_ler <- readLines(paste0(repo, "-master/material.txt"))
  arquivos <- NULL

  for (arq in arquivos_para_ler) {

    if (dir.exists(paste0(repo, "-master/", arq))) {
      lista <- list.files(
        paste0(repo, "-master/", arq),
        recursive = TRUE,
        full.names = TRUE
      )
    } else {
      lista <- arq
    }

    arquivos <- c(arquivos, lista)

  }

  usethis::ui_info("Arquivos novos:")
  usethis::ui_line("-------------------------------------------")

  i <- 0

  for (arq in arquivos) {

    dest <- gsub(".*master/", "", arq)
    wd <- getwd()

    if (!file.exists(dest)) {
      if (!dir.exists(dirname(dest))) {
        dir.create(dirname(dest), recursive = TRUE, showWarnings = FALSE)
      }
      file.copy(
        from = arq,
        to = paste(getwd(), dest, sep = "/"),
        overwrite = FALSE
      )
      usethis::ui_done(dest)
      i <- i + 1
    }

  }
  if (i == 0) {
    usethis::ui_done("Nenhum arquivo precisou ser atualizado!")
  }
  usethis::ui_line("-------------------------------------------")
  usethis::ui_done("Material atualizado!")
  unlink(paste0(repo, "-master"), recursive = TRUE)

}

existe_proj_aberto <- function() {
  wd <- getwd()
  arquivos <- list.files(wd)
  any(grepl(".Rproj", arquivos))
}

