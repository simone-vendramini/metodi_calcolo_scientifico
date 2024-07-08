include("Utils.jl")
include("MyLib.jl")
using Dash, Base64, ImageView, Images
using FFTW
using Statistics
using JSON

app = dash()

app.layout = html_div(
    style = Dict("text-align" => "center", "font-family" => "Arial")
) do
    html_h2("Inserisci due valori interi e carica un'immagine:"),
    html_div(
        style = Dict("margin" => "auto", "width" => "50%"),
        children = [
            html_div(
                style = Dict("margin-bottom" => "20px"),
                children = [
                    "Dimensione della finestra: ",
                    dcc_input(id = "input-1", type = "number", style = Dict("margin-left" => "10px"))
                ]
            ),
            html_div(
                style = Dict("margin-bottom" => "20px"),
                children = [
                    "Taglio delle frequenze: ",
                    dcc_input(id = "input-2", type = "number", style = Dict("margin-left" => "10px"))
                ]
            ),
            html_div(
                style = Dict("margin-bottom" => "20px"),
                children = [
                    "Carica immagine: ",
                    dcc_upload(id = "upload-image", children = html_button("Carica File", style = Dict("margin-left" => "10px")))
                ]
            ),
            html_button("Elabora Immagine", id="process-button", style = Dict("margin-top" => "20px")),
            html_div(id = "output-message", style = Dict("margin-top" => "20px", "color" => "blue")),
            html_div(id = "output-image-path", style = Dict("margin-top" => "20px"))
        ]
    )
end

callback!(app, Output("output-message", "children"),
    Input("process-button", "n_clicks"),
    State("upload-image", "contents"),
    State("input-1", "value"),
    State("input-2", "value")
) do n_clicks, contents, f, d
    if n_clicks != nothing && contents != nothing && f != nothing && d != nothing
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
            height = Int(floor(height / f) * f)
            width = Int(floor(width / f) * f)
            ff_img = reassemble_from_blocks(ff, height, width, f)
            ff_img = Gray{N0f8}.(ff_img)
            imshow(ff_img, name="Compressed Image")

            return "Immagine processata e visualizzata."
            
        catch e
            println("Errore durante il processamento dell'immagine: $e")
            return "Errore durante il processamento dell'immagine."
        end
    else
        return "Valori mancanti o immagine non caricata."
    end
end

run_server(app, "0.0.0.0", debug=true)
