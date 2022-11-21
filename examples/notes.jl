"""
    leer_bin(io::IO, ::Type{T}, n::Int64; close_file=true) where T

### Entrada

- `io`        -- archivo a leer, normalmente el resultado de una llamada a `open(..., "r")`
- `T`         -- tipo de datos que se va a leer
- `n`         -- cantidad de datos del tipo `T` que se van a leer
- `cerrar`    -- (opcional, valor por defecto: `true`) utilizar para cerrar el archivo al terminar de leer los datos

### Salida

Un vector de largo `n` y tipo de datos `T`.

### Notas

Si se van a efectuar varias lecturas del mismo archivo, se debe utilizar `close_file=false`.
"""
function leer_bin(io::IO, ::Type{T}, n::Int64; cerrar=true) where {T}

    # vector de salida
    x = Vector{T}(undef, n)

    # leer datos
    for i in eachindex(x)
        x[i] = read(io, T)
    end

    # opcionalmente, cerrar el archivo de entrada
    if cerrar
        close(io)
    end

    return x
end


"""
    leer_datos(archivo::String; num_datos=26990, num_muestras=64)

Leer datos de presión de túnel de viento.

### Entrada

- `archivo`      -- cadena de caracteres con el nombre del archivo a leer, por ejemplo `"SCAN001.DAT"`
- `num_datos`    -- (opcional, valor por defecto: 26990) cantidad de datos tomados por cada sensor
- `num_muestras` -- (opcional, valor por defecto: 64) cantidad de muestras o sensores

### Salida

Matriz de floats donde cada columna se correspnode con la serie temporal asociada a un sensor dado.

### Notas

La implementación se basa en el codigo de Matlab `JOY_E.m`.
"""
function leer_datos(archivo::String; num_datos=100, num_muestras=1, Nin=UInt8, Nout=UInt8)

    io = open(archivo, "r")

    salida = Matrix{Nout}(undef, num_datos, num_muestras)

    for i in 1:num_datos
        #basura = leer_bin(io, UInt8, 4, cerrar=false)
        batch = leer_bin(io, Nin, num_muestras, cerrar=false)
        salida[i, :] = batch
    end

    # cerrar archivo al salir
    close(io)

    return salida
end


data = leer_datos(bagfile, num_datos=50, num_muestras=1)
print(data)