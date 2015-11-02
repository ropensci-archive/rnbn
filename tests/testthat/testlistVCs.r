context("Test listVCs")

test_that("List VCs", {
    if(!file.exists('~/rnbn_test.rdata')) skip('login details not found')
    # login
    load('~/rnbn_test.rdata')
    nbnLogin(username = UN_PWD$username, password = UN_PWD$password)
    
    VCs <- listVCs()
    
    expect_true(is.data.frame(VCs))
    expect_true(nrow(VCs)==112)
})
