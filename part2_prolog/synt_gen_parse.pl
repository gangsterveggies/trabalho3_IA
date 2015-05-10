:- use_module(library(apply)).

sentenca(Pt, S, _) :- frase_valida(Pt, S).
frase_valida(Pt, S) :- maplist(downcase_atom, S, S2), frase_comp(Pt, S2, []).

frase_comp(frase_complexa(FS)) --> frase_s(FS).
frase_comp(frase_complexa(FS, C, FC)) --> frase_s(FS), conj(C), frase_comp(FC).

frase_s(frase_simples(GN, GV)) --> grupo_nom(GN, G, N), grupo_verb(GV, G, N).
frase_s(frase_simples(GV)) --> grupo_verb(GV, G, N).

grupo_nom(grupo_nominal(GNS), G, N) --> grupo_nom_s(GNS, G, N).
grupo_nom(grupo_nominal(P), G, N) --> pron(P, G, N).
grupo_nom(grupo_nominal(GNS, GA), G, N) --> grupo_nom_s(GNS, G, N), grupo_adj(GA, G, N).
grupo_nom(grupo_nominal(GNS, GP), G, N) --> grupo_nom_s(GNS, G, N), grupo_prep(GP, G2, N2).
grupo_nom(grupo_nominal(GNS, GA, GP), G, N) --> grupo_nom_s(GNS, G, N), grupo_adj(Ga, G, N), grupo_prep(GP, G2, N2).

grupo_nom_s(grupo_nominal_simples(D, S), G, N) --> deter(D, G, N), subst(S, G, N).
grupo_nom_s(grupo_nominal_simples(S), G, N) --> subst(S, G, N).

grupo_prep(grupo_preposicional(P, GN), G, N) --> prep(P), grupo_nom(GN, G, N).

grupo_adj(grupo_adjetival(Adv, GA), G, N) --> advrb(Adv, G, N), grupo_adj(GA, G, N).
grupo_adj(grupo_adjetival(Adj), G, N) --> adj(Adj, G, N).

grupo_verb(grupo_verbal(V), _, N) --> verbo(V, N, intr).
grupo_verb(grupo_verbal(V, GN), _, N) --> verbo(V, N, tra_d), grupo_nom(GN, G2, N2).
grupo_verb(grupo_verbal(V, P, GN), _, N) --> verbo(V, N, tra_i), prep(P), grupo_nom(GN, G2, N2).
grupo_verb(grupo_verbal(V, PP), _, N) --> verbo(V, N, tra_i), prep_pro(PP, G2, N2).
grupo_verb(grupo_verbal(V, PD, S), _, N) --> verbo(V, N, tra_i), prep_det(PD, G2, N2), subst(S, G2, N2).

subst(substantivo(A), G, N) --> [A], {database(A, subst(G, N))}.
pron(pronome(A), G, N) --> [A], {database(A, pron(G, N))}.
deter(determinante(A), G, N) --> [A], {database(A, deter(G, N))}.
adj(adjetivo(A), G, N) --> [A], {database(A, adj(G, N))}.
advrb(adverbio(A), G, N) --> [A], {database(A, advrb(G, N))}.
verbo(verbo(A), N, T) --> [A], {database(A, verbo(N, I)), database(I, verbo_inf(T))}.
prep(preposicao(A)) --> [A], {database(A, prep)}.
prep_det(preposicao_determinante(A), G, N) --> [A], {database(A, prep_det(G, N))}.
prep_pro(preposicao_pronome(A), G, N) --> [A], {database(A, prep_pro(G, N))}.
conj(conjugacao(A)) --> [A], {database(A, conj)}.
