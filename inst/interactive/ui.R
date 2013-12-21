require(shiny)
require(slidify)
require(slidifyLibraries)
addResourcePath('libraries', file.path(.SLIAPP$deckDir, "libraries"))
shinyUI(
  includeDeck(file.path(.SLIAPP$deckDir, 'index.Rmd'))  
)