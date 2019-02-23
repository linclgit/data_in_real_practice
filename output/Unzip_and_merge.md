2018/1/23

> -   unzip a folder containing a list of split data files
> -   read and merge individual files into one single data frame
> -   some exploratory analysis and visualizations

data used: [Baby Names from Social Security Card Applications](https://catalog.data.gov/dataset/baby-names-from-social-security-card-applications-data-by-state-and-district-of-)

code reference: [HERE](https://stat.ethz.ch/pipermail/r-help/2010-October/255593.html) [HERE](https://stackoverflow.com/a/35236167)

------------------------------------------------------------------------

``` r
library (tidyverse); library (knitr); library (kableExtra) # Load the packages
```

### Start from downloading the zipped file

``` r
url <- "https://www.ssa.gov/oact/babynames/state/namesbystate.zip"
download.file(url, destfile = "../data/namesbystate.zip")
```

### Take a look at the folder containing the zip file

``` r
list.files ("../data")
## [1] "lipid_1.csv"      "lipid_2.csv"      "lipid.xlsx"      
## [4] "namesbystate"     "namesbystate.zip"
```

### Extract files from a zip archive and place them in a new folder

``` r
path <- "../data/namesbystate/" 
unzip (zipfile = "../data/namesbystate.zip", # file to unzip
       exdir = path) # folder to deposit the files
```

### Now take a look at the folders

``` r
list.files ("../data")
## [1] "lipid_1.csv"      "lipid_2.csv"      "lipid.xlsx"      
## [4] "namesbystate"     "namesbystate.zip"
list.files (path) # the one we just created
##  [1] "AK.TXT"          "AL.TXT"          "AR.TXT"         
##  [4] "AZ.TXT"          "CA.TXT"          "CO.TXT"         
##  [7] "CT.TXT"          "DC.TXT"          "DE.TXT"         
## [10] "FL.TXT"          "GA.TXT"          "HI.TXT"         
## [13] "IA.TXT"          "ID.TXT"          "IL.TXT"         
## [16] "IN.TXT"          "KS.TXT"          "KY.TXT"         
## [19] "LA.TXT"          "MA.TXT"          "MD.TXT"         
## [22] "ME.TXT"          "MI.TXT"          "MN.TXT"         
## [25] "MO.TXT"          "MS.TXT"          "MT.TXT"         
## [28] "NC.TXT"          "ND.TXT"          "NE.TXT"         
## [31] "NH.TXT"          "NJ.TXT"          "NM.TXT"         
## [34] "NV.TXT"          "NY.TXT"          "OH.TXT"         
## [37] "OK.TXT"          "OR.TXT"          "PA.TXT"         
## [40] "RI.TXT"          "SC.TXT"          "SD.TXT"         
## [43] "StateReadMe.pdf" "TN.TXT"          "TX.TXT"         
## [46] "UT.TXT"          "VA.TXT"          "VT.TXT"         
## [49] "WA.TXT"          "WI.TXT"          "WV.TXT"         
## [52] "WY.TXT"
```

Note that the files are separated by states, and there is one pdf file in the folder, which we don't want

### Files are ready. Prepare to read the files.

``` r
files <- paste0 (path, list.files (path)) # produce a path for each file
files <- files [grep ("*TXT", files)] # Keep only the text files we want
head (read.table (files [1], sep = ",")) # without header
##   V1 V2   V3       V4 V5
## 1 AK  F 1910     Mary 14
## 2 AK  F 1910    Annie 12
## 3 AK  F 1910     Anna 10
## 4 AK  F 1910 Margaret  8
## 5 AK  F 1910    Helen  7
## 6 AK  F 1910    Elsie  6
```

### Read through the file list and merge into one single data frame

``` r
df <- do.call ("rbind", 
               lapply (files, read.table, sep = ",")) %>% 
  # rbindlist (lapply (files, read.table, sep = ",")) 
  # works as well
  as_tibble %>% # turn the table into tibble
  print
## # A tibble: 5,933,561 x 5
##    V1    V2       V3 V4          V5
##    <fct> <fct> <int> <fct>    <int>
##  1 AK    F      1910 Mary        14
##  2 AK    F      1910 Annie       12
##  3 AK    F      1910 Anna        10
##  4 AK    F      1910 Margaret     8
##  5 AK    F      1910 Helen        7
##  6 AK    F      1910 Elsie        6
##  7 AK    F      1910 Lucy         6
##  8 AK    F      1910 Dorothy      5
##  9 AK    F      1911 Mary        12
## 10 AK    F      1911 Margaret     7
## # … with 5,933,551 more rows

table (df$V1) # check if all states are in
## 
##     AK     AL     AR     AZ     CA     CO     CT     DC     DE     FL 
##  28084 132065 100157 113111 374634 105269  80344  55110  31838 200695 
##     GA     HI     IA     ID     IL     IN     KS     KY     LA     MA 
## 178426  53896  92186  56842 224806 136291  92470 116222 146057 116243 
##     MD     ME     MI     MN     MO     MS     MT     NC     ND     NE 
## 108767  49783 179166 111659 135684 112270  45126 169591  45522  70667 
##     NH     NJ     NM     NV     NY     OH     OK     OR     PA     RI 
##  38499 149611  74370  45974 291657 191521 114882  86692 194753  39712 
##     SC     SD     TN     TX     UT     VA     VT     WA     WI     WV 
## 115787  46671 137524 343478  87420 144205  28528 121450 113927  76145 
##     WY 
##  27774
 
header <- c ("state", "sex", "year", "name", "occurrence") # column names
names (df) <- header
df 
## # A tibble: 5,933,561 x 5
##    state sex    year name     occurrence
##    <fct> <fct> <int> <fct>         <int>
##  1 AK    F      1910 Mary             14
##  2 AK    F      1910 Annie            12
##  3 AK    F      1910 Anna             10
##  4 AK    F      1910 Margaret          8
##  5 AK    F      1910 Helen             7
##  6 AK    F      1910 Elsie             6
##  7 AK    F      1910 Lucy              6
##  8 AK    F      1910 Dorothy           5
##  9 AK    F      1911 Mary             12
## 10 AK    F      1911 Margaret          7
## # … with 5,933,551 more rows
```

### Some exploratory analysis: what are the most popular names of the years?

``` r
national_count <- df %>% # sum up national count of baby names
  group_by(sex, year, name) %>% 
  summarize (occurrence_all = sum (occurrence)) %>% 
  arrange (sex, year, desc(occurrence_all)) %>% 
  print
## # A tibble: 613,845 x 4
## # Groups:   sex, year [216]
##    sex    year name      occurrence_all
##    <fct> <int> <fct>              <int>
##  1 F      1910 Mary               22848
##  2 F      1910 Helen              10479
##  3 F      1910 Margaret            8222
##  4 F      1910 Dorothy             7314
##  5 F      1910 Ruth                7209
##  6 F      1910 Anna                6433
##  7 F      1910 Elizabeth           5792
##  8 F      1910 Mildred             5690
##  9 F      1910 Marie               4778
## 10 F      1910 Alice               4666
## # … with 613,835 more rows

popular_names <- national_count %>% # look for the most popular names
  filter (occurrence_all == max (occurrence_all)) 
  
popular_names %>% # print table
  spread (sex, name) %>% 
  kable (format = "markdown") %>% 
  print
## 
## 
## | year| occurrence_all|F        |M       |
## |----:|--------------:|:--------|:-------|
## | 1910|          11450|NA       |John    |
## | 1910|          22848|Mary     |NA      |
## | 1911|          13446|NA       |John    |
## | 1911|          24390|Mary     |NA      |
## | 1912|          24587|NA       |John    |
## | 1912|          32304|Mary     |NA      |
## | 1913|          29329|NA       |John    |
## | 1913|          36642|Mary     |NA      |
## | 1914|          37948|NA       |John    |
## | 1914|          45345|Mary     |NA      |
## | 1915|          47577|NA       |John    |
## | 1915|          58187|Mary     |NA      |
## | 1916|          50045|NA       |John    |
## | 1916|          61438|Mary     |NA      |
## | 1917|          51853|NA       |John    |
## | 1917|          64281|Mary     |NA      |
## | 1918|          56559|NA       |John    |
## | 1918|          67366|Mary     |NA      |
## | 1919|          53529|NA       |John    |
## | 1919|          65841|Mary     |NA      |
## | 1920|          56913|NA       |John    |
## | 1920|          70980|Mary     |NA      |
## | 1921|          58217|NA       |John    |
## | 1921|          73982|Mary     |NA      |
## | 1922|          57276|NA       |John    |
## | 1922|          72175|Mary     |NA      |
## | 1923|          57472|NA       |John    |
## | 1923|          71635|Mary     |NA      |
## | 1924|          60798|NA       |Robert  |
## | 1924|          73532|Mary     |NA      |
## | 1925|          60896|NA       |Robert  |
## | 1925|          70597|Mary     |NA      |
## | 1926|          61131|NA       |Robert  |
## | 1926|          67829|Mary     |NA      |
## | 1927|          61669|NA       |Robert  |
## | 1927|          70637|Mary     |NA      |
## | 1928|          60696|NA       |Robert  |
## | 1928|          66869|Mary     |NA      |
## | 1929|          59796|NA       |Robert  |
## | 1929|          63510|Mary     |NA      |
## | 1930|          62147|NA       |Robert  |
## | 1930|          64146|Mary     |NA      |
## | 1931|          60296|Mary     |NA      |
## | 1931|          60513|NA       |Robert  |
## | 1932|          59262|NA       |Robert  |
## | 1932|          59872|Mary     |NA      |
## | 1933|          54212|NA       |Robert  |
## | 1933|          55507|Mary     |NA      |
## | 1934|          55828|NA       |Robert  |
## | 1934|          56924|Mary     |NA      |
## | 1935|          55065|Mary     |NA      |
## | 1935|          56524|NA       |Robert  |
## | 1936|          54373|Mary     |NA      |
## | 1936|          58491|NA       |Robert  |
## | 1937|          55642|Mary     |NA      |
## | 1937|          61829|NA       |Robert  |
## | 1938|          56214|Mary     |NA      |
## | 1938|          62265|NA       |Robert  |
## | 1939|          54903|Mary     |NA      |
## | 1939|          59645|NA       |Robert  |
## | 1940|          56201|Mary     |NA      |
## | 1940|          62471|NA       |James   |
## | 1941|          58040|Mary     |NA      |
## | 1941|          66731|NA       |James   |
## | 1942|          63249|Mary     |NA      |
## | 1942|          77173|NA       |James   |
## | 1943|          66169|Mary     |NA      |
## | 1943|          80258|NA       |James   |
## | 1944|          62466|Mary     |NA      |
## | 1944|          76947|NA       |James   |
## | 1945|          59284|Mary     |NA      |
## | 1945|          74450|NA       |James   |
## | 1946|          67468|Mary     |NA      |
## | 1946|          87431|NA       |James   |
## | 1947|          94756|NA       |James   |
## | 1947|          99686|Linda    |NA      |
## | 1948|          88588|NA       |James   |
## | 1948|          96209|Linda    |NA      |
## | 1949|          86855|NA       |James   |
## | 1949|          91016|Linda    |NA      |
## | 1950|          80432|Linda    |NA      |
## | 1950|          86239|NA       |James   |
## | 1951|          73972|Linda    |NA      |
## | 1951|          87272|NA       |James   |
## | 1952|          67088|Linda    |NA      |
## | 1952|          87107|NA       |James   |
## | 1953|          64372|Mary     |NA      |
## | 1953|          86195|NA       |Robert  |
## | 1954|          68005|Mary     |NA      |
## | 1954|          88514|NA       |Michael |
## | 1955|          63162|Mary     |NA      |
## | 1955|          88335|NA       |Michael |
## | 1956|          61750|Mary     |NA      |
## | 1956|          90620|NA       |Michael |
## | 1957|          61092|Mary     |NA      |
## | 1957|          92695|NA       |Michael |
## | 1958|          55853|Mary     |NA      |
## | 1958|          90520|NA       |Michael |
## | 1959|          54477|Mary     |NA      |
## | 1959|          85255|NA       |Michael |
## | 1960|          51474|Mary     |NA      |
## | 1960|          85928|NA       |David   |
## | 1961|          47676|Mary     |NA      |
## | 1961|          86922|NA       |Michael |
## | 1962|          46080|Lisa     |NA      |
## | 1962|          85037|NA       |Michael |
## | 1963|          56037|Lisa     |NA      |
## | 1963|          83789|NA       |Michael |
## | 1964|          54276|Lisa     |NA      |
## | 1964|          82653|NA       |Michael |
## | 1965|          60266|Lisa     |NA      |
## | 1965|          81019|NA       |Michael |
## | 1966|          56913|Lisa     |NA      |
## | 1966|          79992|NA       |Michael |
## | 1967|          52435|Lisa     |NA      |
## | 1967|          82445|NA       |Michael |
## | 1968|          49532|Lisa     |NA      |
## | 1968|          82006|NA       |Michael |
## | 1969|          45029|Lisa     |NA      |
## | 1969|          85208|NA       |Michael |
## | 1970|          46157|Jennifer |NA      |
## | 1970|          85303|NA       |Michael |
## | 1971|          56784|Jennifer |NA      |
## | 1971|          77591|NA       |Michael |
## | 1972|          63604|Jennifer |NA      |
## | 1972|          71405|NA       |Michael |
## | 1973|          62451|Jennifer |NA      |
## | 1973|          67846|NA       |Michael |
## | 1974|          63112|Jennifer |NA      |
## | 1974|          67583|NA       |Michael |
## | 1975|          58185|Jennifer |NA      |
## | 1975|          68454|NA       |Michael |
## | 1976|          59474|Jennifer |NA      |
## | 1976|          66964|NA       |Michael |
## | 1977|          58964|Jennifer |NA      |
## | 1977|          67610|NA       |Michael |
## | 1978|          56323|Jennifer |NA      |
## | 1978|          67158|NA       |Michael |
## | 1979|          56718|Jennifer |NA      |
## | 1979|          67733|NA       |Michael |
## | 1980|          58376|Jennifer |NA      |
## | 1980|          68693|NA       |Michael |
## | 1981|          57049|Jennifer |NA      |
## | 1981|          68765|NA       |Michael |
## | 1982|          57115|Jennifer |NA      |
## | 1982|          68228|NA       |Michael |
## | 1983|          54342|Jennifer |NA      |
## | 1983|          67995|NA       |Michael |
## | 1984|          50561|Jennifer |NA      |
## | 1984|          67736|NA       |Michael |
## | 1985|          48346|Jessica  |NA      |
## | 1985|          64906|NA       |Michael |
## | 1986|          52674|Jessica  |NA      |
## | 1986|          64205|NA       |Michael |
## | 1987|          55991|Jessica  |NA      |
## | 1987|          63647|NA       |Michael |
## | 1988|          51538|Jessica  |NA      |
## | 1988|          64133|NA       |Michael |
## | 1989|          47885|Jessica  |NA      |
## | 1989|          65382|NA       |Michael |
## | 1990|          46475|Jessica  |NA      |
## | 1990|          65282|NA       |Michael |
## | 1991|          43479|Ashley   |NA      |
## | 1991|          60785|NA       |Michael |
## | 1992|          38452|Ashley   |NA      |
## | 1992|          54386|NA       |Michael |
## | 1993|          34988|Jessica  |NA      |
## | 1993|          49550|NA       |Michael |
## | 1994|          32117|Jessica  |NA      |
## | 1994|          44470|NA       |Michael |
## | 1995|          27935|Jessica  |NA      |
## | 1995|          41402|NA       |Michael |
## | 1996|          25151|Emily    |NA      |
## | 1996|          38365|NA       |Michael |
## | 1997|          25732|Emily    |NA      |
## | 1997|          37548|NA       |Michael |
## | 1998|          26181|Emily    |NA      |
## | 1998|          36614|NA       |Michael |
## | 1999|          26539|Emily    |NA      |
## | 1999|          35361|NA       |Jacob   |
## | 2000|          25953|Emily    |NA      |
## | 2000|          34471|NA       |Jacob   |
## | 2001|          25055|Emily    |NA      |
## | 2001|          32541|NA       |Jacob   |
## | 2002|          24463|Emily    |NA      |
## | 2002|          30568|NA       |Jacob   |
## | 2003|          25688|Emily    |NA      |
## | 2003|          29630|NA       |Jacob   |
## | 2004|          25033|Emily    |NA      |
## | 2004|          27879|NA       |Jacob   |
## | 2005|          23937|Emily    |NA      |
## | 2005|          25830|NA       |Jacob   |
## | 2006|          21400|Emily    |NA      |
## | 2006|          24841|NA       |Jacob   |
## | 2007|          19355|Emily    |NA      |
## | 2007|          24273|NA       |Jacob   |
## | 2008|          18809|Emma     |NA      |
## | 2008|          22591|NA       |Jacob   |
## | 2009|          21169|NA       |Jacob   |
## | 2009|          22298|Isabella |NA      |
## | 2010|          22117|NA       |Jacob   |
## | 2010|          22905|Isabella |NA      |
## | 2011|          20365|NA       |Jacob   |
## | 2011|          21837|Sophia   |NA      |
## | 2012|          19069|NA       |Jacob   |
## | 2012|          22304|Sophia   |NA      |
## | 2013|          18241|NA       |Noah    |
## | 2013|          21213|Sophia   |NA      |
## | 2014|          19286|NA       |Noah    |
## | 2014|          20924|Emma     |NA      |
## | 2015|          19613|NA       |Noah    |
## | 2015|          20435|Emma     |NA      |
## | 2016|          19082|NA       |Noah    |
## | 2016|          19471|Emma     |NA      |
## | 2017|          18728|NA       |Liam    |
## | 2017|          19738|Emma     |NA      |
```

### Use heatmap concept in ggplot2 to show time series changes

``` r
library (ggplot2)
ggplot (popular_names %>% filter (sex == "F"), 
       aes (x = year, y = reorder (name, -year), fill = name)) + 
  # reorder names according to their order of appearance (ascending year)
  # specify colors by names
  geom_tile () +
  labs (x = "", y="", title = "Most popular baby girl names") +
  scale_x_continuous (breaks = seq (min (popular_names$year), max (popular_names$year), by = 10)) +
  theme_minimal() +
  theme (legend.position = "none", # remove legend
         axis.text.y = element_text (size = 18))
```

![](../images/popular_babynames-1.png)

``` r

ggplot (popular_names %>% filter (sex == "M"), 
       aes (x = year, y = reorder (name, -year), fill = name)) +
  geom_tile () +
  labs (x = "", y="", title = "Most popular baby boy names") +
  scale_x_continuous (breaks = seq (min (popular_names$year), max (popular_names$year), by = 10)) +
  theme_minimal() +
  theme (legend.position = "none", # remove legend
         axis.text.y = element_text (size = 18))
```

![](../images/popular_babynames-2.png)

### Summary:

1.  Over the past century, the most popular female names have changed 10 times, whereas male names changed only 7 times, suggesting parents look for new names more frequently for baby girls than for boys.
2.  After the top position of the list was replaced by a new name, the old favorite names might come back once again in the following years. However, when the top position was replaced for the second time, the old favorites are no longer the favorites.

### Next possible questions:

1.  What social context caused the short appearance of Ashley and David?
2.  What are the all-time popular names?
