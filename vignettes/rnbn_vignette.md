<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{rnbn vignette}
-->

rnbn - Extracting data from the NBN Gateway into R
======


The National Biodiversity Network (NBN) is an on-line repository for biodiversity data from the UK. At the time of writing, it contains over 100 million species records in over 900 datasets. Data can be accessed via web-services provided by the Gateway web-site (see [documentation](https://data.nbn.org.uk/Documentation/Web_Services/Web_Services-REST/resources/restapi/index.html))


## Introduction


This package provides methods to interact with the NBN's web services and get species
records and other supporting information. The functions fall into two groups:


### Functions that access a particular service

* `dataProviders` get information on the organisations that have contributed
data to specified datasets
* `datasetTaxa` gets a list of taxa that are included in a given dataset or
list of datasets.
* `getFeature` get information about a "feature" (a location at which
occurrences have been recorded) given its 'featureID'.
* `getGroupSpeciesTVKs` given the name of a group (see `listGroups`)
this function returns the pTVKs (preferred taxon version keys) for all members
of that group. This is currently restricted to returning up to 5000 results.
* `getOccurrences` get occurrences for a particular taxa, grid cell,
species group, or polygon and returns a data.frame containing the occurrences. Optionally,
the results can be filtered by dataset, date and vicecounty.
* `getTaxonomy` given a TVK, this function gets details of the taxonomic
hierarchy of a taxon.
* `getTVKQuery` given a search term this function returns species information,
including the TVK, for the first 25 taxa that match that search on the NBN.
* `listDatasets` returns a dataframe of the datasets available from the
NBN Gateway for reference.
* `listGroups` returns a dataframe of the group definitions from the
NBN Gateway for reference.
* `listOrganisations` returns a dataframe of the organisation definitions
from the NBN Gateway for reference.
* `listVCs` returns a dataframe of the Watsonian vice-counties and their
keys for reference. 
* `nbnLogin` takes a username and password and logs the user into the NBN gateway       


### Utility functions

These functions manipulate grid reference and date information  returned by the NBN Gateway

* `datePart` takes the vague date information, returned in three fields
  (`startDate`, `endDate` and `dateTypeKey`) from the NBN Gateway and extracts elements
  of the date like the year or week, whilst properly taking into account the type of vague date.
* `gridCoords` takes a grid reference string (OSGB or OSNI) and calculates
  the x,y coordinates of the bottom, left-hand corner of the grid square.
* `gridRef` takes a grid reference string (OSGB or OSNI) and extracts grid
  references at other precisions. For example, extract 10km square grid refs
  from the grid references returned from the Gateway.
* `gr2gps_latlon` takes a grid reference string (OSGB or OSNI) and calculates the latitude and longitude of the center or bottom left corner.
    
    
## Registering with the NBN gateway and logging in


To use data from the NBN gateway you must first register. This is an easy process and
can be done by visiting https://data.nbn.org.uk/User/Register. Once registered
you will be sent an email to verify your address, once verified you are ready to use 
`rnbn`. 

When using `rnbn` you will be asked to login the first time you attempt to access
occurrence data. Once logged in you will stay logged in for the remainder of your R session.


## Getting species occurrence records


First install and load the package



```r
# Install the package
install.packages('rnbn')
```

```r
# Load the package
library(rnbn)
```

```
## The NBN is moving to new APIs in 2017, as a result this package will stop working at the end of March 2017. A new package will be created for the new APIs. For more information see https://github.com/ropensci/rnbn/issues/37
```


The `getOccurrences` function gets a data.frame of species occurrence records from
the NBN Gateway. Columns include name, TVK, date and location of the observation as a
minimum, and may include other columns depending what has been submitted by the data
providers and what access they allow. The first time this function is used in an R session you will be asked to enter your username and password at the console. An alternative method for logging in is to use the nbnLogin function (see below) 

The minimum information required to request species occurrences from the NBN
Gateway is one of the following: a Taxon Version Key (TVK), a grid reference or the name
of a species group. 

Independent of which method you use there are three messages that will appear in
your console:



```r
# I could log in like this...
# nbnLogin(username = 'myUsername', password = 'myPassword')
# ...or let getOccurrences prompt me. The latter is more
# secure as I dont have to include my password in my scripts

# Request occurrence data using taxon version key
occ <- getOccurrences(tvks = 'NBNSYS0000002010')
```

```
## Requesting batch 1 of 1 
## Requesting data providers' information
```

```
## IMPORTANT: By using this package you are agreeing to the Gateway Terms & Conditions and Privacy Policy (see https://data.nbn.org.uk/Terms). This message can be suppressed using the acceptTandC argument
```


The first message returned to console details the batch number being processed. `rnbn` breaks down a data request into batches so that it does not overload the system. This is also useful for monitoring progress. The second message tells us that the function is retrieving the data providers for the data it just collected. These can be silenced by setting `silent = TRUE`. The third message is a warning that highlights the terms and conditions associated with using data from the NBN gateway. It is important that you read these terms and conditions since by using the `rnbn` package you are accepting them. This warning can be silenced by setting `acceptTandC = TRUE`.


### Using Taxon Version Keys (TVKs)
TVKs are 16-character strings of (usually, upper-case) letters and numbers. For example, "NBNSYS0000007111".


TVKs can be found using the function `getTVKquery`. This function will take the name of a species and attempt to match it to a TVK using the NBN's search feature. For example if we wanted the TVK for "badger" (*Meles meles*):



```r
# Search for taxon information using the query 'badger'
dt <- getTVKQuery(query = "badger")
# Display two columns of the data 'ptaxonVersionKey' and 'name'
dt[,c('ptaxonVersionKey','name')]
```

```
##   ptaxonVersionKey            name
## 1 NHMSYS0000080191          Badger
## 2 NBNSYS0000013055     Badger Flea
## 3 NHMSYS0000545919   a Badger flea
## 4 NHMSYS0000080191 Eurasian Badger
```


You will notice that "Badger" and "Eurasian Badger" have the same "ptaxonVersionKey" (the 'p' stands for preferred). This is because the terms are synonyms, both referring to *Meles meles* (which would also share the same ptaxonVersionKey). By using this TVK in the `getOccurrence` function it ensures that you get data for all synonyms. If you don't wish to include synonyms you can instead use the TVK given in the column "taxonVersionKey".


The following example will get all publicly available observations
of *Tropidia scita* from all datasets and for any date:



```r
# Get species TVK
# Using 'top = TRUE' returns only the best match
dt <- getTVKQuery(query = "Tropidia scita",
                  top = TRUE) 

# Retrieve data from NBN using a TVK
occ <- getOccurrences(tvks = dt$ptaxonVersionKey,
                      silent = TRUE,
                      acceptTandC = TRUE)

# Print the first few rows and a selection of columns
occ[1:10,c("pTaxonName", "startDate",
           "latitude", "longitude")]
```

```
##        pTaxonName  startDate latitude longitude
## 1  Tropidia scita 1990-05-28 50.71863 -2.015530
## 2  Tropidia scita 1994-06-30 50.84450 -1.930352
## 3  Tropidia scita 1988-01-01 51.67065 -4.093176
## 4  Tropidia scita 1985-01-01 51.70143 -4.275503
## 5  Tropidia scita 1985-01-01 51.72432 -4.368601
## 6  Tropidia scita 1997-06-11 51.72167 -4.298238
## 7  Tropidia scita 1983-01-01 51.70143 -4.275503
## 8  Tropidia scita 1995-01-01 51.68982 -4.294454
## 9  Tropidia scita 1986-01-01 52.55561 -3.925584
## 10 Tropidia scita 1986-01-01 51.72698 -4.302852
```


TVKs can also be found on the NBN gateway at https://data.nbn.org.uk/Taxa. Navigating to a species reveals additional information including the "Taxon Version Key"


Occurrences for more than one species can be obtained by passing a list of TVKs. Such lists can be created in two ways: 


```r
# List TVKs manually
tvks <- c("NHMSYS0000530420","NHMSYS0000530658")
tvks
```

```
## [1] "NHMSYS0000530420" "NHMSYS0000530658"
```

```r
# Retrieve a list of TVKs using the NBN search
species <- getTVKQuery('grouse')
tvks <- unique(species$ptaxonVersionKey)
tvks
```

```
## [1] "NHMSYS0000530420" "NHMSYS0000530658"
```


### Using grid references


Data can be retrieved by specifying a grid reference in which to search:



```r
# Retrieve data from NBN using a UK gridreference
occ <- getOccurrences(gridRef = 'TL3490',
                      silent = TRUE,
                      acceptTandC = TRUE)

# View some of the records returned
occ[1:10, c("pTaxonName", "location")]
```

```
##               pTaxonName location
## 1       Erythromma najas   TL3490
## 2         Aeshna grandis   TL3490
## 3          Aeshna cyanea   TL3490
## 4           Aeshna mixta   TL3490
## 5  Orthetrum cancellatum   TL3490
## 6   Sympetrum striolatum   TL3490
## 7   Sympetrum sanguineum   TL3490
## 8       Ischnura elegans   TL3490
## 9         Talpa europaea   TL3490
## 10      Bryum dichotomum TL342905
```


This search will work with a range of grid reference resolutions and for grid references in OSNI and OSGB format.

### Using polygons

You might wish to search within a polygon rather than a grid reference. This is supported through the use of well-known text format polygons. You can create these using the package `rgeos` R packages (see function `writeWKT`), or [via websites](http://arthur-e.github.io/Wicket/sandbox-gmaps3.html)


```r
# Create a WKT polygon
# This is a small square polygon in Oxfordshire
myPolygon <- "POLYGON((-1.120305061340332 51.60510713031779,-1.1186742782592773 51.590978433037144,-1.098933219909668 51.59129837670387,-1.0994482040405273 51.604840591807104,-1.120305061340332 51.60510713031779))"

# Retrieve data from NBN using a polygon
occ <- getOccurrences(polygon = myPolygon,
                      silent = TRUE,
                      acceptTandC = TRUE)

occ[1:10, c("pTaxonName", "location")]
```

```
##                             pTaxonName location
## 1  Sympherobius (Sympherobius) elegans     SU68
## 2                  Cynosurus cristatus     SU68
## 3                 Hypericum perforatum     SU68
## 4                 Centaurium erythraea     SU68
## 5           Euphrasia officinalis agg.     SU68
## 6                   Crataegus monogyna     SU68
## 7                 Pimpinella saxifraga     SU68
## 8                     Bromopsis erecta     SU68
## 9                     Carlina vulgaris     SU68
## 10                         Viola hirta     SU68
```


### Using a point and radius

You might wish to search for records witin a radius of a certain location, for this you can use the `point` and `radius` arguements.

The point is given as a numeric vector of length two, latitude then longitude (e.g. `c(51.6011023, -1.1278673)`). You can also supply a radius in meters. With this information rnbn will search for records that fall within a circular area around your point with the given radius.


```r
# Retrieve data from NBN using a point and radius
occ <- getOccurrences(point = c(51.603181, -1.109945),
                      radius = 1000,
                      silent = TRUE,
                      acceptTandC = TRUE)

# Where do these records come from?
head(sort(table(occ$siteName), decreasing = TRUE))
```

```
## 
##       Site name unavailable                 Oxfordshire 
##                        5437                         238 
##         Site name protected             CEH Wallingford 
##                         218                         194 
##                 Wallingford Crowmarsh Recreation ground 
##                         110                          86
```

### Using species group


Data can be retrieved by specifying a species group. Species groups are taxonomic groups that are predefined by the NBN. A list of available groups can be found using the `listGroups` function.



```r
# View some of the groups available
groups <- listGroups()
head(groups)
```

```
##                        name              key
## 1           acarine (Acari) NHMSYS0000629148
## 2 acorn worm (Hemichordata) NHMSYS0000080031
## 3                      alga NHMSYS0000080032
## 4                 amphibian NHMSYS0000080033
## 5                   annelid NHMSYS0000080034
## 6                  archaean NHMSYS0000629143
```


Once you have decided which group you require the name is passed to getOccurrences in the following manner.



```r
# Retrieve data from NBN using a species group
# Note this can take some time depending on the size of the species group
occ <- getOccurrences(group = 'quillwort',
                      acceptTandC = TRUE)
```


## Filtering results


### By Dataset


Observations can be filtered so that they come only from datasets you trust by passing one or more dataset key to the datasets parameter. Dataset keys can be found using the `listDatasets` function:



```r
# View some of the datasets available
datasets <- listDatasets()
head(datasets[45:50,]) # I select a group with short titles
```

```
##                                                     title      key
## 45              Bedfordshire Diplopoda (BNHS) - 1975-1985 GA000675
## 46           Bedfordshire Dormice (BNHS/BDG) -  2000-2014 GA000703
## 47                  Bedfordshire Fish (BNHS) -  1800-2015 GA000704
## 48             Bedfordshire Flora (BNHS/BSBI) - 1904-2013 GA000482
## 49      Bedfordshire Herpetofauna (BNHS/BRAG) - 1973-2016 GA000458
## 50 Bedfordshire Himalayan Balsam Surveys (WT) - 2010-2012 GA001205
##                                                                                                                                                                                                                                                                              description
## 45                                                                                                                                                                                                                                                                Diplopoda (Millipedes)
## 46                                                                                                                                                              Hazel/Common Dormouse (Muscardinus avellanarius) (There are no Edible Dormouse (Glis glis) records within this dataset).
## 47                                                                                                                                                                                                                                                                                 Fish.
## 48                                                                                                                                                                                                                                Vascular plants, ferns and fern allies species records
## 49                                                                                                                                                                                                                                                Reptile and Amphibian species records.
## 50 Field surveys in the River Flit Valley were undertaken during the summers of 2010 to 2012 to map the distribution and abundance of Himalayan Balsam (Impatiens glandulifera). Where none was found this was recorded, in addition to three levels of abundance low, medium and high).
##                                         href datasetLicence
## 45 https://data.nbn.org.uk/Datasets/GA000675           <NA>
## 46 https://data.nbn.org.uk/Datasets/GA000703           <NA>
## 47 https://data.nbn.org.uk/Datasets/GA000704           <NA>
## 48 https://data.nbn.org.uk/Datasets/GA000482           <NA>
## 49 https://data.nbn.org.uk/Datasets/GA000458           <NA>
## 50 https://data.nbn.org.uk/Datasets/GA001205           <NA>
```


A list of datasets can be passed in a similar way to a list of species keys.



```r
# Specify dataset keys
datasets <- c("SGB00001", "GA000483")
# Retrieve data
occ <- getOccurrences(tvk = 'NBNSYS0000007111',
                      datasets = datasets,
                      silent = TRUE
                      acceptTandC = TRUE)
```


Dataset keys can also be found on the NBN gateway at https://data.nbn.org.uk/Datasets. Clicking on a dataset reveals metadata for that dataset including the key, named "Permanent key".


### By Year


The range of years for which you want to extract data can be specified using the `startYear` and/or `endYear` parameters:


```r
# Get data for a specified species, from a specified dataset over
# a specified time period
dt <- getOccurrences(tvks = "NBNSYS0000007111",
                     datasets = "SGB00001", 
                     startYear = 1990,
                     endYear = 2006,
                     silent = TRUE,
                     acceptTandC = TRUE)
```


### By Vice-county


If data from a specific vice-county is required then the `VC` argument can be used. This takes the name of a vicecounty, a list of which can be found using `listVCs`:



```r
# View some of the vice-counties available
VCs <- listVCs()
head(VCs)
```

```
##             name identifier featureID
## 1       Anglesey GA00034452   2583220
## 2 Angus (Forfar) GA00034490   2583258
## 3       Ayrshire GA00034475   2583243
## 4     Banffshire GA00034494   2583262
## 5   Bedfordshire GA00034430   2583198
## 6      Berkshire GA00034422   2583190
```


Once you have decided the vice-county you wish to search within you can use the getOccurrence function like this:



```r
# Request data for one species from East Suffolk
occ <- getOccurrences(tvk = 'NBNSYS0000007111',
                      VC = 'East Suffolk',
                      silent = TRUE,
                      acceptTandC = TRUE)
```


## Attribute Data


Some data held by the NBN has additional attributes to those we have been getting up until now. These attributes might include information such as abundance, life stage or sex. To get this additional data we need to use the `attributes` argument. This is not on by default as this search takes a little longer and can result in quite large tables.



```r
## I'm going to get some data for Wild cat with attributes

# First I need the TVK for wild cat
tvkQuery <- getTVKQuery(query = 'wildcat',
                        top = TRUE)

# Now I'm going to get the data with attributes
WCresults <- getOccurrences(tvks = tvkQuery$ptaxonVersionKey,
                            startYear = 1999,
                            endYear = 1999,
                            attributes = TRUE,
                            silent = TRUE,
                            acceptTandC = TRUE)

# In this dataset you can see a number of columns starting 'attributes.*'
# These are the attributes columns specific to this data. 
names(WCresults)
```

```
##  [1] "observationID"           "fullVersion"            
##  [3] "datasetKey"              "surveyKey"              
##  [5] "sampleKey"               "observationKey"         
##  [7] "featureID"               "location"               
##  [9] "resolution"              "taxonVersionKey"        
## [11] "pTaxonVersionKey"        "pTaxonName"             
## [13] "pTaxonAuthority"         "startDate"              
## [15] "endDate"                 "sensitive"              
## [17] "absence"                 "publicAttribute"        
## [19] "dateTypekey"             "siteKey"                
## [21] "siteName"                "recorder"               
## [23] "determiner"              "attributes.Abundance"   
## [25] "attributes.Comment"      "attributes.SampleMethod"
## [27] "latitude"                "longitude"
```

```r
#Note not all observations have this attribute data
WCresults[10:15,c('observationID','attributes.Comment',
                  'attributes.SampleMethod')]
```

```
##    observationID
## 10     517022722
## 11     517023627
## 12     517025692
## 13     517027077
## 14     517034379
## 15     517039499
##                                                        attributes.Comment
## 10                                                         Seen. VC: 108.
## 11                                                  Track/trail. VC: 108.
## 12                                                                       
## 13                                                                       
## 14 Tracks/trail. Ref: Swan, P. (2000). field records. From IMAG database.
## 15                                                                  Seen.
##    attributes.SampleMethod
## 10       Field Observation
## 11       Field Observation
## 12       Field Observation
## 13       Field Observation
## 14       Field Observation
## 15       Field Observation
```


## Dataset Information


Two functions allow access to additional information about datasets.


### Data providers


For many uses of data from the NBN it is necessary to get permission from data owners. The `dataProviders` function returns the contact information for a given dataset:



```r
# Get contact details for two datasets
providers <- dataProviders(c('GA000426', 'GA000832'))

# A range of details are provided
names(providers)
```

```
## [1] "id"           "name"         "address"      "postcode"    
## [5] "contactName"  "contactEmail" "website"
```

```r
# This function is used internally to provide contact
# information for getOccurrences searchs
occ <- getOccurrences(gridRef = 'TL3490',
                      silent = TRUE,
                      acceptTandC = TRUE)

# The information is returned as an attribute 'providers'
providers <- attr(occ, 'providers')

# A row is given for each data provider
nrow(providers)
```

```
## [1] 8
```


### Taxa list


It can sometimes be helpful to have a list of taxa that are recorded in a given dataset here is an example of how this can be done:



```r
# Get taxa list for the ladybird survey
taxalist <- datasetTaxa('GA000312')

# A range of details are provided
names(taxalist)
```

```
##  [1] "taxonVersionKey"      "name"                 "authority"           
##  [4] "languageKey"          "taxonOutputGroupKey"  "taxonOutputGroupName"
##  [7] "commonName"           "gatewayRecordCount"   "href"                
## [10] "observationCount"     "datasetKey"           "ptaxonVersionKey"
```

```r
# Here are some of those species
head(taxalist$commonName)
```

```
## [1] "2-spot Ladybird"     "10-spot Ladybird"    "Eyed Ladybird"      
## [4] "Water Ladybird"      "Larch Ladybird"      "Cream-spot Ladybird"
```
