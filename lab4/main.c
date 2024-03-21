#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <string.h>
#include <time.h>

#define MAX_SIGNALS 10

void signalHandler(int signal) {
    FILE *file = fopen("/Users/minen/labs/lab4/logfile.txt", "a");
    if (file != NULL) {
        time_t now = time(NULL);
        char buffer[26];
        strftime(buffer, 26, "%Y-%m-%d %H:%M:%S", localtime(&now));
        fprintf(file, "%s: Received signal: %d (%s)\n", buffer, signal, strsignal(signal));
        fclose(file);
    }
}

void readSignalList(const char* filepath, int* signalList, int* numSignals) {
    FILE* file = fopen(filepath, "r");
    if (file != NULL) {
        char line[100];
        int count = 0;
        while (fgets(line, sizeof(line), file) != NULL && count < MAX_SIGNALS) {
            int signal = atoi(line);
            signalList[count] = signal;
            count++;
        }
        *numSignals = count;
        fclose(file);
    }
}

int main(int argc, char *argv[]) {
    const char* configFilePath = "./config.txt";
    int signalList[MAX_SIGNALS];
    int numSignals = 0;

    readSignalList(configFilePath, signalList, &numSignals);

    struct sigaction sa;
    sa.sa_handler = signalHandler;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;

    for (int i = 0; i < numSignals; i++) {
        sigaction(signalList[i], &sa, NULL);
    }

    pid_t pid = fork();
    if (pid < 0) {
        perror("fork");
        exit(1);
    } else if (pid > 0) {
        exit(0);
    }

    setsid();
    chdir("/");

    close(STDIN_FILENO);
    close(STDOUT_FILENO);
    close(STDERR_FILENO);

    while (1) {
        sleep(1);
    }

    return 0;
}