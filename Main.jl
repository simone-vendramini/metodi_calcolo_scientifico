include("Utils.jl") 
include("MyLib.jl")

using DelimitedFiles
using Printf

path = "./data/"
matrix_names = ["spa1", "spa2", "vem1", "vem2"]
tols = [1e-4, 1e-6, 1e-8, 1e-10]


for name in matrix_names

    matrix = import_sparse_matrix(path * name * ".mtx")
    b = get_b(matrix)
    
    for tol in tols

        tol_str = @sprintf("%.0e", tol)

        println(name, " ", tol_str)
        println()

        writedlm("./results/" * name * "_" * tol_str * "_jacobi.txt", jacobi(matrix, b, tol))
        writedlm("./results/" * name * "_" * tol_str * "_gauss_seidel.txt", gauss_seidel(matrix, b, tol))
        writedlm("./results/" * name * "_" * tol_str * "_gradient.txt", gradient(matrix, b, tol))
        writedlm("./results/" * name * "_" * tol_str * "_conjugate_gradient.txt", conjugate_gradient(matrix, b, tol))

        println()
    end
end

# use @time to get statistics