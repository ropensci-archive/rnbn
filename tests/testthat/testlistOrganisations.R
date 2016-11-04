context("Test listOrganisations")

test_that("List organisations", {
    if(!file.exists('~/rnbn_test.rdata')) skip('login details not found')
    # login
    load('~/rnbn_test.rdata')
    nbnLogin(username = UN_PWD$username, password = UN_PWD$password)
    
    orgs <- listOrganisations()
    
    expect_true(is.data.frame(orgs))
    expect_true(nrow(orgs)>200)
})
