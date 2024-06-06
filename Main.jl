include("Utils.jl") 
include("MyLib.jl")

spa1 = "./data/spa1.mtx"
sparse_matrix = import_sparse_matrix(spa1)          # use @time to get statistics
# matrix = @time utils.import_matrix("./data/spa1.mtx")

b = get_b(sparse_matrix)

# println(b)

println(gauss_seidel(sparse_matrix, b))