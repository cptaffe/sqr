
CFLAGS = -g --std=c99

# compiling options
SRC = src/main.c
OBJ = $(SRC:.c=.o)
BIN = bin/sqr
LOG = log.txt # testing log

# man page
MAN = man/sqr.1

# installing options
INSTBIN = $(INSTALL)/usr/bin
INSTMAN = $(INSTALL)/usr/share/man/man1/

# make binary, test
all: $(BIN) test

$(BIN): $(OBJ)
	mkdir -p $(dir $(BIN))
	$(CC) $(CFLAGS) -o $(BIN) $(OBJ)

clean:
	rm $(OBJ) $(BIN) $(LOG)

test:
	./test.sh ./$(BIN) $(LOG)

# install with proper permissions & ownership
install:
	mkdir -p $(INSTMAN) $(INSTBIN)
	install $(BIN) $(INSTBIN)
	install -m 644 $(MAN) $(INSTMAN)

# uninstalls installed files
remove:
	$(RM) $(INSTBIN)/$(notdir $(BIN))
	$(RM) $(INSTMAN)/$(notdir $(MAN))
