# RecSys Challenge 2019 - Data exploration

This repository contains R-code to reproduce the plots in the RecSys Challenge 2019 dataset paper.

## Plotting files

Each plot files contains code to produce a the plot in question.

### Figure 2
Script: [figure_2.R](figure_2.R)  

Temporal patterns of user interactions for the different world regions.   

### Figure 3
Script: [figure_3.R](figure_3.R)  

Frequency of action types that directly precede a clickout.

### Figure 4
Script: [figure_4.R](figure_4.R)  

Distribution of number of interactions per user and prices of accommodations in the impression list.  


## Environment

    R version 3.6.1 (2019-07-05)
    Platform: x86_64-apple-darwin15.6.0 (64-bit)
    Running under: macOS Mojave 10.14.6
    
    Matrix products: default
    BLAS:   /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib
    LAPACK: /Library/Frameworks/R.framework/Versions/3.6/Resources/lib/libRlapack.dylib
    
    locale:
    [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    
    attached base packages:
    [1] stats     graphics  grDevices utils     datasets  methods   base     
    
    other attached packages:
    [1] gridExtra_2.3     anytime_0.3.7     ggplot2_3.2.0     dplyr_0.8.3      
    [5] data.table_1.12.6
    
    loaded via a namespace (and not attached):
     [1] Rcpp_1.0.2       rstudioapi_0.10  magrittr_1.5     tidyselect_0.2.5
     [5] munsell_0.5.0    colorspace_1.4-1 R6_2.4.0         rlang_0.4.0     
     [9] stringr_1.4.0    plyr_1.8.4       tools_3.6.1      grid_3.6.1      
    [13] gtable_0.3.0     withr_2.1.2      yaml_2.2.0       lazyeval_0.2.2  
    [17] assertthat_0.2.1 digest_0.6.20    tibble_2.1.3     crayon_1.3.4    
    [21] reshape2_1.4.3   purrr_0.3.2      glue_1.3.1       labeling_0.3    
    [25] stringi_1.4.3    compiler_3.6.1   pillar_1.4.2     scales_1.0.0    
    [29] pkgconfig_2.0.2
    
