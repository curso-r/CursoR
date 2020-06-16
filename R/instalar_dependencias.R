#' Atualiza o material de um curso
#'
#' Esta função instala todos os pacotes utilizados em um determinado curso.
#'
#' @examples
#' \dontrun{
#' instalar_dependencias()
#' }
#'
#' @export
instalar_dependencias <- function() {

  cursos <- c(
    "Dashboards com R",
    "Introdução ao Machine Learning com R"
  )

  curso <- select.list(cursos)

  pacotes <- switch(
    curso,
    `Dashboards com R` = c(
      "tidyverse",
      "shiny", "shinydashboard", "reactlog",
      "rmarkdown", "knitr", "flexdashboard"
    ),
    `Introdução ao Machine Learning com R` = c(
      "tidyverse", "tidymodels", "rmarkdown", "knitr",
      "ISLR", "glmnet", "xgboost", "randomForest",
      "ranger", "rpart", "rpart.plot", "pROC", "vip", "modeldata",
      "usemodels", "tidypredict"
    ),
    NULL
  )

  usethis::ui_todo("Os seguintes pacotes serão instalados:")
  for (pkg in pacotes) {
    usethis::ui_info(pkg)
  }

  cat("\n")

  res <- usethis::ui_yeah(
    "Deseja continuar:",
    yes = c("Sim", "Com certeza"),
    no = c("Não", "De maneira nenhuma", "Na-na-ni-na-não")
  )

  if (res) {
    install.packages(pacotes)
    usethis::ui_done("Processo finalizado. Verifique se os pacotes foram instalados com sucesso.")
  } else {
    usethis::ui_oops("Processo de instalação cancelado.")
  }

}
