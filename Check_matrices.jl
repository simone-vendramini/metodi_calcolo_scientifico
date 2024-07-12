include("Utils.jl")

path = "./data/"
matrix_names = ["spa1", "spa2", "vem1", "vem2"]

for name in matrix_names

    matrix = import_sparse_matrix(path * name * ".mtx")
    println(name)
    println("Simmetrica: " , is_symmetric(matrix))
    println("Definita positiva: " , is_positive_definite(matrix))
    println("Dominanza diagonale: " , is_diagonally_dominant(matrix))
    println("Numero di condizionamento: " , condition_number(matrix))
    println()

end