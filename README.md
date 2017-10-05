<!-- README.md is generated from README.Rmd. Please edit that file -->
rEarthQuakes
============

[![Travis-CI Build Status](https://travis-ci.org/blauwers/rEarthQuakes?branch=master)](https://travis-ci.org/blauwers/rEarthQuakes)

Description
-----------

The goal of rEarthQuakes is to make it easy visualize the data from NOAA's Significant Earthquake Database. This database obtained from the U.S. National Oceanographic and Atmospheric Administration (NOAA) on significant earthquakes around the world. This dataset contains information about 5,933 earthquakes over an approximately 4,000 year time span.

[NOAA Significant Earthquake Database](https://www.ngdc.noaa.gov/nndc/struts/form?t=101650&s=1&d=1)

Examples
--------

We start by download the NOAA Significant Earthquake Database.

``` r
data <- readr::read_delim("https://www.ngdc.noaa.gov/nndc/struts/results?type_0=Exact&query_0=$ID&t=101650&s=13&d=189&dfn=signif.txt", delim = "\t")
```

This creates a `ggplot2` object with earthquake timelines and labels grouped by country, colored by number of casualties and sized by magnitude.

``` r
data %>%
        eq_clean_data() %>%
        filter(COUNTRY %in% c("USA", "CHINA"), YEAR > 2005) %>%
        ggplot(aes(x = DATE,
                   y = COUNTRY,
                   color = as.numeric(TOTAL_DEATHS),
                   size = as.numeric(EQ_PRIMARY)
                   )) +
        geom_timeline() +
        geom_timeline_label(aes(label = LOCATION_NAME), n_max = 5) +
        theme_timeline() +
        labs(size = "Richter scale value", color = "# deaths") + 
        scale_x_date(limits = c(lubridate::ymd("2005-01-01"), 
                                lubridate::ymd("2018-01-01")))
```

![](README-Earthquake%20Timeline%20Plot-1.png)

We can also plot the individual earthquakes on an interactive `leaflet` map including their location name, magnitude, and number of casualties as annotation.

``` r
data %>% 
  eq_clean_data() %>% 
  dplyr::filter(COUNTRY == "MEXICO" & YEAR >= 2000) %>% 
  dplyr::mutate(popup_text = eq_create_label(.)) %>% 
  eq_map(annotation = "popup_text") -> map
```

<img src="README-Earthquake Map-1.png" width="992" />

Author
------

[Bart Lauwers](https://github.com/blauwers)
