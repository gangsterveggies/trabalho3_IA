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
  printf("\t1: Check what days can you fly from a location to another;\n");
  printf("\t2: Plan a one day travel route between two locations;\n");
  printf("\t3: Plan a trip starting and ending in a determined location an day, passing by a list of destinations (one per day);\n");
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

    for (n = 1; n <= arity; n++)
    {
      PL_get_arg(n, t, ll);
      print_compound(ll);

      if (n != arity)
        printf("%s", PL_atom_chars(name));
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

void direct_flight(char* source, char* dest)
{
  predicate_t pred = PL_predicate("directflight", 3, "main");
  term_t h0 = PL_new_term_refs(3);

  PL_put_atom_chars(h0, source);
  PL_put_atom_chars(h0 + 1, dest);

  qid_t current_query = PL_open_query(NULL, PL_Q_NORMAL, pred, h0);

  while (PL_next_solution(current_query))
  {
    char* s;
    if (PL_get_atom_chars(h0 + 2, &s))
      printf("%s ", s);
  }

  printf("\n");

  PL_close_query(current_query);
}

void call_direct_flight()
{
  printf("Input an initial location: ");
  scanf(" %s", str);

  printf("Input a final location: ");
  scanf(" %s", str2);

  direct_flight(str, str2);
}

char* convert_day(char* abr)
{
  strcpy(str4, abr);
  if (!strcmp(abr, "mo"))
    strcpy(str4, "monday");
  else if (!strcmp(abr, "tu"))
    strcpy(str4, "tuesday");
  else if (!strcmp(abr, "we"))
    strcpy(str4, "wednesday");
  else if (!strcmp(abr, "th"))
    strcpy(str4, "thursday");
  else if (!strcmp(abr, "fr"))
    strcpy(str4, "friday");
  else if (!strcmp(abr, "sa"))
    strcpy(str4, "saturday");
  else if (!strcmp(abr, "su"))
    strcpy(str4, "sunday");

  return str4;
}

void route(char* source, char* dest, char* day, int day_flag)
{
  predicate_t pred = PL_predicate("route", 4, "main");
  term_t h0 = PL_new_term_refs(4);

  PL_put_atom_chars(h0, source);
  PL_put_atom_chars(h0 + 1, dest);

  if (day_flag)
    PL_put_atom_chars(h0 + 2, day);

  qid_t current_query = PL_open_query(NULL, PL_Q_NORMAL, pred, h0);

  while (PL_next_solution(current_query))
  {
    char* s;

    if (!day_flag && PL_get_atom_chars(h0 + 2, &s))
      printf("On %s there is the following flight:\n", convert_day(s));

    print_list(h0 + 3);

    printf("Keep looking (Y/n)? ");
    scanf(" %s", str4);

    if (str4[0] == 'n')
      break;
  }

  printf("\n");

  PL_close_query(current_query);
}

void call_route()
{
  printf("Input an initial location: ");
  scanf(" %s", str);

  printf("Input a final location: ");
  scanf(" %s", str2);

  printf("Do you want to set a travel day (y/N)? ");
  scanf(" %s", str3);

  int day_flag = 0;
  if (str3[0] == 'y')
  {
    day_flag = 1;
    printf("Input the desired day: ");
    scanf(" %s", str3);
  }

  route(str, str2, str3, day_flag);
}

void visit(char* source, char* day, char** location_list, int n_dest)
{
  predicate_t pred = PL_predicate("visit", 4, "main");
  term_t h0 = PL_new_term_refs(4);

  PL_put_atom_chars(h0, source);
  PL_put_atom_chars(h0 + 1, day);

  build_list(h0 + 2, n_dest, location_list);

  qid_t current_query = PL_open_query(NULL, PL_Q_NORMAL, pred, h0);

  while (PL_next_solution(current_query))
  {
    print_list(h0 + 3);

    printf("Keep looking (Y/n)? ");
    scanf(" %s", str4);

    if (str4[0] == 'n')
      break;
  }

  printf("\n");

  PL_close_query(current_query);
}

void call_visit()
{
  printf("Input an initial location: ");
  scanf(" %s", str);

  printf("Input the start day: ");
  scanf(" %s", str2);

  int i, n;
  printf("Input the number of destinations: ");
  scanf("%d", &n);

  char** location_list = (char**) malloc(sizeof(char*) * n);

  for (i = 0; i < n; i++)
  {
    printf("Location #%d: ", i + 1);
    scanf(" %s", str3);

    location_list[i] = (char*) malloc(MAXLINE);
    strcpy(location_list[i], str3);
  }

  visit(str, str2, location_list, n);

  for (i = 0; i < n; i++)
    free(location_list[i]);
  free(location_list);
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
      call_direct_flight();
      break;
    case 2:
      call_route();
      break;
    case 3:
      call_visit();
    default:
      exit_flag = 1;
    }

    if (exit_flag)
    {
      printf("\n\nThanks for using flight planner 1.2\n");
      printf("Copyright IA inc. 1999\n");
      break;
    }
    else
      printf("\n");
  }

  PL_halt(0);

  return 0;
}
