include("Utils.jl") 
include("MyLib.jl")

using FFTW
using Statistics
using JSON
using Images
using ImageView

image_path = "immagini/prova.bmp"
f = 2
blocks = split_image_into_blocks(image_path, f)

# Visualizza il primo blocco per verificare
println(size(blocks))

for i in 1:f*f
    imshow(blocks[i])   
end
