#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "fileservice.h"

void writeToFile(const char* filename, const char* content) {
    char outputFilePath[100];
    snprintf(outputFilePath, sizeof(outputFilePath), "output/%s", filename);

    FILE* file = fopen(outputFilePath, "w");
    if (file == NULL) {
        printf("Failed to open file.\n");
        return;
    }
    fprintf(file, "%s", content);
    fclose(file);
}