#' Get Dataset definitions
#' 
#' Gives a dataframe of the datasets available from the NBN Gateway for reference.
#' 
#' @export
#' @param ... Further named parameters passed on to \code{\link[httr]{GET}}
#' @return A dataframe containing the names and keys of datasets on the NBN Gateway as
#' well as a number of other attributes.
#' @author Stuart Ball, JNCC \email{stuart.ball@@jncc.gov.uk}
#' @seealso \code{\link{getFeature}}, \code{\link{getOccurrences}}
#' @examples \dontrun{ 
#'  t <- listDatasets()
#' }

listDatasets <- function(...) {
    
    ## return a JSON object (list of lists)
    json <- runnbnurl(service="list",list='datasets', ... = ...)
        
    if (length(json) > 0) {
      #n <- unique(unlist(c(sapply(json, names))))
      # specify the columns we need
      n <- c('title', 'key', 'description', 'href', 'datasetLicence')
      d <- matrix(nrow = length(json), ncol = length(n), dimnames = list(seq(1:length(json)), 
                                                                         n))
      for (i in 1:length(json)) {
        for (j in 1:length(json[[i]])) {
          if(names(json[[i]][j]) %in% n){
            if(names(json[[i]][j]) == 'datasetLicence'){
              k <- grep(names(json[[i]][j]), n)
              d[i, k] <- json[[i]][[j]]$name
            } else {
              k <- grep(names(json[[i]][j]), n)
              d[i, k] <- json[[i]][[j]]
            }
          }
        }
      }
      d <- as.data.frame(d)
      if ("absence" %in% colnames(d)) {
        d <- d[which(d$absence == FALSE), ]
      }
      d$title <- gsub("<i>", "", d$title)
      d$title <- gsub("</i>", "", d$title)
      d <- d[with(d, order(d$title)), ]
      return(d)
    } else {
        return(NULL)
    }
}