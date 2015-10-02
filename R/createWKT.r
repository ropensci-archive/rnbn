#' Create polygon from point
#'
#' Covert latitude and longitude plus a radius into a WKT string.
#' 
#' @param latitude numeric
#' @param longitude numeric 
#' @param radius numeric, distance in meters 
#' @return Polygon as a WKT string
#' @import sp
#' @import rgeos
#' @examples
#' 
#' createWKT(51.6011023, -1.1278673)

createWKT <- function(latitude, longitude, radius = 5000){
    
    if(!is.numeric(radius)) stop('radius must be numeric (meters)')
    if(!is.numeric(latitude) | !is.numeric(longitude)) stop('latitude and longitude must be numeric')

    p <- SpatialPointsDataFrame(coords = data.frame(lon = longitude, lat = latitude),
                                data.frame(ID = 1),
                                proj4string = CRS("+proj=longlat +ellps=WGS84 +datum=WGS84"))
    stopifnot(length(p) == 1)
    cust <- sprintf("+proj=tmerc +lat_0=%s +lon_0=%s +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs", 
                    p@coords[[2]], p@coords[[1]])
    projected <- spTransform(p, CRS(cust))
    buffered <- gBuffer(projected, width = radius, byid = TRUE)
    bufferedOrg <- spTransform(buffered, p@proj4string)
    writeWKT(bufferedOrg)
    
}