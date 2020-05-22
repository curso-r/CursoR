#' Atualiza o material de um curso
#'
#' Esta função baixa o repositório do curso no Github e atualiza o material
#' criando ou substituindo apenas os arquivos novos. Para funcionar
#' corretamente, você precisa estar com o projeto do curso aberto.
#'
#' @param curso Uma string indicando o curso que você está fazendo. Veja
#' as opções abaixo.
#'
#' @details As opções do argumento curso são:
#'
#' - r4ds1: R para Ciência de Dados 1
#'
#'
#' @examples
#' \dontrun{
#' # Com o projeto do curso R para Ciência de Dados 1 aberto, rode:
#' atualizar_material("r4ds1")
#' }
#'
#' @export
atualizar_material <- function(curso) {

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

  temp <- tempfile(fileext = ".zip")

  repo <- switch(
    curso,
    r4ds1 = "intro-programacao-em-r-mestre"
  )

  utils::download.file(
    url = paste0(
      "https://github.com/curso-r/",
      repo,
      "/archive/master.zip"
    ),
    destfile = temp
  )

  utils::unzip(temp)
  arquivos <- list.files(paste0(repo, "-master/temp"), full.names = TRUE)
  usethis::ui_info("Arquivos novos:")
  usethis::ui_line("-------------------------------------------")
  for (arq in arquivos) {
    file.copy(
      from = arq,
      to = getwd(),
      recursive = TRUE
    )
    usethis::ui_done(arq)
  }
  usethis::ui_line("-------------------------------------------")
  usethis::ui_done("Tudo pronto!")
  unlink(paste0(repo, "-master"), recursive = TRUE)

}

existe_proj_aberto <- function() {
  wd <- getwd()
  arquivos <- list.files(wd)
  any(grepl(".Rproj", arquivos))
}

#' @rdname atualizar_material
#'
#' @export
atualizar_material_r4ds1 <- function() {
  atualizar_material("r4ds1")
}

