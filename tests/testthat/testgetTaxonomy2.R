context("Test getTaxonomy")
test_that("Get taxonomy", {
    if(!file.exists('~/rnbn_test.rdata')) skip('login details not found')
    # login
    load('~/rnbn_test.rdata')
    nbnLogin(username = UN_PWD$username, password = UN_PWD$password)
    expect_true(is.data.frame(getTaxonomy("NHMSYS0000528028")))
    expect_true(nrow(getTaxonomy("NHMSYS0000528028")) == 6)
})
