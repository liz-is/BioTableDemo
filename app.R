library(shiny)
library(BioTableModule)

pasilla_df <- read.csv("data/pasilla_condition_treated_results.csv",
                       header = TRUE)
colnames(pasilla_df) <- c("Gene ID", "Mean expression", "Log2 fold change (treated vs untreated)",
                          "Standard error of log2 fold change", "Test statistic",
                          "P-value", "Adjusted p-value")

default_columns <- c("Gene ID", "Log2 fold change (treated vs untreated)", "P-value", "Adjusted p-value")

ui <- fluidPage(
  tableUI("pasilla", all_cols = colnames(pasilla_df),
          default_cols = default_columns)
)

server <- function(input, output, session) {
 tableServer("pasilla", pasilla_df)
}

shinyApp(ui, server)
