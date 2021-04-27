#This code takes the key from "key_construction.R" and the coordinates from "xeno plot.R" and assigns a temperature to each xeno attachment.
#I saved the output of "xeno plot.R" as "tpoints.RData" and the output of the key_construction.R" as "keytransparent.Rdata"

#head(key)
#scalevalues temperature
#1         252    35.60000
#2         220    34.76364
#3         197    33.92727
#4         176    33.09091
#5         159    32.25455
#6         140    31.41818

library(raster)

ir <- raster("IR_dorsal transparent.JPG")

load("tpoints.RData")  
load("key_transparent.RData")

tp <- coordinates(tpoints)

#need to convert tpoints axes to image axes
#Vivienne's code

#tpoints x 0:912, y 608:0
#image x 0:480, y 0:284

rescale_x <- function(x, oldmax, newmax) {((x-0)/(oldmax - 0) * newmax)} 

rescale_y <- function(x, oldmax, newmax) {newmax - ((x-0)/(oldmax - 0) * newmax) } 

x2 <- rescale_x(tp[,1], 912, 480)
y2 <- rescale_y(tp[,2], 608, 284)

plot(ir, col=gray.colors(10, start = 0.3, end = 0.9, gamma = 2.2, alpha = NULL))
points(x2, y2)
points(x2[260:262], y2[260:262], col="red", pch=16) #anchor points on thermal image


#get values from the raster of xeno points
scaled_points <- SpatialPoints(coords=cbind(x2, y2))
scale <- extract(ir, scaled_points)

temp_coord <- data.frame(x2,
                      y2,
                        scale)

#get raster coordinates and xeno yes/no for each coordinate 
all_coords <- as.data.frame(coordinates(ir))
all_coords$scale <- extract(ir, all_coords)
just_fin <- na.omit(all_coords)
#the na.omit() step will remove non-fin coordinates once the background is empty, ask for viv's help with this
#may need to crop raster so that points below y=75 so that extra body space isn't counted as fin space?
just_fin$x2tip <- (temp_coord$x2[260]-just_fin$x)
just_fin$y2tip <- (temp_coord$y2[260]-just_fin$y)
just_fin$vector2tip <- sqrt((just_fin$x2tip)^2 + (just_fin$y2tip)^2)
#add in xeno yes/no (working on this)


#translate color values to temperature using the key 
#translate scale values that are one away from scale values in the key

for (i in 1:nrow(temp_coord)) {
  j<- which(grepl(temp_coord$scale[i]-1,key$scalevalues))
  temp_coord$temperature[i] <- ifelse(length(j)!=0,key$temperature[j], NA)
}

#head(temp_coord)
#        x2        y2 scale      temperature
#1 296.98849 246.45326   199 33.9272727272727
#2 311.05263 247.56579   249             <NA>
#3 282.63158  71.93421    83 28.9090909090909
