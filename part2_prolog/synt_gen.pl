:- use_module(library(apply)).

sentenca(S, _) :- frase_valida(S).
frase_valida(S) :- maplist(downcase_atom, S, S2), frase_comp(S2, []).

frase_comp --> frase_s.
frase_comp --> frase_s, conj, frase_comp.

frase_s --> grupo_nom(G, N), grupo_verb(G, N).
frase_s --> grupo_verb(G, N).

grupo_nom(G, N) --> grupo_nom_s(G, N).
grupo_nom(G, N) --> pron(G, N).
grupo_nom(G, N) --> grupo_nom_s(G, N), grupo_adj(G, N).
grupo_nom(G, N) --> grupo_nom_s(G, N), grupo_prep(G2, N2).
grupo_nom(G, N) --> grupo_nom_s(G, N), grupo_adj(G, N), grupo_prep(G2, N2).

grupo_nom_s(G, N) --> deter(G, N), subst(G, N).
grupo_nom_s(G, N) --> subst(G, N).

grupo_prep(G, N) --> prep, grupo_nom(G, N).

grupo_adj(G, N) --> advrb(G, N), grupo_adj(G, N).
grupo_adj(G, N) --> adj(G, N).

grupo_verb(_, N) --> verbo(N, intr).
grupo_verb(_, N) --> verbo(N, tra_d), grupo_nom(G2, N2).
grupo_verb(_, N) --> verbo(N, tra_i), prep, grupo_nom(G2, N2).
grupo_verb(_, N) --> verbo(N, tra_i), prep_pro(G2, N2).
grupo_verb(_, N) --> verbo(N, tra_i), prep_det(G2, N2), subst(G2, N2).

subst(G, N) --> [A], {database(A, subst(G, N))}.
pron(G, N) --> [A], {database(A, pron(G, N))}.
deter(G, N) --> [A], {database(A, deter(G, N))}.
adj(G, N) --> [A], {database(A, adj(G, N))}.
advrb(G, N) --> [A], {database(A, advrb(G, N))}.
verbo(N, T) --> [A], {database(A, verbo(N, I)), database(I, verbo_inf(T))}.
prep --> [A], {database(A, prep)}.
prep_det(G, N) --> [A], {database(A, prep_det(G, N))}.
prep_pro(G, N) --> [A], {database(A, prep_pro(G, N))}.
conj --> [A], {database(A, conj)}.
