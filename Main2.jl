include("Utils.jl") 
include("MyLib.jl")

using FFTW
using Statistics
using JSON

# v = [231 32 233 161 24 71 140 245]
# println(DCT1(v))

# println("Fast DCT", FFTW.dct(v))

# println()

# A = [231 32 233 161 24 71 140 245
# 247 40 248 245 124 204 36 107
# 234 202 245 167 9 217 239 173
# 193 190 100 167 43 180 8 70
# 11 24 210 177 81 243 8 112
# 97 195 203 47 125 114 165 181
# 193 70 174 167 41 30 127 245
# 87 149 57 192 65 129 178 228]
# B = DCT2(A)
# # println("DCT2\n", B)

# for i = eachindex(B[:, 1])
#     println(B[i, :])
# end

# println("Fast DCT\n", FFTW.dct(A))

# generate a random matrix
sizes_matrix = [10, 20, 40, 80, 160, 320, 640]
n_iter = 10

for i in sizes_matrix
    local times_custum = []
    local times_fft = []

    for k in 1:n_iter
        local A = rand(i, i)
        local time_custum = @elapsed begin DCT2(A) end
        local time_fft = @elapsed begin FFTW.dct(A) end
        println("Size: ", i, " Custom: ", time_custum, " FFT: ", time_fft)

        push!(times_custum, time_custum)
        push!(times_fft, time_fft)
    end

    local std_custum = std(times_custum)
    local std_fft = std(times_fft)

    local mean_custum = mean(times_custum)
    local mean_fft = mean(times_fft)

    local results = Dict("custom_mean" => mean_custum, 
                    "custom_std" => std_custum,
                    "fft_mean" => mean_fft,
                    "fft_std" => std_fft,
                    "sizes" => i)

    open("./results_2/"*string(i)*"_dct2.json", "w") do f
        write(f, JSON.json(results))
    end

    println()
end
