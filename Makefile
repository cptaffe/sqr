
CFLAGS = -g

# compiling options
SRC = src/main.c
OBJ = $(SRC:.c=.o)
BIN = bin/sqr
LOG = log.txt # testing log

# man page
MAN = man/sqr.1

# installing options
INSTBIN = /usr/local/bin
INSTMAN = /usr/local/share/man/man1/

# make binary, test
all: $(BIN) test

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) -o $(BIN) $(OBJ)

clean:
	rm $(OBJ) $(BIN) $(LOG)

test:
	./test.sh ./$(BIN) $(LOG)

# install with proper permissions & ownership
install:
	install $(BIN) $(INSTBIN)
	install -m 644 $(MAN) $(INSTMAN)

remove:
	$(RM) $(INSTBIN)/$(notdir $(BIN))
	$(RM) $(INSTMAN)/$(notdir $(MAN))
