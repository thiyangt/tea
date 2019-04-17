
<!-- README.md is generated from README.Rmd. Please edit that file -->
tea
===

R package for tea exported data.

Installation
------------

``` r
#install.packages("devtools")
devtools::install_github("thiyangt/tea")
library(tea)
```

Top tea exporting countries
---------------------------

``` r

library(tea)
library(gganimate)
#> Loading required package: ggplot2
library(ggthemes)
library(tidyverse)
#> -- Attaching packages --- tidyverse 1.2.1 --
#> v tibble  2.1.1       v purrr   0.3.2  
#> v tidyr   0.8.3       v dplyr   0.8.0.1
#> v readr   1.3.1       v stringr 1.4.0  
#> v tibble  2.1.1       v forcats 0.4.0
#> -- Conflicts ------ tidyverse_conflicts() --
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()

## Processing data
tea_export <- tea %>%
  gather(Year, Value, "2001":"2018", factor_key=TRUE) %>% 
  group_by(Year) %>%
  mutate(rank = min_rank(-Value) * 1) %>%
  ungroup() %>%
  filter(rank <= 20)


## Visualization
tea_plot <- ggplot(tea_export, aes(rank, group = Exporters, 
                     fill = Exporters, color = Exporters)) +
  geom_tile(aes(y = Value/2,
                height = Value,
                width = 0.9)) +
  geom_text(aes(y = 0, label = paste(Exporters, " ")), vjust = 0.2, hjust = 1) +
  coord_flip(clip = "off", expand = FALSE) +
  scale_y_continuous(labels = scales::dollar) +
  scale_x_reverse() +
  guides(color = FALSE, fill = FALSE) +
  labs(title='{closest_state}', x = "", y = "Tea exported value (US Dollar in thousand)",caption = "Sources: ITC calculations based on UN COMTRADE and ITC statistics. ")+
  theme(plot.title = element_text(hjust = 0, size = 22),
        axis.ticks.y = element_blank(),  
        axis.text.y  = element_blank(),  
        plot.margin = margin(1,1,1,4, "cm")) +
  transition_states(Year, transition_length = 4, state_length = 1) +
  ease_aes('cubic-in-out')

animate(tea_plot, fps = 25, duration = 20, width = 800, height = 600)
```

<img src="man/figures/README-unnamed-chunk-1-1.gif" width="100%" />

``` r
# save as a gif
image <- animate(tea_plot)
library(magick)
image_write(image, 'teagif.gif')
```

Acknowledgement
---------------

<https://stackoverflow.com/questions/53162821/animated-sorted-bar-chart-with-bars-overtaking-each-other>
