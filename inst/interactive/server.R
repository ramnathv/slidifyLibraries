## @knitr server.R
require(shiny)
require(rCharts)
require(slidifyLibraries)
.slidifyEnv = new.env()

shinyServer(function(input, output){
  apps = dir(.SLIAPP$appDir, pattern = '^app', full = T)
  for (app in apps){
    source(app, local = TRUE)
  }
  renderCodeCells(input, output, env = .slidifyEnv, .SLIAPP$deckDir)
})