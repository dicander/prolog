main :-
    write('Hello, Prolog!'), nl,
    member(X, [1,2,3]),
    format('X = ~w~n', [X]),
    fail.      % För att visa alla lösningar
main.
:- initialization(main, main).