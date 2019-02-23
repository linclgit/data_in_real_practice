library(httr)
library (tidyverse)
library(rvest)

url = "https://www.twbiobank.org.tw/new_web/contact.php"
res = GET (url) # use GET method to get the web response
res

# A quick view of the web response
str (res)
names (res)
res$all_headers
res$request
res$request$headers
res$cookies
res$content

# Info we want is usually in "content"
content(res, as = "raw") # binary codes
content(res, as = "text") # default encoding method is utf-8 

# (1) Scrape the site addresses
address <- res %>% 
  content (as = "text") %>% 
  read_html %>% 
  html_nodes (xpath = "//div[@class='panel address']") %>% 
  html_text %>% # turn the content into text
  as.data.frame # turn into data.frame

class (address)
str(address)
head (address) # View the site name and address info

# Some data cleaning
address_df <- address %>% 
  separate (".", into = c ("city", "address"), sep = 2) %>% 
  slice (2:n()) %>% 
  separate ("address", into = c ("site", "address"), sep = "站")
head (address_df)
dim (address_df)

# (2) Scrape the coordinate info
geo <- res %>% 
  content (as = "text") %>% 
  read_html %>% 
  html_nodes (xpath = "//li[@data-geo-lat]") %>% 
  html_attrs 

str (geo)

# Some data cleaning
geo_df <- t (as.data.frame (geo, col.names = paste0("X", c(1:34)))) 
row.names (geo_df) <- NULL

# (3) Combine the 2 tables
stations <- cbind (address_df, geo_df)
