library(shiny)
library(BioTableModule)

pasilla_counts <- read.csv("data/pasilla_counts.csv", header = TRUE)
colnames(pasilla_counts)[1] <- "Gene ID"
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

gene_ids <- pasilla_df[["Gene ID"]]

ui <- fluidPage(tabsetPanel(
  tabPanel(
    "Home",
    tableUI(id = "pasilla_results"),
    selectizeInput(
      inputId = "gene_id",
      label = "Filter by gene",
      choices = NULL,
      selected = NULL,
      multiple = TRUE
    )
  ),
  tabPanel("Raw counts", tableUI(id = "pasilla_counts"))
))

server <- function(input, output, session) {
  shinyhelper::observe_helpers()

  updateSelectizeInput(
    session,
    "gene_id",
    choices = gene_ids,
    server = TRUE,
    selected = NULL
  )

  tableServer(
    "pasilla_results",
    pasilla_df,
    default_cols = default_columns,
    sci_format_cols = setdiff(colnames(pasilla_df), "Gene ID"),
    row_id = reactive(input$gene_id),
    id_column_name = "Gene ID"
  )

  tableServer(
    "pasilla_counts",
    pasilla_counts,
    sci_format_cols = "treated",
    row_id = reactive(input$gene_id),
    id_column_name = "Gene ID"
  )
}

shinyApp(ui, server)
