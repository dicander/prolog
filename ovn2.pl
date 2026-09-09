append([],L,L).
append([H|T],L,[H|R]) :- 
    append(T,L,R).

select(X,[X|T],T).
select(X,[Y|T],[Y|R]) :- 
    select(X,T,R).

member(X,L) :- 
    select(X,L,_).
memberchk(X,L) :- 
    select(X,L,_), !.

removelast([_],[]).
removelast([H|T],[H|R]) :- 
    removelast(T,R).