context("Test listDatasets")

test_that("List datasets", {
    if(!file.exists('~/rnbn_test.rdata')) skip('login details not found')
    # login
    load('~/rnbn_test.rdata')
    nbnLogin(username = UN_PWD$username, password = UN_PWD$password)
    
    lists<-listDatasets()
    
    expect_true(is.data.frame(lists))
    expect_true(nrow(lists)>700)
})
