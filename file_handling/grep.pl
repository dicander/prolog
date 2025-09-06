:- initialization(main, main).
:- use_module(library(readutil)).   % read_line_to_string/2

main :-
    current_prolog_flag(argv, Argv),
    ( Argv = [PatAtom|Files0] ->
        atom_string(PatAtom, Pat),
        ( Files0 == [] -> Files = ['-'] ; Files = Files0 ),
        ( Files = [_]  -> ShowFile = false ; ShowFile = true ),
        grep_files(Files, Pat, ShowFile, Matched),
        ( Matched == true -> halt(0) ; halt(1) )
    ; usage, halt(2)
    ).

usage :-
    format(user_error, 'Usage: swipl -q -s grep.pl -- PATTERN [FILE ...]~n', []).

grep_files([], _, _, false).
grep_files([F|Fs], Pat, ShowFile, Any) :-
    grep_one(F, Pat, ShowFile, M1),
    grep_files(Fs, Pat, ShowFile, M2),
    ( (M1 == true ; M2 == true) -> Any = true ; Any = false ).

grep_one('-', Pat, ShowFile, Matched) :- !,
    grep_stream(user_input, '(stdin)', Pat, ShowFile, Matched).
grep_one(File, Pat, ShowFile, Matched) :-
    catch(setup_call_cleanup(
            open(File, read, S, [type(text)]),
            grep_stream(S, File, Pat, ShowFile, Matched),
            close(S)),
          E, (format(user_error, 'grep: ~w: ~w~n', [File,E]), Matched=false)).

grep_stream(Stream, FileName, Pat, ShowFile, Matched) :-
    grep_loop(Stream, FileName, Pat, ShowFile, false, Matched).

grep_loop(Stream, FileName, Pat, ShowFile, Any0, Any) :-
    read_line_to_string(Stream, Line),
    ( Line == end_of_file ->
        Any = Any0
    ; ( sub_string(Line, _, _, _, Pat) ->
          ( ShowFile -> format('~w:', [FileName]) ; true ),
          format('~s~n', [Line]),
          Any1 = true
      ;   Any1 = Any0
      ),
      grep_loop(Stream, FileName, Pat, ShowFile, Any1, Any)
    ).
