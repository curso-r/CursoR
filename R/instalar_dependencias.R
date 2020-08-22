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
    "R para Ciência de Dados I",
    "R para Ciência de Dados II",
    "Regressão Linear",
    "Introdução ao Machine Learning com R",
    "Dashboards com R"
  )

  curso <- select.list(cursos)

  pacotes <- switch(
    curso,
    `R para Ciência de Dados I` = list(cran = c(
      "tidyverse", "rmarkdown", "knitr","skimr",
      "readxl", "writexl", "openxlsx", "haven",
      "DBI", "RSQLite", "jsonlite"
    ),
    github = c()
    ),
    `R para Ciência de Dados II` = list(cran = c(
      "tidyverse", "rmarkdown", "knitr", "janitor",
      "readxl", "writexl", "shiny"
    ),
    github = c()
    ),
    `Dashboards com R` = list(cran = c(
      "tidyverse",
      "shiny", "shinydashboard", "reactlog",
      "rmarkdown", "knitr", "flexdashboard"
    ),
    github = c()
    ),
    `Introdução ao Machine Learning com R` = list(cran = c(
      "tidyverse", "tidymodels", "rmarkdown", "knitr",
      "ISLR", "glmnet", "xgboost", "randomForest",
      "ranger", "rpart", "rpart.plot", "pROC", "vip", "modeldata",
      "usemodels", "tidypredict", "jpeg", "MASS", "DataExplorer",
      "skimr", "naniar", "patchwork"
    ),
    github = c("RobertMyles/modelscript", "allisonhorst/palmerpenguins")
    ),
    `Regressão Linear` = list(cran = c(
      "tidyverse", "tidymodels", "rmarkdown", "knitr",
      "ISLR", "glmnet", "janitor", "broom", "vip",
      "tidypredict", "MASS",
      "skimr", "naniar", "readxl", "lime", "GGally", "car"
    ),
    github = c("allisonhorst/palmerpenguins")
    ),
    NULL
  )

  usethis::ui_todo("Os seguintes pacotes serão instalados:")
  for (pkg in pacotes$cran) {
    usethis::ui_info(pkg)
  }
  for (pkg in pacotes$github) {
    usethis::ui_info(pkg)
  }

  cat("\n")

  res <- usethis::ui_yeah(
    "Atenção: Isso pode demorar de 5 a 15 minutos. Deseja continuar?",
    yes = c("Sim", "Com certeza"),
    no = c("Não", "De maneira nenhuma", "Negativo")
  )

  if (res) {
    for(pkg in pacotes$cran) {
      if(!pkg %in% loadedNamespaces()) install.packages(pkg)
    }
    if(!is.null(pacotes$github)) {
      if(!requireNamespace("remotes", quietly = TRUE)) {
        install.packages("remotes")
      }
      for (pkg in pacotes$github) {
        remotes::install_github(pkg, force = TRUE)
      }
    }
    usethis::ui_done("Processo finalizado. Verifique se os pacotes foram instalados com sucesso.")
  } else {
    usethis::ui_oops("Processo de instalação cancelado.")
  }

}
