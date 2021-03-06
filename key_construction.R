#this is Vivienne's code that produces a key that matches color to temperature.

library(raster)

ir <- raster("IR_dorsal transparent.png")

image(ir)

#manually select color scale increments
colorscale <- locator(12)
cs <- as.data.frame(colorscale)

scalevalues <- extract(ir, cs)

key <- data.frame(scalevalues, temperature=numeric(12))

#assign temperature to the scale values
key$temperature <- seq(35.6, 26.4, length.out=12)

save(key, file="key_transparent.RData")