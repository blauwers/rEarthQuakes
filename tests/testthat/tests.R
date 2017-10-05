context("Test every function in the package")

data <- readr::read_delim("https://www.ngdc.noaa.gov/nndc/struts/results?type_0=Exact&query_0=$ID&t=101650&s=13&d=189&dfn=signif.txt", delim = "\t")

# eq_clean_data is supposed to return a data frame
test_that("eq_clean_data returns data frame", {
        expect_is(eq_clean_data(data), "data.frame")
})

# Date column is supposed to be added and of type Date
test_that("eq_clean_data$DATE is Date type", {
        expect_is(eq_clean_data(data)$DATE, "Date")
})

# Latitude and Longitude are supposed to be numeric
test_that("eq_clean_data returns numeric coordinates", {
        expect_is(eq_clean_data(data)$LATITUDE, "numeric")
        expect_is(eq_clean_data(data)$LONGITUDE, "numeric")
})

# eq_location_clean returns a data frame
test_that("eq_location_clean returns a data frame", {
        expect_is(eq_location_clean(data), "data.frame")
})

# geom_timeline returns a ggplot object
test_that("geom_timeline returns ggplot object", {
        myplot <- data %>% eq_clean_data() %>%
                dplyr::filter(COUNTRY %in% c("USA", "CHINA"), YEAR > 2010) %>%
                ggplot2::ggplot(ggplot2::aes(x = DATE,
                                             y = COUNTRY,
                                             color = as.numeric(TOTAL_DEATHS),
                                             size = as.numeric(EQ_PRIMARY)
                )) +
                geom_timeline()
        expect_is(myplot, "ggplot")
})

# geom_timeline_label returns a ggplot object
test_that("geom_timeline_label returns ggplot object", {
        myplot <- data %>% eq_clean_data() %>%
                dplyr::filter(COUNTRY %in% c("USA", "CHINA"), YEAR > 2010) %>%
                ggplot2::ggplot(ggplot2::aes(x = DATE,
                                             y = COUNTRY,
                                             color = as.numeric(TOTAL_DEATHS),
                                             size = as.numeric(EQ_PRIMARY)
                )) +
                geom_timeline_label(aes(label = LOCATION_NAME))
        expect_is(myplot, "ggplot")
})

# theme_timeline returns a ggplot object
test_that("theme_timeline returns ggplot object", {
        myplot <- data %>% eq_clean_data() %>%
                dplyr::filter(COUNTRY %in% c("USA", "CHINA"), YEAR > 2010) %>%
                ggplot2::ggplot(ggplot2::aes(x = DATE,
                                             y = COUNTRY,
                                             color = as.numeric(TOTAL_DEATHS),
                                             size = as.numeric(EQ_PRIMARY)
                )) +
                theme_timeline()
        expect_is(myplot, "ggplot")
})

# eq_map returns a ggplot object
test_that("eq_map returns leaflet object", {
        mymap <- data %>%
                eq_clean_data() %>%
                dplyr::filter(COUNTRY == "USA" & lubridate::year(DATE) >= 2010) %>%
                dplyr::mutate(popup_text = eq_create_label(.)) %>%
                eq_map(annotation = "popup_text")
        expect_is(mymap, "leaflet")
})

# eq_create_label returns a character vector
test_that("eq_create_label returns character vector", {
        expect_is(eq_create_label(data), "character")
})
