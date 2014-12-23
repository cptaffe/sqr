
CFLAGS = -g --std=c99

# compiling options
SRC = src/main.c
OBJ = $(SRC:.c=.o)
BIN = bin/sqr
LOG = log.txt # testing log

# man page
MAN = man/sqr.1

# installing options
INSTBIN = /usr/local/bin

ifeq ($(shell uname), Darwin)
	INSTMAN = /usr/local/share/man/man1/
else
	# default to Linux
	INSTMAN = /usr/local/man/man1/
endif

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
	install $(BIN) $(INSTBIN)
	install -m 644 $(MAN) $(INSTMAN)

# uninstalls installed files
remove:
	$(RM) $(INSTBIN)/$(notdir $(BIN))
	$(RM) $(INSTMAN)/$(notdir $(MAN))
