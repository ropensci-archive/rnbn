context("Test getFeature")

test_that("Get details for a feature", {
    if(!file.exists('~/rnbn_test.rdata')) skip('login details not found')
    # login
    load('~/rnbn_test.rdata')
    nbnLogin(username = UN_PWD$username, password = UN_PWD$password)
    expect_equal(as.character(getFeature("97479")['label']), "SN413499")    
})
