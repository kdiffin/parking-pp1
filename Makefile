dev:
	mkdir -p bin/ && gcc -o bin/parking main.c && ./bin/parking

clean:
	rm -rf bin/*
