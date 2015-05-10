               João Ramos e Pedro Paredes
   --------------------------------------------------------

Para utilizar os códigos em Prolog iniciar o yap:
$ yap

E consultar cada um dos ficheiros:
[main, bd].

Os predicados a usar estão indicados no relatório (directflight/3, route/4, visit/4).

Para correr o código C, compilar primeiro com:
$ swipl-ld -o main main.c main.pl bd.pl

E correr o ficheiro resultante:
$ ./main
