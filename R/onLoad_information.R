# things to do on loading the package
.onLoad <- function(libname, pkgname) {
    packageStartupMessage("The NBN is moving to new APIs in 2017, as a result this package will be depricated and a new package created for the new APIs. For more information see https://github.com/ropensci/rnbn/issues/37")
}
