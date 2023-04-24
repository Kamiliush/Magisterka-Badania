
install.packages("imagefx")
install.packages("png")
install.packages("imager")

library(imagefx)
library(png)
library(imager)

imageChernobyliteBase1 <- readPNG("./obrazki/Chernobylite-plot01.png")

imageChernobyliteBase1_cimg <- as.cimg(imageChernobyliteBase1)
imageChernobyliteBase1_cimg <- imrotate(imageChernobyliteBase1_cimg, 90)
imageChernobyliteBase1_cimg <- flip_image(imageChernobyliteBase1_cimg, 'y')

plot(imageChernobyliteBase1_cimg)
plot(boats)

image2(imageChernobyliteBase1, asp = 1)


