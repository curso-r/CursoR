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
#' @export
#'
#' @examples
#' # Com o projeto do curso R para Ciência de Dados 1 aberto, rode:
#'
#' atualizar_matarial("r4ds1")
atualizar_material <- function(curso) {

  if (!existe_proj_aberto()) {
    message(paste0(
      "Essa função pode não funcionar corretamente se você não ",
      "estiver no repositório do curso. Deseja continuar?"
      ))
    res <- utils::menu(c("Não", "Sim"))
    if (res == 1) {
      stop("Abra o repositório do curso antes de atualizar o material.")
    }
  }

  temp <- tempfile(fileext = ".zip")

  repo <- switch(
    curso,
    r4ds1 = "intro-programacao-em-r-mestre"
  )

  download.file(
    url = paste0(
      "https://github.com/curso-r/",
      repo,
      "/archive/master.zip"
    ),
    destfile = temp
  )

  unzip(temp)


  arquivos <- list.files(paste0(repo, "-master/temp/"), full.names = TRUE)

  for (arq in arquivos) {
    file.copy(
      from = arq,
      to = getwd(),
      recursive = TRUE
    )
  }

  unlink(paste0(repo, "-master"), recursive = TRUE)

}

existe_proj_aberto <- function() {
  wd <- getwd()
  arquivos <- list.files(wd)
  any(grepl(".Rproj", arquivos))
}
