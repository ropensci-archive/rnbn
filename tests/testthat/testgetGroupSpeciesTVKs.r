context("Test getGroupSpeciesTVKs")

test_that("Returns a list of TVKS", {
    if(!file.exists('~/rnbn_test.rdata')) skip('login details not found')
    # login
    load('~/rnbn_test.rdata')
    nbnLogin(username = UN_PWD$username, password = UN_PWD$password)
    expect_true(length(getGroupSpeciesTVKs('reptile'))>10)    
})
