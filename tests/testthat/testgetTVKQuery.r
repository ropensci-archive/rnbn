context("Test getTVKQuery")

test_that("query works1", {
    if(!file.exists('~/rnbn_test.rdata')) skip('login details not found')
    # login
    load('~/rnbn_test.rdata')
    nbnLogin(username = UN_PWD$username, password = UN_PWD$password)
    
    dt <- getTVKQuery(query='Badger')
    
    expect_that('NHMSYS0000080191' %in% dt$ptaxonVersionKey, is_true()) 
})

test_that("query works2", {
    if(!file.exists('~/rnbn_test.rdata')) skip('login details not found')
    # login
    load('~/rnbn_test.rdata')
    nbnLogin(username = UN_PWD$username, password = UN_PWD$password)
    
    dt <- getTVKQuery(query='myotis')
    
    expect_that(!'Genus' %in% dt$rank, is_true())
    expect_that('Synonym' %in% dt$nameStatus, is_true())
})

test_that("query works2", {
    if(!file.exists('~/rnbn_test.rdata')) skip('login details not found')
    # login
    load('~/rnbn_test.rdata')
    nbnLogin(username = UN_PWD$username, password = UN_PWD$password)
    
    dt <- getTVKQuery(query='myotis',species_only=F,rec_only=T)
    
    expect_that('Genus' %in% dt$rank, is_true())
    expect_that(!'Synonym' %in% dt$nameStatus, is_true())
})

test_that("query works2", {
    if(!file.exists('~/rnbn_test.rdata')) skip('login details not found')
    # login
    load('~/rnbn_test.rdata')
    nbnLogin(username = UN_PWD$username, password = UN_PWD$password)
    
    dt <- getTVKQuery(query='myotis', top = T)
    
    expect_that(nrow(dt) == 1, is_true())
    expect_that(dt$searchMatchTitle == 'Myotis myotis', is_true())
})