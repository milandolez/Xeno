#visualize and plan lol

#head(tpoints@coords)
#coords.x1 coords.x2
#[1,]  357.6522  81.98904
#[2,]  334.0000  62.00000
#[3,]  893.0000 442.00000
#[4,]  385.0000 442.00000
#[5,]  361.6515  74.68428
#[6,]  357.6831 101.10987

#head(key)
#scalevalues temperature
#1         252    35.60000
#2         220    34.76364
#3         197    33.92727
#4         176    33.09091
#5         159    32.25455
#6         140    31.41818

setwd("~/Desktop")
ir <- raster("IR_dorsal transparent.png")

#get values from the raster of xeno points
scale<-extract(ir, tpoints@coords)

temp_coord <- data.frame(tpoints@coords[1,],
                      tpoints@coords[2,],
                        scale)

#translate values to temperature
temp <- scale 
