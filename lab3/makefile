CC=gcc
CFLAGS=-Iinclude

all: build/main

build/main: build/main.o build/combiner.o build/fileservice.o
	$(CC) -o build/main build/main.o build/combiner.o build/fileservice.o

build/main.o: src/main.c include/combiner.h include/fileservice.h
	$(CC) -c src/main.c -o build/main.o $(CFLAGS)

build/combiner.o: src/combiner.c include/combiner.h
	$(CC) -c src/combiner.c -o build/combiner.o $(CFLAGS)

build/fileservice.o: src/fileservice.c include/fileservice.h
	$(CC) -c src/fileservice.c -o build/fileservice.o $(CFLAGS)

clean:
	rm -f build/*.o build/main

start: build/main
	./build/main