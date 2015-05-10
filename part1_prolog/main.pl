:- op(50, xfy, :).
:- use_module(library(lists)).

% flight(+,+,?,-,-,-)
flight(Place1, Place2, Day, Fnum, Deptime, Arrtime) :-
    timetable(Place1, Place2, Flights),
    member(Deptime/Arrtime/Fnum/Days, Flights),
    traveldays(Days, Day).

% travelDay(+, -)
traveldays(Days, Day) :- member(Day, Days).
traveldays(alldays, Day) :- member(Day, [mo, tu, we, th, fr, sa, su]).

% deptime(+, -)
deptime(_-_:_:Time, Time).

% transfer(+, +)
transfer(H1:M1, H2:M2) :- 60 * H1 + (M1 + 39) < 60 * H2 + M2.

% route(+, +, ?, -)
route(Place1, Place2, Day, Route) :- routeaux(Place1, Place2, Day, Route, -1:00).
routeaux(Place, Place, _, [], _).
routeaux(Place1, Place2, Day, [Place1-Placei:Fnumi:Deptimei|Xs], Arrtimej) :-
    flight(Place1, Placei, Day, Fnumi, Deptimei, Arrtimei),
    transfer(Arrtimej, Deptimei),
    routeaux(Placei, Place2, Day, Xs, Arrtimei).

% directflight(+, +, -)
directflight(Place1, Place2, Day) :-
    traveldays(alldays, Day),
    flightaux(Place1, Place2, Day).

flightaux(Place1, Place2, Day) :- flight(Place1, Place2, Day, _, _, _), !.

nextday(mo, tu).
nextday(tu, we).
nextday(we, th).
nextday(th, fr).
nextday(fr, sa).
nextday(sa, su).
nextday(su, mo).

remove(X, [X|Tail], Tail) :- !.
remove(X, [Y|Tail], [Y|Tail1]) :-
    remove(X, Tail, Tail1).

%visit(+, +, +, -)
visit(Placei, Day, Destlist, Route) :- visitaux(Placei, Placei, Day, Destlist, Route).

visitaux(Placef, Placei, Day, [], [Placei-Placef:Fnum:Day:Deptime]) :-
    flight(Placei, Placef, Day, Fnum, Deptime, _).
visitaux(Placef, Placei, Day, DXs, [Placei-Nextdest:Fnumi:Day:Deptimei|RXs]) :-
    member(Nextdest, DXs),
    flight(Placei, Nextdest, Day, Fnumi, Deptimei, _),
    nextday(Day, Nday),
    remove(Nextdest, DXs, NDXs),
    visitaux(Placef, Nextdest, Nday, NDXs, RXs).
