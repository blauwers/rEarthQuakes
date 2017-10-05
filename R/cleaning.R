#'  This function takes raw NOAA data frame and returns a clean data frame:
#'   1) Filters year column to prevent parsing warnings when uniting
#'   2) Unites the year, month, day and converts it to the Date class
#'   3) Converts Latitute and Longitude to numeric
#'   4) Cleans location names
#'
#' @param data  raw NOAA dataframe
#' @return clean dataframe with Date, latitude, longitude conversion.
#'
#' @examples
#' \dontrun{
#'  readr::read_delim("earthquakes.tsv", delim = "\t") %>% eq_clean_data()
#' }
#'
#' @importFrom dplyr %>% mutate_ filter_
#' @importFrom tidyr drop_na_ replace_na unite_
#' @importFrom lubridate ymd
#'
#' @export
eq_clean_data <- function(data) {
        # Filters year column to prevent parsing warnings when uniting
        data  %>%
                dplyr::filter_(~YEAR > 0) %>%
                tidyr::drop_na_(c("YEAR")) %>%
                tidyr::replace_na(list("MONTH" = 1, "DAY" = 1)) %>%
                tidyr::unite_("DATE", c("YEAR","MONTH","DAY"), remove = F, sep = "-") -> data

        # Unites the year, month, day and converts it to the Date class
        data$DATE <- base::as.Date(lubridate::ymd(data$DATE, quiet = T))

        # Converts Latitute and Longitude to numeric
        data <- data %>%
                dplyr::mutate_(LATITUDE = ~base::as.numeric(LATITUDE),
                               LONGITUDE = ~base::as.numeric(LONGITUDE))

        # Clean location names
        data %>% eq_location_clean()
}

#' Internal function to clean earthquake location data
#'
#' @param data A data frame with raw data obtained from NOAA website
#'
#' @return A data frame with cleaned LOCATION_NAME column
#'
#' @details This function transforms NOAA data frame LOCATION_NAME column by
#' trimming the country name (if applicable) and converting to title case
#'
#' @note Internal package use only
#'
#' @examples
#' \dontrun{
#' clean_data <- eq_location_clean(data)
#' }
#'
#' @importFrom dplyr %>% mutate_
#' @importFrom tools toTitleCase
eq_location_clean <- function(data) {
        # Remove country from location name and convert to title case
        data %>%
                dplyr::mutate_(LOCATION_NAME = ~LOCATION_NAME %>%
                                       base::tolower() %>%
                                       base::gsub(".*: ", "", .) %>%
                                       tools::toTitleCase())

        # data %>%
        #         dplyr::mutate_(LOCATION_NAME = ~LOCATION_NAME %>%
        #                                stringr::str_replace(base::paste0(COUNTRY, ":"), "") %>%
        #                                stringr::str_trim("both") %>%
        #                                stringr::str_to_title())
}
