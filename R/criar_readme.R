#' Cria arquivo README para cursos da Curso-R
#'
#' Cria o arquivo README responsável pelo ghpage de cada turma dos cursos
#' da Curso-R. Essa função é de uso interno da Curso-R.
#'
#' @return
#' @export
#'
#' @examples
criar_readme <- function() {

  cursos <- c(
    "Introdução ao Machine Learning",
    "R para Ciência de Dados 1",
    "R para Ciência de Dados 2",
    "Dashboards",
    "Web Scraping"
  )

  curso <- select.list(cursos)

  repo <- switch(
    curso,
    `R para Ciência de Dados 1` = "intro-programacao-em-r-mestre",
    `Web Scraping em R` = "web-scraping-mestre",
    `R para Ciência de Dados 2` = "main-r4ds2",
    `Introdução ao Machine Learning com R` = "intro-ml-v2-mestre",
    `Dashboards com R` = "main-dashboards",
    NULL
  )

  turma <- rstudioapi::getActiveProject() %>% basename()

  arquivo <- system.file(
    "template_readme.Rmd",
    package = "CursoR"
  )

  arq_dest <- "README.Rmd"

  file.copy(arquivo, arq_dest)

  texto <- readLines(arq_dest)
  texto <- gsub("_main_repo_", repo, texto)
  texto <- gsub("_repo_turma_", turma, texto)
  texto <- gsub("_nome_curso_", curso, texto)
  writeLines(texto, arq_dest, sep = "\n")

  rstudioapi::navigateToFile(arq_dest)

}
