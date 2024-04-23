module utils 

function import_matrix(path)
    open(path) do file
        s = readline(file)
        println(s)
    end
end


end