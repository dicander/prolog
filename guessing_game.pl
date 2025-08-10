:- use_module(library(readutil)).

guessing_game_iteration(Lower, Upper, N_guesses) :-
    (Lower =:= Upper ->
        format("The number is ~d. You guessed it in ~d tries!~n", [Lower, N_guesses]),
        halt
    ;
        format("Please guess a number between ~d and ~d, including the endpoints: ", [Lower, Upper]),
        read_line_to_string(user_input, Input),
        number_string(Guess, Input),
        (integer(Guess) ->
            (Guess < Lower ->
                format("I already told you the value was above ~d. Take a penalty.~n", [Lower]),
                guessing_game_iteration(Lower, Upper, N_guesses + 1)
            ; 
                (Guess > Upper ->
                    format("I already told you the value was below ~d. Take a penalty.~n", [Upper]),
                    guessing_game_iteration(Lower, Upper, N_guesses + 1)
                ;
                    % Valid guess in range — shrink the interval
                    format("Good guess!~n"),
                    RightInterval is Upper - Guess + 1,
                    LeftInterval is Guess - Lower + 1,
                    (RightInterval < LeftInterval ->
                        NewUpper is Guess - 1,
                        guessing_game_iteration(Lower, NewUpper, N_guesses + 1)
                    ;
                        NewLower is Guess + 1,
                        guessing_game_iteration(NewLower, Upper, N_guesses + 1)
                    )
                )
            )
        ;
            format("That is not a valid integer. Take a penalty.~n"),
            guessing_game_iteration(Lower, Upper, N_guesses + 1)
        )
    ).



main :-
    format("Welcome to the guessing game!~n"),
    guessing_game_iteration(1, 10, 1).


:- initialization(main, main).