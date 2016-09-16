context("Test datasetTaxa")

test_that("Errors given", {
    if(!file.exists('~/rnbn_test.rdata')) skip('login details not found')
    # login
    load('~/rnbn_test.rdata')
    nbnLogin(username = UN_PWD$username, password = UN_PWD$password)
    expect_error(datasetTaxa(), 'datasets parameter cannot be NULL') 
})

test_that("Warnings given", {
    if(!file.exists('~/rnbn_test.rdata')) skip('login details not found')
    # login
    load('~/rnbn_test.rdata')
    nbnLogin(username = UN_PWD$username, password = UN_PWD$password)
    expect_warning(datasetTaxa(datasets='foo'), 'Dataset foo returned no taxa, check this is spelt correctly') 
})

test_that("Taxa are returned", {
    if(!file.exists('~/rnbn_test.rdata')) skip('login details not found')
    # login
    load('~/rnbn_test.rdata')
    nbnLogin(username = UN_PWD$username, password = UN_PWD$password)
    expect_is(taxa <- datasetTaxa(datasets=c('GA000312')), 'data.frame')
    expect_that(nrow(taxa) > 0, is_true())
    expect_that('Harmonia axyridis' %in% taxa$name, is_true())
})
