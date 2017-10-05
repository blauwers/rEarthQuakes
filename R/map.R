#' Visualize earthquakes data on leaflet Map.
#'
#' Takes a clean NOAA data frame with earthquakes to visualize. Maps the
#' epicenters (LATITUDE/LONGITUDE) and annotates each earthquake with a popup.
#'
#' @param data Filtered dataframe of NOAA earthquakes dataset
#' @param annotation Column name from dataset used as annotation in the popup
#'
#' @return leaflet MAP shown with a circle markers, and the radius of the circle marker is
#'          proportional to the earthquake's magnitude.
#' @examples
#' \dontrun{
#'  eq_map(data, annotation = "DATE")
#'
#'  data %>%
#'        dplyr::filter(COUNTRY %in% COUNTRIES & YEAR >= 2000) %>%
#'        eq_map(annotation = "DATE")
#' }
#'
#' @importFrom leaflet leaflet addTiles addCircleMarkers
#' @importFrom dplyr %>%
#'
#' @export

eq_map <- function(data, annotation) {
        leaflet::leaflet() %>%
                leaflet::addTiles() %>%
                leaflet::addCircleMarkers(
                        data = data,
                        radius = data$EQ_PRIMARY ,
                        stroke = FALSE,
                        fillOpacity = 0.5,
                        lng = ~ LONGITUDE,
                        lat = ~ LATITUDE,
                        popup  = data[[annotation]]
                )
}

#' Creates a Popup text for Location, Magnitude, and Total number of Deaths in HTML format.
#'
#' Creates an annotation for each earthquake that will show the location,
#' magnitude (EQ_PRIMARY), and total number of deaths (TOTAL_DEATHS), with bold
#' labels for each ("Location", "Total deaths", and "Magnitude"). If an
#' earthquake is missing values for any of these, both the label and the value
#' will be skipped for that element of the tag.
#'
#' @param data Filtered dataframe of NOAA earthquakes dataset
#'
#' @return Popup text for Location, Magnitude, and Total number of Deaths (HTML formatted)
#'
#' @examples
#' \dontrun{
#'  eq_create_label(data)
#'
#'  data %>%
#'        dplyr::filter(COUNTRY %in% COUNTRIES & YEAR >= 2000) %>%
#'        dplyr::mutate(popup_text = eq_create_label(.)) %>%
#'        eq_map(annotation = "popup_text")
#' }
#'
#' @export
eq_create_label <- function(data) {
        location_name <-
                base::ifelse(
                        base::is.na(data$LOCATION_NAME),
                        "",
                        base::paste0("<b>Location:</b>", data$LOCATION_NAME)
                )
        eq_primary <-
                base::ifelse(
                        base::is.na(data$EQ_PRIMARY),
                        "",
                        base::paste0("<br/><b>Magnitude:</b>", data$EQ_PRIMARY)
                )
        total_deaths <-
                base::ifelse(
                        base::is.na(data$TOTAL_DEATHS),
                        "",
                        base::paste0("<br/><b>Total deaths:</b>", data$TOTAL_DEATHS)
                )
        base::paste0(location_name, eq_primary, total_deaths)
}
