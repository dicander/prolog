main :-
    repeat,                                 % Repeat forever until explicitly stopped
    read_line_to_string(user_input, Line),
    ( Line == end_of_file -> halt           % Check for EOF: stop repeating
    ; process_line(Line), fail              % Otherwise process, then fail to repeat
    ).

process_line(Line) :-
    string_to_int_list(Line, List),
    [A, B] = List,
    Diff is abs(A - B),
    writeln(Diff).

string_to_int_list(Str, IntList) :-
    split_string(Str, " ", "", StrList),
    maplist(number_string, IntList, StrList).