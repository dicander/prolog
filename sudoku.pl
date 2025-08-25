:- use_module(library(clpfd)).
:- use_module(library(aggregate)).   % for aggregate_all/3

sudoku(Grid0, Grid) :-
    % Grid0 can contain 0 for blanks; convert to variables
    maplist(maplist(z2v), Grid0, Grid),
    length(Grid, 9), maplist(same_length(Grid), Grid),
    append(Grid, Vs), Vs ins 1..9,

    % rows
    maplist(all_distinct, Grid),

    % columns
    transpose(Grid, Cols),
    maplist(all_distinct, Cols),

    % 3x3 blocks
    blocks(Grid, Blocks),
    maplist(all_distinct, Blocks),

    % search
    labeling([ff,bisect], Vs).

z2v(0, _) :- !.
z2v(N, N).

blocks([], []).
blocks([A,B,C|Rows], Blocks) :-
    triples(A,B,C, Bs1),
    blocks(Rows, Bs2),
    append(Bs1, Bs2, Blocks).

triples([], [], [], []).
triples([A,B,C|R1], [D,E,F|R2], [G,H,I|R3], [[A,B,C,D,E,F,G,H,I]|Rest]) :-
    triples(R1, R2, R3, Rest).




%% -----------------------
%% Pretty-print utilities
%% -----------------------
print_grid(Grid) :-
    forall(nth1(R, Grid, Row),
           ( (R=:=1 ; R=:=4 ; R=:=7) -> writeln('+-------+-------+-------+') ; true ),
             write('| '),
             forall(nth1(C, Row, X),
                    ( (nonvar(X) -> write(X) ; write('_')),
                      (C mod 3 =:= 0 -> write(' | ') ; write(' ')) )),
             nl),
    writeln('+-------+-------+-------+').

%% Solve & show one puzzle by name
run(Name) :-
    puzzle(Name, G0),
    format("~n== ~w ==~n", [Name]),
    print_grid(G0),
    time( (sudoku(G0, G), !, true) ),   % call your solver
    writeln('→ Solution:'),
    print_grid(G).

%% Count how many solutions a puzzle has (careful: can be slow for underconstrained boards)
solutions_count(Name, Count) :-
    puzzle(Name, G0),
    aggregate_all(count, sudoku(G0, _), Count).

%% Try the first N solutions (useful for exploring multi-solution boards)
show_n(Name, N) :-
    puzzle(Name, G0),
    forall(between(1, N, _),
           ( sudoku(G0, G),
             print_grid(G),
             writeln('---'),
             fail ; true )).

%% -----------------------
%% Sample puzzles
%% 0 = blank cell
%% -----------------------

% A classic "easy" with unique solution
puzzle(easy1, [
  [5,3,0, 0,7,0, 0,0,0],
  [6,0,0, 1,9,5, 0,0,0],
  [0,9,8, 0,0,0, 0,6,0],
  [8,0,0, 0,6,0, 0,0,3],
  [4,0,0, 8,0,3, 0,0,1],
  [7,0,0, 0,2,0, 0,0,6],
  [0,6,0, 0,0,0, 2,8,0],
  [0,0,0, 4,1,9, 0,0,5],
  [0,0,0, 0,8,0, 0,7,9]
]).

% Medium/Hard, also unique
puzzle(hard1, [
  [0,0,0, 2,6,0, 7,0,1],
  [6,8,0, 0,7,0, 0,9,0],
  [1,9,0, 0,0,4, 5,0,0],
  [8,2,0, 1,0,0, 0,4,0],
  [0,0,4, 6,0,2, 9,0,0],
  [0,5,0, 0,0,3, 0,2,8],
  [0,0,9, 3,0,0, 0,7,4],
  [0,4,0, 0,5,0, 0,3,6],
  [7,0,3, 0,1,8, 0,0,0]
]).

% "One hole" — almost solved (should be very fast & unique)
% This is the easy1 solution with a single blank at (1,1).
puzzle(one_hole, [
  [0,3,4, 6,7,8, 9,1,2],
  [6,7,2, 1,9,5, 3,4,8],
  [1,9,8, 3,4,2, 5,6,7],
  [8,5,9, 7,6,1, 4,2,3],
  [4,2,6, 8,5,3, 7,9,1],
  [7,1,3, 9,2,4, 8,5,6],
  [9,6,1, 5,3,7, 2,8,4],
  [2,8,7, 4,1,9, 6,3,5],
  [3,4,5, 2,8,6, 1,7,9]
]).

% Underconstrained (likely many solutions) – good for enumerating a few
puzzle(sparse, [
  [0,0,0, 0,0,0, 0,0,0],
  [0,0,0, 0,0,0, 0,0,0],
  [0,0,0, 0,0,0, 0,0,0],
  [0,0,0, 0,0,0, 0,0,0],
  [0,0,0, 0,0,0, 0,0,0],
  [0,0,0, 0,0,0, 0,0,0],
  [0,0,0, 0,0,0, 0,0,0],
  [0,0,0, 0,0,0, 0,0,0],
  [0,0,0, 0,0,0, 0,0,0]
]).

% Contradictory (unsatisfiable): row 1 has two 5s
puzzle(unsat_row_dup, [
  [5,5,0, 0,7,0, 0,0,0],
  [6,0,0, 1,9,5, 0,0,0],
  [0,9,8, 0,0,0, 0,6,0],
  [8,0,0, 0,6,0, 0,0,3],
  [4,0,0, 8,0,3, 0,0,1],
  [7,0,0, 0,2,0, 0,0,6],
  [0,6,0, 0,0,0, 2,8,0],
  [0,0,0, 4,1,9, 0,0,5],
  [0,0,0, 0,8,0, 0,7,9]
]).

%% -----------------------
%% Minimal PlUnit tests
%% -----------------------
:- begin_tests(sudoku_tests).

test(easy1_unique, [true(Count == 1)]) :-
    solutions_count(easy1, Count).

test(hard1_unique, [true(Count == 1)]) :-
    solutions_count(hard1, Count).

test(one_hole_unique, [true(Count == 1)]) :-
    solutions_count(one_hole, Count).

test(unsatisfiable, [fail]) :-
    puzzle(unsat_row_dup, G0),
    sudoku(G0, _).

:- end_tests(sudoku_tests).
