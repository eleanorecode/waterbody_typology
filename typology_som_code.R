#Self organising maps (method provided by: https://rpubs.com/erblast/SOM)
library(tidyr)
library(plyr)
library(dplyr)
library(ggplot2)
library(kohonen)
library(viridis)

#### DATA ####
charac<-read.csv("typology_characteristics.csv",header=T)
#Rows each waterbody, first column waterbody ID, 
#remaining columns each of the 22 catchment characteristics, 

##### SOM ####
data=charac[,-c(1,2)]
n_iterations = 10000 
recalculate_map = T
recalculate_no_clusters = T

data_list=list()
distances = vector()

data.nam<-names(data)

data_list[['data.nam']] = scale(data[,data.nam])   
distances = c( distances, 'euclidean') 

#Create grid to map SOM
som_grid = kohonen::somgrid(xdim=12,ydim=28,topo="hexagonal")

#Conduct SOM 
som_model = kohonen::supersom(data_list, 
                              grid=som_grid,
                              rlen= n_iterations,
                              alpha = 0.05,
                              normalizeDataLayers = FALSE, #Datasets 500+ mean distances only applied to 500 samples so layers aren't overwhelmed
                              dist.fcts = distances)

#### Hierarchal clustering ####
codes = tibble( layers = names(som_model$codes)
                ,codes = som_model$codes ) %>%
  mutate( codes = purrr::map(codes, as_tibble) ) %>%
  spread( key = layers, value = codes) %>%
  apply(1, bind_cols) %>%
  .[[1]] %>%
  as_tibble()
dist_m<-dist(codes) %>% as.matrix()   #generte distance matrix for codes
dist_on_map<-kohonen::unit.distances(som_grid) #separate distance matrix for map location
dist_adj = dist_m ^ dist_on_map #exponentiate euclidean distance by distance on map

clust_adj = hclust(as.dist(dist_adj), 'ward.D2')
som_cluster_adj = cutree(clust_adj, 7)

#### Plot Heatmaps ####
#unscale variables for plotting heatmaps
x<-1:22

for(i in x){
  df<-aggregate(as.numeric(data[,i]), by=list(som_model$unit.classif), FUN=mean, simplify=TRUE)[,2]
  assign(paste("unscaled",i, sep=""),df)
}

dfs<-list(unscaled3,unscaled4,unscaled6,unscaled5,unscaled7,unscaled8,unscaled2,unscaled1,unscaled13,
          unscaled10,unscaled11,unscaled9,unscaled12,unscaled14,unscaled15,unscaled16,unscaled17,unscaled21,
          unscaled18,unscaled22,unscaled19,unscaled20)
nums<-c(3,4,6,5,7,8,2,1,13,10,11,9,12,14,15,16,17,21,18,22,19,20)

#plot heatmaps
par(mfrow=c(5,5),cex=0.9, mex=1)        
plot(som_model, type="counts", palette.name=plasma, heatkeywidth = 1, main="Count")    #number of samples in each node - ideally the sample distribution is relatively uniform. Large values in some map areas suggests that a larger map would be benificial. Empty nodes indicate that your map size is too big for the number of samples. Aim for at least 5-10 samples per node when choosing map size. 
plot(som_model, type="dist.neighbours", palette.name=plasma, heatkeywidth = 1, main="U-matrix")   #distance to neighbour
for(i in dfs){
  for(j in nums){
    plot(som_model, type="property", property=i, main=names(data)[j], palette.name=viridis,heatkeywidth = 1)
  } 
}
plot(som_model, type = "property", property=som_cluster_adj, palette.name = plasma, pchs = NA, 
     main="Clusters",heatkeywidth = 1)
add.cluster.boundaries(som_model, som_cluster_adj)
dev.off()

##### Add clusters to original dataset ####
link = tibble( map_loc = names(som_cluster_adj) %>% as.integer()
               ,cluster = som_cluster_adj)

pred = tibble( map_loc = som_model$unit.classif) %>% left_join(link)
data_pred = charac %>% bind_cols(pred)


















