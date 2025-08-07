:- use_module(library(readutil)).

collatz_iteration(Iteration, N) :-
    (N =:= 1 ->
        halt
    ;
        (N /\ 1 =:= 0 ->
            NextN is N // 2
        ;
            NextN is 3 * N + 1
        ),
        format("~|~t~d~10+ : ~d", [Iteration, NextN]),
        nl,
        collatz_iteration(Iteration + 1, NextN)
    ).

main :-
    format("~|~t~d~10+ : ", [0]),
    read_line_to_string(user_input, Input),
    number_string(N, Input),
    (integer(N) ->  
        (N > 0 ->
            collatz_iteration(1, N)
        ;
            format("Please enter a positive, non-zero integer.~n"),
            main
        )
        ;
        format("Please enter an integer.~n"),
        main
    ).    

:- initialization(main, main).