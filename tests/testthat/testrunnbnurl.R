context("Test runnbnurl")

test_that("runnbnurl gets a response", {
    if(!file.exists('~/rnbn_test.rdata')) skip('login details not found')
    # login
    load('~/rnbn_test.rdata')
    nbnLogin(username = UN_PWD$username, password = UN_PWD$password)
    
    expect_that(length(runnbnurl(service="obs", tvks="NBNSYS0000002987", datasets="GA000373", startYear="1990", endYear="2010")) > 0, is_true()) 
})

    