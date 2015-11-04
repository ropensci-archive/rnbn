context("Test listGroups")
test_that("List groups", {
    if(!file.exists('~/rnbn_test.rdata')) skip('login details not found')
    # login
    load('~/rnbn_test.rdata')
    nbnLogin(username = UN_PWD$username, password = UN_PWD$password)
    
    groups <- listGroups()
    
    expect_true(is.data.frame(groups))
    expect_true(nrow(groups)>100)
})
