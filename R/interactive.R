hook_interactive = function(x, options){
  if (!is.null(options$interactive) && (options$interactive)){
    paste0("<textarea class='interactive' id='interactive{{slide.num}}' data-cell='{{slide.num}}' data-results='", options$results, "' style='display:none'>", 
    x, "</textarea>")
  } else {
    stringr::str_c("\n\n```", tolower(options$engine), "\n", x, "```\n\n")
  }
}

runCode <- function(code, env){
  require(knitr)
  chunk = paste('```{r echo = F,message = F, comment = NA, results = "asis"}\n', 
    code, "\n```", collapse = '\n')
  out = knit(text = chunk, envir = env)
  markdown::markdownToHTML(text = out, fragment = TRUE)
}

# Function to dynamically extract cell numbers for all interactive cells
getCells <- function(){
  require(XML)
  doc = htmlParse('www/index.html')
  cells = getNodeSet(doc, '//textarea')
  as.numeric(sapply(cells, xmlGetAttr, 'data-cell'))
}

make_opencpu_version = function(){
  doc = paste(readLines('www/index.html', warn = F), collapse = '\n')
  doc = gsub('action-button', 'iBtn', doc, fixed = TRUE)
  doc = gsub('libraries/', 'www/libraries/', doc, fixed = TRUE)
  doc = gsub('./assets/', 'www/assets/', doc, fixed = TRUE)
  cat(doc, file = 'index.html')
}