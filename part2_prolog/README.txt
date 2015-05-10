               João Ramos e Pedro Paredes
   --------------------------------------------------------

Para utilizar os códigos em Prolog iniciar o yap:
$ yap

E consultar cada um dos ficheiros:
[synt_gen, synt_gen_parse, bd].

Os predicados a usar estão indicados no relatório (sentenca/2, sentenca/3).

Para correr o código C, compilar primeiro com:
$ swipl-ld -o main main.c synt gen.pl synt gen parse.pl bd.pl

E correr o ficheiro resultante:
$ ./main
