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

plot(ir)
points(x2, y2)
points(x2[260:262], y2[260:262], col="red", pch=16) #anchor points on thermal image


#get values from the raster of xeno points
scale<-extract(ir, x2, y2)

temp_coord <- data.frame(x2,
                      y2,
                        scale)
#> head(temp_coord)
#x2          y2 scale
#1    296.98849   246.45326   255
#2    311.05263   247.56579   255
#3    282.63158    71.93421   255
#4     15.78947    76.60526   255

#hmm... they are all 255

#translate color values to temperature using the key (still working on this)

temp_coord$temperature <- ifelse(temp_coord$scale[i]==key$scalevalues, key$temperature, NA)
