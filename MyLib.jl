include("Utils.jl") 

using SparseArrays
using LinearAlgebra

function jacobi(A, b, tol=1e-4, max_iter=20000)

    println("Jacobi")

    x = zeros(size(A, 1))                         # x = zeros vector        
    
    P = spdiagm(0 => 1.0 ./ diag(A))              # P = inverse diagonal matrix

    for k = 1:max_iter

        r = b -A * x                              # calculate residual
        x = x + P * r                             # update x

        if norm(r)/norm(b) < tol                  # check convergence
            break
        end

    end

    return x

end

function gauss_seidel(A, b, tol=1e-4, max_iter=20000)

    println("Gauss Seidel")

    x = zeros(size(A, 1))                         # x = zeros vector

    P = tril(A)                                  # P = lower triangular matrix
    N = P - A                                    # N = negative upper triangular matrix with diagonal zero

    for k = 1:max_iter

        r = b - A * x                             # calculate residual
        y = forward_substitution(P, r)            # solve Py = r
        x = x + y                                 # update x

        if norm(r)/norm(b) < tol                  # check convergence
            break
        end

    end

    return x

end

function gradient()
    println("Gradient")


end

function conjugate_gradient()
    println("Conjugate Gradient")
end

