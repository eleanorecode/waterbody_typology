# Waterbody typology derived from catchment controls using self-organising maps
This code conducts a self-organising map (SOM) analysis on the morphometric, climatic, geological and anthropogenic characteristics of multiple waterbodies. Hierarchichal clustering is then applied to the SOM to derive a typology of catchment controls for the waterbodies. 

22 characteristics of 4485 Water Framework Directive (WFD) waterbodies in England and Wales were extracted in ArcGIS v.10.3 (details in paper by Heasley et al. currently in review). The file 'catchment_characteristics.csv' contains the characteristic values for each waterbody indicated by individual 'WB_FID' identifiers. SOM analysis is conducted in the 'kohonen' v3.0.7 package, R v3.5.1.

## DATA SOURCES
Data are all open access and downloadable following the URLs provided.

### WFD waterbody polygons (downloadable for England and Wales separately from data.gov.uk) 
Boundaries of waterbodies use to extract the 'CIRCULARITY' variable
### IHDTM (https://www.ceh.ac.uk/services/integrated-hydrological-digital-terrain-model)
Elevation dataset used to extract 'ELEVATION','SD.ELEVATION','CATCH.SLOPE','TPI','TWI' and 'HI' variables
Cumulative catchment area dataset used to extract the 'CATCH.AREA' variable
### River network (https://www.ceh.ac.uk/services/150000-watercourse-network) 
River network used to extract 'DRAINGAGE' variable
### Rainfall data (https://catalogue.ceda.ac.uk/uuid/87f43af9d02e42f483351d79b3d6162a) 
Number of days with precipitation per month (1961-2016) used to create 'RAINFALL' and 'SEASONAL' variables
### Bedrock geology (http://www.bgs.ac.uk/products/digitalmaps/DiGMapGB_50.html) 
Geology polygons used to extract 'HARD','LIMESTONE','CHALK','SANDSTONE' and 'AQUIFER' variables
### Land cover map (https://www.ceh.ac.uk/services/land-cover-map-2007) 
Land cover map 2007 used to extract 'WOOD','MOUNTAIN','NAT.GRASS','IMPV.GRASS','ARABLE','URBAN' variables

