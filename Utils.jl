using SparseArrays

function import_matrix(path)
    open(path) do file
        s = readline(file)
        rows, cols, value = split(s, "  ")
        rows = parse(Int32, rows)
        cols = parse(Int32, cols)
        value = parse(Int32, value)
        
        matrix = zeros(rows, cols)
        for line in eachline(file)
            i, j, v = split(line, "  ")
            i = parse(Int32, i)
            j = parse(Int32, j)
            v = parse(Float64, v)
            matrix[i, j] = v
        end
        return matrix
    end
end

function import_sparse_matrix(path)
    open(path) do file
        s = readline(file)
        rows, cols, value = split(s, "  ")
        rows = parse(Int32, rows)
        cols = parse(Int32, cols)
        value = parse(Int32, value)
        
        matrix = spzeros(rows, cols)
        for line in eachline(file)
            i, j, v = split(line, "  ")
            i = parse(Int32, i)
            j = parse(Int32, j)
            v = parse(Float64, v)
            matrix[i, j] = v
        end
        return matrix
    end
end

function get_pivot(U, typePivot, k)
    n = size(U, 1)
    pivot = k
    if typePivot == "partial"
        max = abs(U[k, k])
        for i = k+1:n
            if abs(U[i, k]) > max
                max = abs(U[i, k])
                pivot = i
            end
        end
    end
    if typePivot == "total"
        max = abs(U[k, k])
        for i = k+1:n
            for j = k+1:n
                if abs(U[i, j]) > max
                    max = abs(U[i, j])
                    pivot = i
                end
            end
        end
    end
    return pivot
end

function get_b(A)
    x = ones(size(A, 1))
    b = A*x
    return b
end

function forward_substitution(A, b)
    n = size(A, 1)                              # n = number of rows
    x = zeros(n)
    x[1] = b[1]/A[1, 1]                         # first element
    for i = 2:n
        x[i] = b[i]                             # x[i] = b[i] - sum(A[i, j]*x[j])/A[i, i]
        for j = 1:i-1
            x[i] -= A[i, j]*x[j]
        end
        x[i] /= A[i, i]
    end
    return x
end

function meg(A, b, typePivot="partial")

    println("MEG")

    n = size(A, 1)                              # n = number of rows
    U = A                                       # U = A 
    b1 = b                                      # b1 = b

    for k = 1:n-1
        s = get_pivot(U, typePivot, k)          # get pivot
        if s != k
            U[[k, s], :] = U[[s, k], :]         # swap rows
            b1[[k, s]] = b1[[s, k]]
        end
        for i = k+1:n
            m = U[i, k]/U[k, k]                 # multiplier
            U[i, k] = 0                     
            for j = k+1:n
                U[i, j] = U[i, j] - m*U[k, j]   # update matrix
            end
            b1[i] = b1[i] - m*b1[k]
        end        
    end

end

function split_image_into_blocks(img, f)
    
    # Ottieni le dimensioni dell'immagine
    height, width = size(img)

    height = Int(floor(height/f)*f)
    width = Int(floor(width/f)*f)
    
    # Prepara un array per contenere i blocchi
    blocks = []

    # Itera sui blocchi
    for i in 0:f:width-f
        for j in 0:f:height-f
            # Estrai il blocco dall'immagine
            block = view(img, j+1:j+f, i+1:i+f)
            push!(blocks, block)
        end
    end
    
    return blocks
end

function image_compress(blocks, d)
    ff_compressed = []
    for block in blocks
        block = Float64.(Array(block))
        cc = FFTW.dct(block)

        for j in 1:size(cc)[1]
            for k in 1:size(cc)[2]
                if j + k >= d
                    cc[j, k] = 0
                end
            end
        end

        ff = FFTW.idct(cc)
        # ff = round.(ff)
        ff = clamp.(ff, 0, 1)
        push!(ff_compressed, ff)
    end

    return ff_compressed
end

function reassemble_from_blocks(blocks, height, width, block_size)
    h = Int(height)
    w = Int(width)
    reassembled_image = zeros(Gray, h, w)
    block_index = 1
    for j in 1:block_size:w
        for i in 1:block_size:h
        
            block = blocks[block_index]
            block_h, block_w = size(block)
            reassembled_image[i:i+block_h-1, j:j+block_w-1] .= block
            block_index += 1
        end
    end
    return reassembled_image
end