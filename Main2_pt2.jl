include("Utils.jl") 
include("MyLib.jl")

using FFTW
using Statistics
using JSON
using Images
using ImageView

image_path = "immagini/bridge.bmp"

img = load(image_path)
img = Gray.(img)
imshow(img)
println(size(img))

f = 20
d = 8

blocks = split_image_into_blocks(img, f)

# Visualizza il primo blocco per verificare
# println(sqrt(size(blocks)[1]))

# for i in 1:f*f
#     println("\nSize: ", size(blocks[i]))
# end

# block = Float64.(Array(blocks[1]))
# cc = FFTW.dct(block)
# print(size(cc))

ff = image_compress(blocks, d)

height, width = size(img)
height = Int(floor(height/f)*f)
width = Int(floor(width/f)*f)
ff_img = reassemble_from_blocks(ff, height, width, f)
ff_img = Gray{N0f8}.(ff_img)

println(size(ff_img))
imshow(ff_img)