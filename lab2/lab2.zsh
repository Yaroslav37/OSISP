#!/bin/zsh

print_help() {
    echo "Usage: ./lab2.zsh [matrix1] [matrix2] [operation]"
    echo "operation: The operation to perform on the matrices. Can be 'add', 'sub', or 'mul'."
    echo ""
    echo "Example: ./lab2.zsh matrix1.csv matrix2.csv add"
}

clean_matrix() {
    awk -F, '{
        for(i=1; i<=NF; i++) {
            if ($i ~ /[^0-9.]/ || $i == "") {
                $i = 0
            }
        }
    }1' OFS=, "$1" > cleaned_"$1"
}

add_matrices() {
    awk -F, 'NR==FNR{a[NR]=$0;next}{split(a[FNR],b,",");for(i=1;i<=NF;i++)$i=b[i]+$i}1' OFS=, cleaned_"$1" cleaned_"$2" > add_result.csv
}

subtract_matrices() {
    awk -F, 'NR==FNR{a[NR]=$0;next}{split(a[FNR],b,",");for(i=1;i<=NF;i++)$i=$i-b[i]}1' OFS=, cleaned_"$1" cleaned_"$2" > sub_result.csv
}

multiply_matrices() {
    awk -F, 'NR==FNR{a[NR]=$0;next}{split(a[FNR],b,",");for(i=1;i<=NF;i++)$i=b[i]*$i}1' OFS=, cleaned_"$1" cleaned_"$2" > mul_result.csv
}

clean_matrix "$1"
clean_matrix "$2"

if [ "$3" = "add" ]; then
    add_matrices "$1" "$2"
elif [ "$3" = "sub" ]; then
    subtract_matrices "$1" "$2"
elif [ "$3" = "mul" ]; then
    multiply_matrices "$1" "$2"
elif [ "$3" = "help" ]; then
    print_help
else
    echo "Invalid operation. Please choose 'add', 'sub', or 'mul'."
    print_help
fi
