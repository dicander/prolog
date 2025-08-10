:- use_module(library(readutil)).
:- use_module(library(clpfd)).

% Pure, relational one-step Collatz relation.
% Works forward and (with search) backward.
collatz_next(In, Out) :-
    In #> 0, Out #> 0,
    (   In mod 2 #= 0, Out #= In div 2
    ;   In mod 2 #= 1, Out #= 3*In + 1
    ).
run_collatz(N0) :-
    run_collatz_(1, N0).

run_collatz_(Iter, 1) :-
    format("~|~t~d~10+ : ~d~n", [Iter, 1]).
run_collatz_(Iter, N) :-
    format("~|~t~d~10+ : ~d~n", [Iter, N]),
    collatz_next(N, N1),
    succ(Iter, Iter1),
    run_collatz_(Iter1, N1).


main :-
    format("~|~t~d~10+ : ", [0]),
    read_line_to_string(user_input, Input),
    (   number_string(N, Input),
        integer(N), N > 0 ->
        run_collatz(N)
    ;   format("Please enter a positive, non-zero integer.~n"),
        main
    ).


:- initialization(main, main).