
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CursoR

Pacote com funções úteis para os cursos da Curso-R.

## Instalação

Para instalar este pacote, rode o código abaixo no Console:

``` r
# install.packages("devtools")
devtools::install_github("curso-r/CursoR")
```

## Exemplos

#### Atualizando o material de um curso

1.  Certifique-se de que você está com o projeto do curso aberto. Os
    projetos dos cursos da Curso-R têm o formato anomes-curso (ex.
    202102-r4ds1).

2.  Carregue o pacote e rode a função `atualizar_material()`

<!-- end list -->

``` r
library(CursoR)
atualizar_material()
```

3.  Digite o número correspondente ao seu curso e aperte ENTER.

4.  Os novos arquivos serão baixados diretamente para a pasta raiz do
    seu projeto. **Nenhum arquivo no seu projeto será sobrescrito.**
