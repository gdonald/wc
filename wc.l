%{
int chars = 0;
int words = 0;
int lines = 0;
int numbs = 0;
%}

%%

[a-zA-Z]+            { words++; chars += strlen(yytext); }
[-+]?[0-9]*\.?[0-9]+ { numbs++; chars += strlen(yytext); }
\n                   { chars++; lines++;                 }
.                    { chars++;                          }

%%

int main(int argc, char **argv)
{
  yylex();
  printf("\n     lines     words   numbers     chars\n");
  printf("%10d%10d%10d%10d\n", lines, words, numbs, chars);
  return 0;
}
