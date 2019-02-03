CC = clang
FLEX = flex
EXEC = wc
FLAGS = -std=c17 -O2

ifeq ($(shell uname),Darwin)
	LINKER = -ll
else
	LINKER = -lfl
endif

$(EXEC): lex.yy.c
	$(CC) $(FLAGS) $(LINKER) lex.yy.c -o $(EXEC)

lex.yy.c: wc.l
	$(FLEX) wc.l

clean:
	rm -f $(EXEC) lex.yy.c *~
