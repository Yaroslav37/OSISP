#include <stdio.h>
#include <stdlib.h>
#include "combiner.h"
#include "fileservice.h"

int main() {
    char regex[100];
    char filename[100];
    printf("Enter the regular expression: ");
    scanf("%s", regex);
    printf("Enter the filename: ");
    scanf("%s", filename);
    char *result = generate_string(regex, "");
    writeToFile(filename, result);
    print_string(result);
    return 0;
}