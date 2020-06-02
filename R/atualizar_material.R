#' Atualiza o material de um curso
#'
#' Esta função baixa o repositório do curso no Github e atualiza o material
#' criando ou substituindo apenas os arquivos novos. Para funcionar
#' corretamente, você precisa estar com o projeto do curso aberto.
#'
#' @details Confira o código do seu curso:
#'
#' - Introdução ao Machine Learning com R: machinelearning
#' - R para Ciência de Dados 1: r4ds1
#' - R para Ciência de Dados 2: r4ds2
#' - Web Scraping em R: webscraping
#'
#' @examples
#' \dontrun{
#'
#' # Com o projeto do seu curso aberto, rode:
#' atualizar_material("codigo-do-curso")
#'
#' # Os códigos estão listados na seção Details acima.
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

  curso <- rstudioapi::showPrompt(
    '',
    "Digite o código do seu curso.\nSe você não souber o código, digite 'ajuda'."
  )

  if (curso %in% c("ajuda", "'ajuda'")) {
    usethis::ui_info("Verifique o código do seu curso na seção Details.")
    return(help(atualizar_material))
  }

  temp <- tempfile(fileext = ".zip")

  repo <- switch(
    curso,
    r4ds1 = "intro-programacao-em-r-mestre",
    webscraping = "web-scraping-mestre",
    r4ds2 = "r4ds2-mestre",
    machine_learning = "intro-ml-v2-mestre",
    NULL
  )

  if (is.null(repo)) {
    usethis::ui_stop("O curso {usethis::ui_value(curso)} não existe.")
  }

  utils::download.file(
    url = paste0(
      "https://github.com/curso-r/",
      repo,
      "/archive/master.zip"
    ),
    destfile = temp
  )

  utils::unzip(temp)
  arquivos <- list.files(
    paste0(repo, "-master/temp"),
    recursive = TRUE,
    full.names = TRUE
  )

  usethis::ui_info("Arquivos novos:")
  usethis::ui_line("-------------------------------------------")

  for (arq in arquivos) {

    dest <- gsub(".*temp/", "", arq)
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
    }

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

