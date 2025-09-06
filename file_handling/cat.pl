% This is a simple implementation of the Unix command cat in Prolog.
% Call this program with a parameter list of files to concatenate

% cat.pl — a tiny 'cat' in SWI-Prolog
:- use_module(library(readutil)).          % copy_stream_data/2
:- use_module(library(lists)).             % select/3

:- initialization(main, main).

main :-
    set_prolog_flag(debug_on_error, true), % helpful stacktraces
    current_prolog_flag(argv, Argv0),
    strip_dashdash(Argv0, Files),
    ( Files == [] ->
        usage, halt(1)
    ; maplist(cat_one, Files),
      halt(0)
    ).

strip_dashdash(['--'|Rest], Rest) :- !.
strip_dashdash(Files, Files).

cat_one('-') :- !,
    copy_stream_data(user_input, user_output).
cat_one(File) :-
    setup_call_cleanup(
        open(File, read, In, [type(text)]),
        copy_stream_data(In, user_output),
        close(In)
    ),
    !.
cat_one(File) :-
    % If open/3 threw, you won't reach here. This handles other failures.
    format(user_error, 'cat: ~w: failed~n', [File]),
    fail.

usage :-
    format(user_error, 'Usage: swipl -q -s cat.pl -- FILE...~n', []).
