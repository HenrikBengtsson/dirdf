# dirdf - Extracts Metadata from Directory and File Names

[![Build Status](https://travis-ci.org/ropenscilabs/dirdf.svg)](https://travis-ci.org/ropenscilabs/dirdf) 
[![Build Status](https://ci.appveyor.com/api/projects/status/egi4i7nwyvrvm160?svg=true)](https://ci.appveyor.com/project/HenrikBengtsson/dirdf)
[![codecov](https://codecov.io/gh/ropenscilabs/dirdf/badge.svg)](https://codecov.io/gh/ropenscilabs/dirdf)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

Create tidy data frames of file metadata from directory and file names.


## Install

This package is only available on GitHub - it is _not_ available on CRAN.  Install it as:
```r
remotes::install_github("ropenscilabs/dirdf")
```


## Examples

``` r
path <- system.file("examples", "dataset_1", package = "dirdf")
dir(path)
```

    ## [1] "2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_A01.csv"
    ## [2] "2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_A02.csv"
    ## [3] "2014-02-26_BRAFWTNEGASSAY_FFPEDNA-CRC-1-41_D08.csv"                    
    ## [4] "2014-03-05_BRAFWTNEGASSAY_FFPEDNA-CRC-REPEAT_platefile.csv"            
    ## [5] "2016-04-01_BRAFWTNEGASSAY_FFPEDNA-CRC-1-41.csv"

``` r
dirdf::dirdf(path, template = "Date_Assay_Plasmid-Type-Fraction_WellNumber?.extension")
```

    ##         Date          Assay Plasmid     Type            Fraction
    ## 1 2013-06-26 BRAFWTNEGASSAY Plasmid Cellline 100-1MutantFraction
    ## 2 2013-06-26 BRAFWTNEGASSAY Plasmid Cellline 100-1MutantFraction
    ## 3 2014-02-26 BRAFWTNEGASSAY FFPEDNA      CRC                1-41
    ## 4 2014-03-05 BRAFWTNEGASSAY FFPEDNA      CRC              REPEAT
    ## 5 2016-04-01 BRAFWTNEGASSAY FFPEDNA      CRC                1-41
    ##   WellNumber extension
    ## 1        A01       csv
    ## 2        A02       csv
    ## 3        D08       csv
    ## 4  platefile       csv
    ## 5       <NA>       csv
    ##                                                                 pathname
    ## 1 2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_A01.csv
    ## 2 2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_A02.csv
    ## 3                     2014-02-26_BRAFWTNEGASSAY_FFPEDNA-CRC-1-41_D08.csv
    ## 4             2014-03-05_BRAFWTNEGASSAY_FFPEDNA-CRC-REPEAT_platefile.csv
    ## 5                         2016-04-01_BRAFWTNEGASSAY_FFPEDNA-CRC-1-41.csv

``` r
dirdf::dirdf(path, template = "Year-Month-Day_Assay_Plasmid-Type-Fraction_WellNumber?.extension")
```

    ##   Year Month Day          Assay Plasmid     Type            Fraction
    ## 1 2013    06  26 BRAFWTNEGASSAY Plasmid Cellline 100-1MutantFraction
    ## 2 2013    06  26 BRAFWTNEGASSAY Plasmid Cellline 100-1MutantFraction
    ## 3 2014    02  26 BRAFWTNEGASSAY FFPEDNA      CRC                1-41
    ## 4 2014    03  05 BRAFWTNEGASSAY FFPEDNA      CRC              REPEAT
    ## 5 2016    04  01 BRAFWTNEGASSAY FFPEDNA      CRC                1-41
    ##   WellNumber extension
    ## 1        A01       csv
    ## 2        A02       csv
    ## 3        D08       csv
    ## 4  platefile       csv
    ## 5       <NA>       csv
    ##                                                                 pathname
    ## 1 2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_A01.csv
    ## 2 2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_A02.csv
    ## 3                     2014-02-26_BRAFWTNEGASSAY_FFPEDNA-CRC-1-41_D08.csv
    ## 4             2014-03-05_BRAFWTNEGASSAY_FFPEDNA-CRC-REPEAT_platefile.csv
    ## 5                         2016-04-01_BRAFWTNEGASSAY_FFPEDNA-CRC-1-41.csv

Inconsistent file names
-----------------------

``` r
path <- system.file("examples", "dataset_2", package = "dirdf")
dir(path)
```

    ## [1] "2011-12-16_OTHERASSAY_FFPEDNA-CRC-1-41_D08.csv"                    
    ## [2] "2013-06-26_OTHERASSAY_Plasmid-Cellline-100-1MutantFraction_B02.csv"
    ## [3] "2014-03-05_OTHERASSAY_FFPEDNA-CRC-REPEAT_platefile.csv"            
    ## [4] "2014-07-06_OTHERASSAY_Plasmid-Cellline-100-1MutantFraction_B01.csv"
    ## [5] "2016-01-11_OTHERASSAY_FFPEDNA-CRC-2-41.csv"

``` r
dirdf::dirdf(path, template = "date_assay_experiment_well.ext")
```

    ## Error in dirdf_parse(pathnames, template = template, colnames = colnames, : Unexpected path(s) found:
    ## 2016-01-11_OTHERASSAY_FFPEDNA-CRC-2-41.csv

``` r
dirdf::dirdf(path, template = "date_assay_experiment_well?.ext")
```

    ##         date      assay                           experiment      well ext
    ## 1 2011-12-16 OTHERASSAY                     FFPEDNA-CRC-1-41       D08 csv
    ## 2 2013-06-26 OTHERASSAY Plasmid-Cellline-100-1MutantFraction       B02 csv
    ## 3 2014-03-05 OTHERASSAY                   FFPEDNA-CRC-REPEAT platefile csv
    ## 4 2014-07-06 OTHERASSAY Plasmid-Cellline-100-1MutantFraction       B01 csv
    ## 5 2016-01-11 OTHERASSAY                     FFPEDNA-CRC-2-41      <NA> csv
    ##                                                             pathname
    ## 1                     2011-12-16_OTHERASSAY_FFPEDNA-CRC-1-41_D08.csv
    ## 2 2013-06-26_OTHERASSAY_Plasmid-Cellline-100-1MutantFraction_B02.csv
    ## 3             2014-03-05_OTHERASSAY_FFPEDNA-CRC-REPEAT_platefile.csv
    ## 4 2014-07-06_OTHERASSAY_Plasmid-Cellline-100-1MutantFraction_B01.csv
    ## 5                         2016-01-11_OTHERASSAY_FFPEDNA-CRC-2-41.csv

Metadata in directory and path names
------------------------------------

``` r
> dir("examples/", recursive = TRUE)
 [1] "LabA,2016/2013-06-26_BRAFWTNEG_Plasmid-Cellline-100_A01.csv"
 [2] "LabA,2016/2013-06-26_BRAFWTNEG_Plasmid-Cellline-100_A02.csv"
 [3] "LabA,2016/2014-02-26_BRAFWTNEG_FFPEDNA-CRC-1-41_D08.csv"
 [4] "LabA,2016/2014-03-05_BRAFWTNEG_FFPEDNA-CRC-REPEAT_H03.csv"
 [5] "LabA,2016/2016-04-01_BRAFWTNEG_FFPEDNA-CRC-1-41_E12.csv"
 [6] "LabB,2015/2011-12-16_OTHER_FFPEDNA-CRC-1-41_D08.csv"
 [7] "LabB,2015/2013-06-26_OTHER_Plasmid-Cellline-100_B02.csv"
 [8] "LabB,2015/2014-03-05_OTHER_FFPEDNA-CRC-REPEAT_H03.csv"
 [9] "LabB,2015/2014-07-06_OTHER_Plasmid-Cellline-100_B01.csv"
[10] "LabB,2015/2016-01-11_OTHER_FFPEDNA-CRC-2-41.csv"

> dirdf::dirdf("examples/", template = "lab,year/date_assay_experiment_well?.ext")
    lab year       date     assay           experiment well ext                                                    pathname
1  LabA 2016 2013-06-26 BRAFWTNEG Plasmid-Cellline-100  A01 csv LabA,2016/2013-06-26_BRAFWTNEG_Plasmid-Cellline-100_A01.csv
2  LabA 2016 2013-06-26 BRAFWTNEG Plasmid-Cellline-100  A02 csv LabA,2016/2013-06-26_BRAFWTNEG_Plasmid-Cellline-100_A02.csv
3  LabA 2016 2014-02-26 BRAFWTNEG     FFPEDNA-CRC-1-41  D08 csv     LabA,2016/2014-02-26_BRAFWTNEG_FFPEDNA-CRC-1-41_D08.csv
4  LabA 2016 2014-03-05 BRAFWTNEG   FFPEDNA-CRC-REPEAT  H03 csv   LabA,2016/2014-03-05_BRAFWTNEG_FFPEDNA-CRC-REPEAT_H03.csv
5  LabA 2016 2016-04-01 BRAFWTNEG     FFPEDNA-CRC-1-41  E12 csv     LabA,2016/2016-04-01_BRAFWTNEG_FFPEDNA-CRC-1-41_E12.csv
6  LabB 2015 2011-12-16     OTHER     FFPEDNA-CRC-1-41  D08 csv         LabB,2015/2011-12-16_OTHER_FFPEDNA-CRC-1-41_D08.csv
7  LabB 2015 2013-06-26     OTHER Plasmid-Cellline-100  B02 csv     LabB,2015/2013-06-26_OTHER_Plasmid-Cellline-100_B02.csv
8  LabB 2015 2014-03-05     OTHER   FFPEDNA-CRC-REPEAT  H03 csv       LabB,2015/2014-03-05_OTHER_FFPEDNA-CRC-REPEAT_H03.csv
9  LabB 2015 2014-07-06     OTHER Plasmid-Cellline-100  B01 csv     LabB,2015/2014-07-06_OTHER_Plasmid-Cellline-100_B01.csv
10 LabB 2015 2016-01-11     OTHER     FFPEDNA-CRC-2-41 &lt;NA&gt; csv    LabB,2015/2016-01-11_OTHER_FFPEDNA-CRC-2-41.csv
```

[![rOpenSci footer](http://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
