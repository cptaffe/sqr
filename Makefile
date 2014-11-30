
CFLAGS = -g

SRC = main.c
OBJ = $(SRC:.c=.o)
BIN = sqr

all: $(BIN)
$(BIN): $(OBJ)
	$(CC) $(CFLAGS) -o $(BIN) $(OBJ)

clean:
	rm $(OBJ) $(BIN)
