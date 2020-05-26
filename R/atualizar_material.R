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
#' - r4ds2: R para Ciência de Dados 2
#' - webscraping: Web Scraping em R
#' - machinelearning: Introdução ao Machine Learning com R
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
    r4ds1 = "intro-programacao-em-r-mestre",
    webscraping = "web-scraping-mestre",
    r4ds2 = "r4ds2-mestre",
    machine_learning = "intro-ml-v2-mestre",
    NULL
  )

  if(is.null(repo)){
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
  arquivos <- list.files(paste0(repo, "-master/temp"), full.names = TRUE)
  usethis::ui_info("Arquivos novos:")
  usethis::ui_line("-------------------------------------------")

  for (arq in arquivos) {
    sep <- strsplit(arq,'/')
    nome_arquivo <- sep[[1]][length(sep[[1]])]
    caminho <- paste0(getwd(), '')

    sub <- TRUE
    if(file.exists(caminho)){
      sub <- usethis::ui_yeah(paste({usethis::ui_value(nome_arquivo)},"já existe. Você deseja substituí-lo?"))
    }

    if(sub){
      file.copy(
        from = arq,
        to = getwd(),
        recursive = TRUE,
        overwrite = TRUE
      )
      usethis::ui_done(arq)
    }
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
  curso <- rstudioapi::showPrompt('',
  "Digite o código do seu curso. Se você não souber digite ajuda")

  if(curso == "ajuda"){
    help(atualizar_material)
  }else{
  atualizar_material(curso)
  }
}

