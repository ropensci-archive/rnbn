context("Test createWKT")
library(rgeos)


test_that("Errors given", {
    expect_error(rnbn:::createWKT('tom', 'sam'), 'latitude and longitude must be numeric') 
    expect_error(rnbn:::createWKT(51.6011023, -1.1278673, 'tom'), '*radius must be numeric (meters)*')
})

test_that("Success", {
    
    myPoly <- rnbn:::createWKT(51.6011023, -1.1278673, 10000)
    
    expect_is(myPoly, 'character')
    readPoly <- readWKT(myPoly)
    expect_is(readPoly, 'SpatialPolygons')
    
})