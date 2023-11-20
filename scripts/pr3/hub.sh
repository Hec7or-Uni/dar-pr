#!/bin/bash

# Ruta a la carpeta que contiene los archivos .hub
folder_path="/ruta/a/tu/carpeta"

# Verificar si la carpeta existe
if [ ! -d "$folder_path" ]; then
    echo "La carpeta '$folder_path' no existe."
    exit 1
fi

# Bucle para procesar los archivos .hub en la carpeta
for file in "$folder_path"/*.hub; do
    if [ -f "$file" ]; then
        echo "Procesando archivo: $file"
        
        # Tu código para procesar el archivo .hub en segundo plano
        {
            while IFS= read -r line; do
                echo "Procesando línea: $line"
                
                # Dividir la línea en valores separados por espacios
                values=($line)
                
                # Bucle para procesar cada valor de la línea
                for val in "${values[@]}"; do
                    echo "Valor: $val"
                    # Aquí puedes realizar las acciones que necesites con cada valor
                    # Por ejemplo, ejecutar algún comando o realizar algún cálculo
                done
            done < "$file"
        } &
    else
        echo "No se encontraron archivos .hub en la carpeta."
    fi
done

# Esperar a que todos los procesos en segundo plano terminen
wait
