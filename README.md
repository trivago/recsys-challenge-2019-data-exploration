# RecSys Challenge 2019 - Data exploration

This repository contains R-code to reproduce the plots in the RecSys Challenge 2019 dataset paper.

## Plotting files

Each plot files contains code to produce a the plot in question.

[figure_2.R](figure_2.R)

Frequency of action types that directly precede a clickout.

[figure_3_4.R](figure_3_4.R)

Figure 3: Temporal patterns of user interactions for the different world regions. 
Figure 4: Number of clickouts vs. number of interactions for the three world regions.

[figure_5.R](figure_5.R)

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
    [1] gridExtra_2.3     ggplot2_3.2.0     dplyr_0.8.3       data.table_1.12.6
    
    loaded via a namespace (and not attached):
     [1] Rcpp_1.0.2       withr_2.1.2      crayon_1.3.4     assertthat_0.2.1
     [5] grid_3.6.1       R6_2.4.0         gtable_0.3.0     magrittr_1.5    
     [9] scales_1.0.0     pillar_1.4.2     rlang_0.4.0      lazyeval_0.2.2  
    [13] rstudioapi_0.10  labeling_0.3     tools_3.6.1      glue_1.3.1      
    [17] munsell_0.5.0    purrr_0.3.2      yaml_2.2.0       compiler_3.6.1  
    [21] colorspace_1.4-1 pkgconfig_2.0.2  tidyselect_0.2.5 tibble_2.1.3

