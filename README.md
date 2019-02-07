# Planetary_boundary_height_for_Kljun_FFP_footprint_model
extracting boundary height within North America from NOAA regional data (Only North American), used for Kljun Eddy Covaraince footprint model. 

This code serves as a supplementary file to Kljun's foortprint model for eddy covarainces system.

  A simple two-dimensional parameterisation for Flux Footprint Prediction (FFP), Geosci. Model Dev., 8, 3695-3713, 2015. 
  
They might need some improvement, especially the latitude and longitude are in an (uncommon) Northern Lambert Conformal Conic grid. I provide a work-around suggestion in my code. I will try to see whether I can figure out the equation for the coordinate conversion later.

Please cite this paper, if possible: 
Sun, X., Zou, C. B., Wilcox, B., & Stebler, E. (2019). Effect of vegetation on the energy balance and evapotranspiration in tallgrass prairie: A paired study using the eddy-covariance method. Boundary-Layer Meteorology, 170(1), 127-160.

By the way, I mannually plotted the footprint over map via geo-referencing using ArcGIS. The detailed steps are answed in the link: https://stackoverflow.com/questions/49478211/add-result-of-image-plot-layer-on-geographic-map-bing-map  

If you have any question, please comment or contact me via sunxm19@gmail.com.
