include("Utils.jl") 
using .utils

spa1 = "./data/spa1.mtx"
sparse_matrix = @time utils.import_sparse_matrix(spa1)
matrix = @time utils.import_matrix("./data/spa1.mtx")

println(sizeof(sparse_matrix))
println(sizeof(matrix))