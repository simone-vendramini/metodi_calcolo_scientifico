include("Utils.jl") 

using SparseArrays
using LinearAlgebra

function jacobi(A, b, tol=1e-4, max_iter=20000)

    println("Jacobi")

    x = zeros(size(A, 1))                         # x = zeros vector        
    
    P = spdiagm(0 => 1.0 ./ diag(A))              # P = inverse diagonal matrix
    last_iter = 0
    for k = 1:max_iter

        r = b - A * x                             # calculate residual
        x = x + P * r                             # update x

        if norm(r)/norm(b) < tol                  # check convergence
            last_iter = k
            break
        end

    end

    return x, last_iter

end

function gauss_seidel(A, b, tol=1e-4, max_iter=20000)

    println("Gauss Seidel")

    x = zeros(size(A, 1))                        # x = zeros vector

    P = tril(A)                                  # P = lower triangular matrix
    N = P - A                                    # N = negative upper triangular matrix with diagonal zero
    last_iter = 0
    for k = 1:max_iter

        r = b - A * x                             # calculate residual
        y = forward_substitution(P, r)            # solve Py = r
        x = x + y                                 # update x

        if norm(r)/norm(b) < tol                  # check convergence
            last_iter = k
            break
        end

    end

    return x, last_iter

end

function gradient(A, b, tol=1e-4, max_iter=20000)
    println("Gradient")

    x = zeros(size(A, 1))                         # x = zeros vector
    last_iter = 0

    for k = 1:max_iter

        r = b - A * x                             # calculate residual
        alpha = dot(r, r) / dot(r, A * r)         # calculate step size
        x = x + alpha * r                         # update x

        if norm(r)/norm(b) < tol                  # check convergence
            last_iter = k
            break
        end

    end

    return x, last_iter

end

function conjugate_gradient(A, b, tol=1e-4, max_iter=20000)
    println("Conjugate Gradient")

    x = zeros(size(A, 1))                         # x = zeros vector

    d = b - A * x                                 # initial search direction
    last_iter = 0

    for k = 1:max_iter

        r = b - A * x                             # calculate residual
        alpha = dot(d, r) / dot(d, A * d)         # calculate step size for x
        x = x + alpha * d                         # update x

        r_k = b - A * x                             # update residual
        beta = dot(d, A * r_k) / dot(d, A * d)      # calculate step size for search direction
        d = r_k - beta * d                          # update search direction

        if norm(r)/norm(b) < tol                  # check convergence
            last_iter = k
            break
        end

    end

    return x, last_iter

end

function DCT1(v)

    N = length(v)
    a = zeros(N)
    
    for k = 1:N
        for i = 1:N
            a[k] = a[k] + v[i] * cos((pi * (k - 1)) * ( 2 * (i - 1) + 1) / (2 * N))
        end
        if k == 1
            a[k] = a[k] * sqrt(1 / N)
        else
            a[k] = a[k] * sqrt(2 / N)
        end
    end

    return a

end

function DCT2(A)
    
    N = size(A, 1)
    M = size(A, 2)

    B = zeros(N, M)

    for n = 1:N
        B[n, :] = DCT1(A[n, :])
    end

    for m = 1:M
        B[:, m] = DCT1(B[:, m])
    end

    return B

end