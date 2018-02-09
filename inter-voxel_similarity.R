##### Inter-voxel similarity ####
# Iva Brunec & Buddhika Bellana, 2017
# Study: long axis voxel patterns
# Read in raw timecourse output per voxel, calculate inter-voxel similarity for whole ROI
# Script can also be used for functional connectivity between regions if you have extracted mean timecourses per ROI.

library(psych)
library(plyr)
library(psych)
library(MCMCpack)

#### Read in data ####

setwd(" ")

# read in extracted time courses
voxel_data <- read.table("example_data.txt", header = FALSE, sep = "")

# z score per voxel (this step is not necessary, but is useful if you export the data elsewhere)
voxel_data_z <- (apply(voxel_data, 2, scale)) 

#### INTER-VOXEL SIMILARITY ####

# define inter-voxel FC function
# What it does:
# Calculates correlation matrix, removes diagonal, z-transforms the correlation values & calculates their average.

interv_FC <- function(x){
  temp_cor <- cor(x)
  vech_cor <- vech(temp_cor)
  vech_cor <- vech_cor[vech_cor < 1]
  interv_z <- fisherz(vech_cor)
  result <- mean(interv_z)
  return(result)
}

# calculate mean inter-voxel per ROI
voxel_data_inter <- interv_FC(voxel_data_z)
voxel_data_inter # this is the overall similarity within the region

# Tip: The function can be applied to a list of dataframes/matrices containing voxelwise values & each output stored in a new dataframe:
datalist_inter <- lapply(datalist, function(x)interv_FC(x)) # where datalist is your list of matrices

#### Heatmap ####

# plot a heatmap of the correlation matrix:
library(corrplot)
library(RColorBrewer)
col3=colorRampPalette(c("#5E4FA2","#3288BD","#66C2A5","#ABDDA4","#E6F598","#FDAE61","#F46D43","#9E0142"))

voxel_data_cor <- cor(voxel_data)

corrplot(voxel_data_cor, method="shade", tl.pos="n", cl.pos="n", col=col3(10))




