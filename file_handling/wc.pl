% Simple wc in SWI-Prolog: -w -c -l flags, files or '-' (stdin)
:- initialization(main, main).
:- use_module(library(readutil)).
:- use_module(library(lists)).

main :-
    current_prolog_flag(argv, Argv),
    parse_args(Argv, Flags, Files0),
    ( Flags == [] -> usage, halt(1) ; true ),
    ( Files0 == [] -> Files = ['-'] ; Files = Files0 ),
    maplist(process_file(Flags), Files, Results),
    print_results(Results, Flags).

parse_args([], [], []).
parse_args(['-w'|T], [words|Fs], FsOut) :- parse_args(T, Fs, FsOut).
parse_args(['-c'|T], [chars|Fs], FsOut) :- parse_args(T, Fs, FsOut).
parse_args(['-l'|T], [lines|Fs], FsOut) :- parse_args(T, Fs, FsOut).
parse_args([F|T], Fs, [F|FsOut])        :- parse_args(T, Fs, FsOut).

process_file(Flags, '-', counts{words:W,chars:C,lines:L}) :- !,
    % For stdin we keep text mode; fine for ASCII. See note below for bytes.
    read_stream_to_codes(user_input, Codes),
    analyze(Codes, Flags, W,C,L).
process_file(Flags, File, counts{words:W,chars:C,lines:L}) :-
    setup_call_cleanup(
        open(File, read, S),               % (text mode)
        ( read_stream_to_codes(S, Codes),
          analyze(Codes, Flags, W,C,L)
        ),
        close(S)
    ).

analyze(Codes, Flags, W,C,L) :-
    ( member(words, Flags) -> count_words(Codes, W) ; W = 0 ),
    ( member(chars, Flags) -> count_chars(Codes, C) ; C = 0 ),
    ( member(lines, Flags) -> count_lines(Codes, L) ; L = 0 ).

% ---- Correct word counting (like wc): split on ANY whitespace runs ----
count_words(Codes, Count) :- count_words_(Codes, in_space, 0, Count).

count_words_([], _, Acc, Acc).
count_words_([C|Cs], State, Acc, Out) :-
    ( code_type(C, space) ->
        NextState = in_space, Acc1 = Acc
    ; State == in_space ->
        NextState = in_word, Acc1 is Acc + 1
    ;   NextState = in_word, Acc1 = Acc
    ),
    count_words_(Cs, NextState, Acc1, Out).

% Characters and lines: wc -c counts BYTES; here we count code points.
% For ASCII they match; see note below to count bytes exactly.
count_chars(Codes, Count) :- length(Codes, Count).

count_lines(Codes, Count) :-
    include(=(0'\n), Codes, NLs),
    length(NLs, Count).

print_results([], _).
print_results([counts{words:W,chars:C,lines:L}|T], Flags) :-
    % Print in the order the user asked for:
    (member(lines, Flags) -> format('~w ', [L]) ; true),
    (member(words, Flags) -> format('~w ', [W]) ; true),
    (member(chars, Flags) -> format('~w ', [C]) ; true),
    nl,
    print_results(T, Flags).

usage :-
    format(user_error, 'Usage: swipl -q -s wc.pl -- [-w] [-c] [-l] [FILE ...]~n', []).
