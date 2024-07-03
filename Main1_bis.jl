include("Utils.jl") 
include("MyLib.jl")

using DelimitedFiles
using Printf
using Statistics
using JSON

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
        
        times_jacobi = []
        times_gauss_seidel = []
        times_gradient = []
        times_conjugate_gradient = []
        
        time_jacobi = @elapsed begin jacobi_result, jacobi_k_iter = jacobi(matrix, b, tol) end
        time_gauss_seidel = @elapsed begin gauss_seidel_result, gauss_k_iter = gauss_seidel(matrix, b, tol) end
        time_gradient = @elapsed begin gradient_result, gradient_k_iter = gradient(matrix, b, tol) end
        time_conjugate_gradient = @elapsed begin conjugate_gradient_result, conjugate_k_iter = conjugate_gradient(matrix, b, tol) end
        
        push!(times_jacobi, time_jacobi)
        push!(times_gauss_seidel, time_gauss_seidel)
        push!(times_gradient, time_gradient)
        push!(times_conjugate_gradient, time_conjugate_gradient)
        
        for i = 1:9
            time_jacobi = @elapsed begin jacobi(matrix, b, tol) end
            time_gauss_seidel = @elapsed begin gauss_seidel(matrix, b, tol) end
            time_gradient = @elapsed begin gradient(matrix, b, tol) end
            time_conjugate_gradient = @elapsed begin conjugate_gradient(matrix, b, tol) end

            push!(times_jacobi, time_jacobi)
            push!(times_gauss_seidel, time_gauss_seidel)
            push!(times_gradient, time_gradient)
            push!(times_conjugate_gradient, time_conjugate_gradient)
            
        end

        # std time
        std_jacobi = std(times_jacobi)
        std_gauss_seidel = std(times_gauss_seidel)
        std_gradient = std(times_gradient)
        std_conjugate_gradient = std(times_conjugate_gradient)

        # mean time
        mean_jacobi = mean(times_jacobi)
        mean_gauss_seidel = mean(times_gauss_seidel)
        mean_gradient = mean(times_gradient)
        mean_conjugate_gradient = mean(times_conjugate_gradient)

        results = Dict(
            "jacobi" => jacobi_result,
            "jacobi_mean" => mean_jacobi,
            "jacobi_std" => std_jacobi,
            "jacobi_k_iter" => jacobi_k_iter,
            "gauss_seidel" => gauss_seidel_result,
            "gauss_seidel_mean" => mean_gauss_seidel,
            "gauss_seidel_std" => std_gauss_seidel,
            "gauss_seidel_k_iter" => gauss_k_iter,
            "gradient" => gradient_result,
            "gradient_mean" => mean_gradient,
            "gradient_std" => std_gradient,
            "gradient_k_iter" => gradient_k_iter,
            "conjugate_gradient" => conjugate_gradient_result,
            "conjugate_gradient_mean" => mean_conjugate_gradient,
            "conjugate_gradient_std" => std_conjugate_gradient,
            "conjugate_gradient_k_iter" => conjugate_k_iter
        )

        open("./results_1bis/" * name * "_" * tol_str * "_results.json", "w") do f
            write(f, JSON.json(results))
        end

        println()
    end
end

# use @time to get statistics