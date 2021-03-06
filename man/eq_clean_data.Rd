% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cleaning.R
\name{eq_clean_data}
\alias{eq_clean_data}
\title{Cleans raw NOAA significant earthquake data}
\usage{
eq_clean_data(data)
}
\arguments{
\item{data}{raw NOAA dataframe}
}
\value{
clean dataframe with Date, latitude, longitude conversion.
}
\description{
This function takes raw NOAA data frame and returns a clean data frame:
  1) Filters year column to prevent parsing warnings when uniting
  2) Unites the year, month, day and converts it to the Date class
  3) Converts Latitute and Longitude to numeric
  4) Cleans location names
}
\examples{
\dontrun{
 readr::read_delim("earthquakes.tsv", delim = "\\t") \%>\% eq_clean_data()
}

}
