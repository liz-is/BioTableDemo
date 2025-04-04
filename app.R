library(shiny)
library(BioTableModule)

pasilla_counts <- read.csv("data/pasilla_counts.csv", header = TRUE)
pasilla_df <- read.csv("data/pasilla_condition_treated_results.csv", header = TRUE)
colnames(pasilla_df) <- c(
  "Gene ID",
  "Mean expression",
  "Log2 fold change (treated vs untreated)",
  "Standard error of log2 fold change",
  "Test statistic",
  "P-value",
  "Adjusted p-value"
)

default_columns <- c("Gene ID",
                     "Log2 fold change (treated vs untreated)",
                     "P-value",
                     "Adjusted p-value")

ui <- fluidPage(
  tableUI(id = "pasilla_results"),
  tableUI(id = "pasilla_counts")
  )

server <- function(input, output, session) {
  shinyhelper::observe_helpers()

  tableServer(
    "pasilla_results",
    pasilla_df,
    default_cols = default_columns,
    sci_format_cols = setdiff(colnames(pasilla_df), "Gene ID")
  )

  tableServer(
    "pasilla_counts",
    pasilla_counts,
    sci_format_cols = "treated")
}

shinyApp(ui, server)
