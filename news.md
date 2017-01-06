rnbn 1.1.2 (2017-01-06)
=========================

### DECOMISSIONING

The NBN gateway services which rnbn uses are being stopped in March 2017. At this time rnbn will stop working. We hope to be able to replace rnbn with another r-package that will use the new NBN servies being launched. Updates will be posted on the rnbn Github pages https://github.com/ropensci/rnbn

### MAJOR CHANGES

* Add an .onAttach warning of the decomissioning of rnbn on the 31st March 2017

rnbn 1.1.1 (2016-12-06)
=========================

### MINOR IMPROVEMENTS

* Address issues arrising when the data contains NA location data or mal-formed grid references (#29)
* Address issues when TVKs are missing

rnbn 1.1.0 (2016-09-16)
=========================
    
### NEW FEATURES

* User can now search using a polygon or a point and buffer in `getOccurrences` (#12)

### MINOR IMPROVEMENTS

* '...' can be used in most called to pass arguemnts to `GET` (#16)
* Improvements to testing
