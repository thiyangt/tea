library("readxl")
# xls files
tea <- read_excel("data-raw/tea_export.xlsx")
head(tea)
use_data(tea)
