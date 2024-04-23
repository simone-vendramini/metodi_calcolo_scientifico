module utils 

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


end