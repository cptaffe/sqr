
CFLAGS = -g

SRC = main.c
OBJ = $(SRC:.c=.o)
BIN = sqr

# make binary, test
all: $(BIN) test

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) -o $(BIN) $(OBJ)

clean:
	rm $(OBJ) $(BIN)

test:
	./test.sh $(BIN)
