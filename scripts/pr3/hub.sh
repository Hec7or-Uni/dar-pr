#!/bin/bash

# Verificar si se proporciona un archivo como argumento
if [ $# -eq 0 ]; then
    echo "Por favor, proporciona un archivo como argumento."
    exit 1
fi

# Leer el archivo proporcionado como argumento
file="$1"

# Verificar si el archivo existe
if [ ! -f "$file" ]; then
    echo "El archivo '$file' no existe."
    exit 1
fi

# Bucle para procesar cada línea del archivo
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
