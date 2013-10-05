hook_interactive = function(x, options){
  if (!is.null(options$interactive) && (options$interactive)){
    paste0("<textarea class='interactive' id='interactive{{slide.num}}' data-cell='{{slide.num}}' data-results='", options$results, "' style='display:none'>", 
     paste(x, collapse = '\n'), "</textarea>")
  } else {
    stringr::str_c("\n\n```", tolower(options$engine), "\n", 
      paste(x, collapse = "\n"), "\n```\n\n")
  }
}

runCode <- function(code, env, deckDir){
  require(knitr)
  chunk = paste('```{r echo = F,message = F, comment = NA, results = "asis"}\n', 
    code, "\n```", collapse = '\n')
  # opts_chunk$set(fig.path = file.path(deckDir, 'assets', 'fig/'), dev = 'png')
  out = knit(text = chunk, envir = env)
  markdown::markdownToHTML(text = out, fragment = TRUE)
}

# Function to dynamically extract cell numbers for all interactive cells
getCells <- function(indexFile = 'www/index.html'){
  require(XML)
  doc = htmlParse(indexFile)
  cells = getNodeSet(doc, '//textarea[@class="interactive"]')
  as.numeric(sapply(cells, xmlGetAttr, 'data-cell'))
}

make_opencpu_version = function(){
  doc = paste(readLines('www/index.html', warn = F), collapse = '\n')
  doc = gsub('action-button', 'iBtn', doc, fixed = TRUE)
  doc = gsub('libraries/', 'www/libraries/', doc, fixed = TRUE)
  doc = gsub('./assets/', 'www/assets/', doc, fixed = TRUE)
  cat(doc, file = 'index.html')
}


make_interactive <- function(){
  knitr::knit_hooks$set(source = hook_interactive)
  knitr::opts_template$set(
    interactive = list(tidy = FALSE, echo = TRUE, eval = FALSE, interactive = TRUE),
    shiny = list(tidy = FALSE, echo = FALSE, eval = TRUE, results = 'asis', comment = NA)
  )
}

renderCodeCells <- function(input, output, env = .slidifyEnv, deckDir){
  cells = getCells(file.path(deckDir, 'index.html'))
  invisible(lapply(cells, function(i){
    output[[paste0('knitResult', i)]] <- shiny::reactive({
      if (input[[paste0('runCode', i)]] != 0)
        return(isolate({
          print('running code')
          runCode(input[[paste0('interactive', i)]], env, deckDir)
        }))
    })
    outputOptions(output, paste0('knitResult', i), suspendWhenHidden = F)
  }))
}

slidifyUI<- function(...){
  require(shiny)
  cat(as.character(div(class = 'row-fluid', ...)))
}