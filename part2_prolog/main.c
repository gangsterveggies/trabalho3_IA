#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <SWI-Prolog.h>

#define MAXLINE 1024

char str[MAXLINE];
char str2[MAXLINE];
char str3[MAXLINE];
char str4[MAXLINE];

void print_help()
{
  printf("What do you want to do next?\n\n");
  printf("\t1: Analyze a sentence;\n");
  printf("\t2: Analyze a sentence and print parse tree;\n");
  printf("\tother input: exit and close;\n");
}

int read_input()
{
  int res;
  scanf("%d", &res);
  return res;
}

void print_compound(term_t t)
{
  term_t ll = PL_new_term_ref();
  int arity, len, n;
  char *s;
  atom_t name;

  switch (PL_term_type(t))
  {
  case PL_VARIABLE:
  case PL_ATOM:
  case PL_INTEGER:
  case PL_FLOAT:
    PL_get_chars(t, &s, CVT_ALL);
    printf("%s", s);
    break;
  case PL_TERM:
    PL_get_name_arity(t, &name, &arity);
    printf("%s(", PL_atom_chars(name));

    for (n = 1; n <= arity; n++)
    {
      PL_get_arg(n, t, ll);
      print_compound(ll);

      if (n == arity)
        printf(")");
      else
        printf(", ");
    }

    break;
  }
}

void print_list(term_t inp)
{
  term_t head = PL_new_term_ref();
  term_t list = PL_copy_term_ref(inp);

  while (PL_get_list(list, head, list))
  {
    print_compound(head);
    printf("\n");
  }
}

void build_list(term_t l, int n, char** words)
{
  term_t a = PL_new_term_ref();
  PL_put_nil(l);

  while (n--)
  {
    PL_put_atom_chars(a, words[n]);
    PL_cons_list(l, a, l);
  }
}

void synt_parse_tree(char** sentence_list, int n_words)
{
  predicate_t pred = PL_predicate("sentenca", 3, "synt_gen_parse");
  term_t h0 = PL_new_term_refs(3);

  build_list(h0 + 1, n_words, sentence_list);
  PL_put_nil(h0 + 2);

  qid_t current_query = PL_open_query(NULL, PL_Q_NORMAL, pred, h0);

  if (PL_next_solution(current_query))
    print_compound(h0);

  PL_close_query(current_query);
}

void synt_analyze(char** sentence_list, int n_words, int print_parse)
{
  predicate_t pred = PL_predicate("sentenca", 2, "synt_gen");
  term_t h0 = PL_new_term_refs(2);

  build_list(h0, n_words, sentence_list);
  PL_put_nil(h0 + 1);

  qid_t current_query = PL_open_query(NULL, PL_Q_NORMAL, pred, h0);

  if (PL_next_solution(current_query))
  {
    printf("Valid sentence!\n");

    if (print_parse)
    {
      printf("\nParse tree:\n");
      synt_parse_tree(sentence_list, n_words);
    }
  }
  else
    printf("Invalid sentence...\n");

  PL_close_query(current_query);
}

void call_sentence(int print_parse)
{
  printf("Input an sentence in portuguese: \n");
  scanf(" %[^\n]", str);

  char** sentence_list = (char**) malloc(sizeof(char*));
  char* p = strtok(str, " ");
  int n = 0, i;

  while (p)
  {
    sentence_list = (char**) realloc(sentence_list, sizeof (char*) * ++n);
    sentence_list[n - 1] = p;

    p = strtok (NULL, " ");
  }

  sentence_list = realloc (sentence_list, sizeof (char*) * (n + 1));
  sentence_list[n] = 0;

  synt_analyze(sentence_list, n, print_parse);

  free(sentence_list);
}

int main(int argc, char **argv)
{
  char *program = argv[0];
  char *plav[2];

  /* make the argument vector for Prolog */

  plav[0] = program;
  plav[1] = NULL;

  /* initialise Prolog */

  if (!PL_initialise(1, plav))
    PL_halt(1);

  while (1)
  {
    print_help();
    int res = read_input(), exit_flag = 0;

    switch (res)
    {
    case 1:  
      call_sentence(0);
      break;
    case 2:
      call_sentence(1);
      break;
    default:
      exit_flag = 1;
    }

    if (exit_flag)
    {
      printf("\n\nThanks for using portuguese analyzer 1.4\n");
      printf("Copyright IA inc. 1999\n");
      break;
    }
    else
      printf("\n\n");
  }

  PL_halt(0);

  return 0;
}
