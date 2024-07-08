include("Utils.jl") 
include("MyLib.jl")
using Dash, Base64, ImageView, Images
using FFTW
using Statistics
using JSON

app = dash()

app.layout = html_div() do
    html_h2("Inserisci due valori interi e carica un'immagine:"),
    html_div(
        children = [
            "Dimensione della finestra: ",
            dcc_input(id = "input-1", type = "number"),
            html_br(),
            "Taglio delle frequenze: ",
            dcc_input(id = "input-2", type = "number"),
            html_br(),
            "Carica immagine: ",
            dcc_upload(id = "upload-image", children = html_button("Carica File")),
            html_br(),
            html_div(id = "output-1"),
            html_div(id = "output-2"),
            html_div(id = "output-image-path")
        ]
    )
end

callback!(app, Output("output-1", "children"), Input("input-1", "value")) do f
    f != nothing ? "Dimensione della finestra: $(f)" : "Dimensione della finestra: Nessun valore inserito"
end

callback!(app, Output("output-2", "children"), Input("input-2", "value")) do d
    d != nothing ? "Taglio delle frequenze: $(d)" : "Taglio delle frequenze: Nessun valore inserito"
end

callback!(app, Output("output-image-path", "children"),
    [Input("upload-image", "contents"), Input("input-1", "value"), Input("input-2", "value")]) do contents, f, d
    if contents != nothing && f != nothing && d != nothing
        try
            # Decode and save the uploaded image
            img_data = Base64.base64decode(split(contents, ",")[2])
            temp_filename = "temp_image.bmp"
            open(temp_filename, "w") do file
                write(file, img_data)
            end
            
            # Load and process the image
            img = load(temp_filename)
            img_gray = Gray.(img)
            imshow(img_gray, name="Original Image")
            
            blocks = split_image_into_blocks(img_gray, f)
            ff = image_compress(blocks, d)
            height, width = size(img_gray)
            height = Int(floor(height/f) * f)
            width = Int(floor(width/f) * f)
            ff_img = reassemble_from_blocks(ff, height, width, f)
            ff_img = Gray{N0f8}.(ff_img)
            imshow(ff_img, name="Compressed Image")

            return "Immagine processata e visualizzata."
            
        catch e
            println("Errore durante il processamento dell'immagine: $e")
            return "Errore durante il processamento dell'immagine."
        end
    else
        return "Valori mancantii o immagine non caricata."
    end
end

run_server(app, "0.0.0.0", debug=true)
