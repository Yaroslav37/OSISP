#include "combiner.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char* generate_string(char* pattern, char* prefix) {
    if (pattern[0] == '\0') {
        return strdup(prefix);
    } else if (pattern[0] == '[') {
        char* end = strchr(pattern, ']');
        char* result = malloc(256);
        result[0] = '\0';
        for (char* ch = pattern + 1; ch != end; ++ch) {
            char new_prefix[256];
            strcpy(new_prefix, prefix);
            strncat(new_prefix, ch, 1);
            char* generated_string = generate_string(end + 1, new_prefix);
            strcat(result, generated_string);
            strcat(result, "\n"); // Add newline character
            free(generated_string);
        }
        return result;
    } else if (pattern[1] == '?') {
        char new_prefix[256];
        strcpy(new_prefix, prefix);
        strncat(new_prefix, pattern, 1);
        char* result1 = generate_string(pattern + 2, new_prefix);
        char* result2 = generate_string(pattern + 2, prefix);
        char* result = malloc(strlen(result1) + strlen(result2) + 2); // Increase size for newline character
        strcpy(result, result1);
        strcat(result, "\n"); // Add newline character
        strcat(result, result2);
        free(result1);
        free(result2);
        return result;
    } else {
        char new_prefix[256];
        strcpy(new_prefix, prefix);
        strncat(new_prefix, pattern, 1);
        return generate_string(pattern + 1, new_prefix);
    }
}

void print_string(char* str) {
    printf("%s\n", str);
}