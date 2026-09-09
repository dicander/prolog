% prolog_list_solutions.pl
% Solutions and instructor notes for "Prolog exercises: lists".
%
% Load:   swipl prolog_list_solutions.pl
% Tests:  ?- run_tests.
% Tested with SWI-Prolog 9.0.4.
%
% Naming. my_length, my_member, my_append, my_reverse and my_last avoid the
% built-in and library predicates of the same name. SWI refuses to redefine
% length/2 outright (permission error) and silently prefers a user
% definition of append/3 & co. over the library one; a prefix is less
% confusing than either.
%
% Choice points. Several definitions below leave a choice point after the
% last answer, so the toplevel prints "X = ... ;" and then "false." rather
% than "X = ...". That is correct behaviour for these definitions. The
% notes say where a guard or if-then-else removes it; whether that matters
% at this stage of the course is a judgement call.

% ---------------------------------------------------------------------
% Part A: Recursion over a list
% ---------------------------------------------------------------------

% 1. my_length(?List, ?N)
my_length([], 0).
my_length([_|T], N) :-
    my_length(T, N0),
    N is N0 + 1.

% Notes
% - The standard error is "N is N0 + 1" placed *before* the recursive
%   call: N0 is unbound there and "is" throws an instantiation error.
% - Reverse mode works: my_length(L, 3) gives L = [_, _, _]. Asking for
%   more answers loops forever, since the search tries ever longer lists
%   and the arithmetic check at the top keeps failing.
% - Accumulator version (tail recursive), if the accumulator has been
%   introduced by then:
%     len_acc(L, N) :- len_acc(L, 0, N).
%     len_acc([], N, N).
%     len_acc([_|T], A, N) :- A1 is A + 1, len_acc(T, A1, N).

% 2. my_member(?X, ?List)
my_member(X, [X|_]).
my_member(X, [_|T]) :-
    my_member(X, T).

% Notes
% - my_member(b, [a,b,c]) answers "true ;" then "false.": after the first
%   clause succeeds, the second is still untried, and indexing cannot rule
%   it out since both heads have the same shape.
% - my_member(X, [a,b,c]) enumerates a, b, c. Same code, used to generate
%   rather than test. This is the first place the students see that a
%   predicate is not a function; worth slowing down for.

% 3. sum(+List, -S)
sum([], 0).
sum([H|T], S) :-
    sum(T, S0),
    S is S0 + H.

% Notes
% - With "=" instead of "is" the answer is S = 0+4+3+2+1: a perfectly good
%   term, never evaluated. Showing it explains "is" better than any
%   description does.

% 4. my_last(+List, -X)
my_last([X], X).
my_last([_|T], X) :-
    my_last(T, X).

% Notes
% - Leaves a choice point ("X = c ;" then "false."), because [X] also
%   matches the head [_|T]. Writing the heads as [X] and [_,Y|T] does not
%   help in SWI 9.0: indexing looks at the first argument's functor, and
%   both are still list cells. The library's last/2 gets determinism by
%   carrying the candidate one step ahead, so the helper's first argument
%   is [] or [_|_]:
%     last3([X|Xs], L) :- last3_(Xs, X, L).
%     last3_([], L, L).
%     last3_([X|Xs], _, L) :- last3_(Xs, X, L).
%   Worth showing after the accumulator idiom, not before.
% - Or, once my_append exists:  my_last(L, X) :- my_append(_, [X], L).
%   (Also leaves a choice point, for the same reason.)

% ---------------------------------------------------------------------
% Part B: Building lists
% ---------------------------------------------------------------------

% 5. my_append(?L1, ?L2, ?L3)
my_append([], L, L).
my_append([H|T], L, [H|R]) :-
    my_append(T, L, R).

prefix(P, L) :- my_append(P, _, L).
suffix(S, L) :- my_append(_, S, L).

% Notes
% - my_append(X, Y, [1,2,3]) gives all four splits, X growing, then false.
% - my_append(X, [3], [1,2,3]) gives X = [1,2]: "remove the last element".
% - my_append(_, [X], [1,2,3]) gives X = 3: the last element, with no
%   recursion written by the student.
% - This is the exercise where "relation, not function" stops being a
%   slogan. Let them run the three queries before explaining anything.

% 6. my_reverse(+List, -Rev)
my_reverse([], []).
my_reverse([H|T], R) :-
    my_reverse(T, RT),
    my_append(RT, [H], R).

rev_acc(L, R) :-
    rev_acc(L, [], R).

rev_acc([], A, A).
rev_acc([H|T], A, R) :-
    rev_acc(T, [H|A], R).

% Notes
% - The naive version is O(n^2): every my_append walks the already
%   reversed tail. The accumulator version is O(n) and tail recursive.
%   Measured on numlist(1, 10000, L): 50,015,002 inferences versus
%   10,003.
% - The accumulator idiom (wrapper of arity n calls a helper of arity n+1
%   with a start value) is the thing to take away; my_length and sum can
%   be rewritten the same way as a follow-up.
% - my_reverse(X, [1,2,3]) finds X = [3,2,1] and then loops, for the same
%   reason as my_length in reverse mode.

% 7. dup(?List, ?D)
dup([], []).
dup([H|T], [H,H|R]) :-
    dup(T, R).

% Notes
% - Nothing to trip over. It exists so that a two-element pattern in a
%   clause head ([H,H|R]) has been seen before compress/2 needs one.
% - Reverse mode: dup(L, [a,a,b,b]) gives L = [a,b]; dup(L, [a,b]) fails.

% 8. del(+X, +List, -Rest) and count(+X, +List, -N)
del(_, [], []).
del(X, [X|T], R) :-
    del(X, T, R).
del(X, [H|T], [H|R]) :-
    X \= H,
    del(X, T, R).

count(_, [], 0).
count(X, [X|T], N) :-
    count(X, T, N0),
    N is N0 + 1.
count(X, [H|T], N) :-
    X \= H,
    count(X, T, N).

% Notes
% - Without the X \= H guard, del(a, [a,b,a,c], R) gives R = [b,c] and
%   then, on backtracking, [b,a,c], [a,b,c] and [a,b,a,c]: the third
%   clause also matches when H = X. The exercise is designed so they find
%   this with ";" rather than hear about it.
% - \= is "not unifiable", which only means "different" when both sides
%   are ground. del(X, [a,b], R) with X unbound gives only X = a, R = [b].
%   The pure version delays the test with dif/2:
%     del2(_, [], []).
%     del2(X, [X|T], R) :- del2(X, T, R).
%     del2(X, [H|T], [H|R]) :- dif(X, H), del2(X, T, R).
%   Probably a remark rather than an exercise at this level.
% - A cut in the second clause is the other common fix. It works, but it
%   makes the predicate depend on clause order, which is the worse habit.

% 9. range(+Lo, +Hi, -List)
range(Lo, Hi, []) :-
    Lo > Hi.
range(Lo, Hi, [Lo|T]) :-
    Lo =< Hi,
    Lo1 is Lo + 1,
    range(Lo1, Hi, T).

% Notes
% - The guards are exclusive, so there is exactly one answer, but nothing
%   in the heads lets indexing skip the second clause, so a choice point
%   remains. If-then-else removes it:
%     range(Lo, Hi, L) :-
%         (   Lo > Hi
%         ->  L = []
%         ;   L = [Lo|T], Lo1 is Lo + 1, range(Lo1, Hi, T)
%         ).
% - Students who take range(Hi, Hi, [Hi]) as the base case get a version
%   that fails instead of giving [] for Lo > Hi. Point it at the spec.

% ---------------------------------------------------------------------
% Part C: A bit more
% ---------------------------------------------------------------------

% 10. largest(+List, -M)
largest([X], X).
largest([H|T], M) :-
    largest(T, M0),
    M is max(H, M0).

% Notes
% - The version most students write first,
%     largest2([X], X).
%     largest2([H|T], H) :- largest2(T, M), H >= M.
%     largest2([H|T], M) :- largest2(T, M), H < M.
%   is correct and exponential: whenever the first clause fails, the
%   second recomputes largest2(T, M) from scratch, so an increasing list
%   doubles the work at every element. Measured: 1..22 takes 0.7 s,
%   so 1..25 takes about 6 s and 1..30 about three minutes.
%   Fix: compute once, then decide, either with
%   max/2 as above or with if-then-else:
%     largest([H|T], M) :- largest(T, M0), ( H > M0 -> M = H ; M = M0 ).

% 11. zip(?Xs, ?Ys, ?Pairs)
zip([], [], []).
zip([X|Xs], [Y|Ys], [X-Y|Ps]) :-
    zip(Xs, Ys, Ps).

% Notes
% - zip(Xs, Ys, [a-1, b-2]) unzips. No extra code; the relation does not
%   know which arguments are input.
% - X-Y is just the term -(X, Y); nothing is subtracted. It is SWI's own
%   pair convention (pairs_keys_values/3 and friends), so adopt it rather
%   than inventing pair(X, Y).
% - Lists of unequal length fail. "Stop at the shorter one" is a decent
%   extra.

% 12. flat(+Nested, -Flat)
flat([], []).
flat([H|T], F) :-
    is_list(H),
    flat(H, FH),
    flat(T, FT),
    my_append(FH, FT, F).
flat([H|T], [H|FT]) :-
    \+ is_list(H),
    flat(T, FT).

% Notes
% - Without the \+ is_list(H) guard the third clause also fires for a
%   nested list, and the answers on backtracking are half flattened.
%   Same lesson as del/3: clauses must be exclusive or backtracking
%   invents answers.
% - The conventional version cuts in the second clause instead of guarding
%   the third. Either is fine; the guard keeps the logic visible.

% 13. palindrome(+List)
palindrome(L) :-
    my_reverse(L, L).

% Notes
% - One line, and students who have just written my_reverse often miss it
%   because they are looking for an algorithm. That is why it is here.

% ---------------------------------------------------------------------
% Stretch
% ---------------------------------------------------------------------

% 14. isort(+List, -Sorted)
isort([], []).
isort([H|T], S) :-
    isort(T, ST),
    insert(H, ST, S).

insert(X, [], [X]).
insert(X, [H|T], [X,H|T]) :-
    X =< H.
insert(X, [H|T], [H|R]) :-
    X > H,
    insert(X, T, R).

% Notes
% - Same shape as the functional version; noticing that is most of the
%   exercise. Stable, O(n^2).
% - msort/2 and sort/2 exist in the library; sort/2 removes duplicates,
%   which surprises everyone exactly once.

% 15. compress(+List, -C)
compress([], []).
compress([X], [X]).
compress([X,X|T], R) :-
    compress([X|T], R).
compress([X,Y|T], [X|R]) :-
    X \= Y,
    compress([Y|T], R).

% Notes
% - The head [X,X|T] does the "first two equal" test by unification.
%   Students who have not seen a repeated head variable write [X,Y|T]
%   with X == Y in the body, which is also fine.
% - This is P08 of the "99 Prolog problems", so pack/encode/decode are
%   available as follow-ups if the family is wanted.

% ---------------------------------------------------------------------
% Tests:  ?- run_tests.
% Tests whose solution legitimately leaves a choice point are marked
% nondet; plunit would otherwise warn about them.
% ---------------------------------------------------------------------

:- use_module(library(plunit)).

:- begin_tests(lists).

test(length)              :- my_length([a,b,c], 3).
test(length_empty)        :- my_length([], 0).
test(length_reverse_mode) :- once(my_length(L, 3)), length(L, 3).

test(member, all(X == [a,b,c])) :- my_member(X, [a,b,c]).
test(member_no, fail)     :- my_member(d, [a,b,c]).

test(sum)                 :- sum([1,2,3,4], 10).
test(sum_empty)           :- sum([], 0).

test(last, nondet)        :- my_last([a,b,c], c).
test(last_empty, fail)    :- my_last([], _).

test(append)              :- my_append([1,2], [3,4], [1,2,3,4]).
test(append_split, all(X-Y == [[]-[1,2], [1]-[2], [1,2]-[]])) :-
    my_append(X, Y, [1,2]).
test(append_last, all(X == [3])) :- my_append(_, [X], [1,2,3]).
test(prefix, all(P == [[], [1], [1,2]])) :- prefix(P, [1,2]).
test(suffix, all(S == [[1,2], [2], []])) :- suffix(S, [1,2]).

test(reverse)             :- my_reverse([1,2,3], [3,2,1]).
test(rev_acc)             :- rev_acc([1,2,3], [3,2,1]).
test(rev_acc_empty)       :- rev_acc([], []).

test(dup)                 :- dup([a,b,c], [a,a,b,b,c,c]).
test(dup_reverse_mode)    :- dup(L, [a,a,b,b]), L == [a,b].
test(dup_odd, fail)       :- dup(_, [a,b]).

test(del, all(R == [[b,c]]))  :- del(a, [a,b,a,c], R).
test(del_none, all(R == [[b,c]])) :- del(z, [b,c], R).
test(count, all(N == [2]))    :- count(a, [a,b,a,c], N).
test(count_none, all(N == [0])) :- count(z, [a,b], N).

test(range, all(L == [[3,4,5,6,7]])) :- range(3, 7, L).
test(range_empty, all(L == [[]]))    :- range(5, 2, L).
test(range_one, all(L == [[4]]))     :- range(4, 4, L).

test(largest, all(M == [9]))  :- largest([3,9,2,7], M).
test(largest_one, all(M == [5])) :- largest([5], M).

test(zip)                 :- zip([a,b,c], [1,2,3], [a-1,b-2,c-3]).
test(unzip)               :- zip(Xs, Ys, [a-1,b-2]), Xs == [a,b], Ys == [1,2].
test(zip_unequal, fail)   :- zip([a,b], [1], _).

test(flat, all(F == [[a,b,c,d,e]])) :- flat([a,[b,[c,d]],[],e], F).
test(flat_empty)          :- flat([], []).

test(palindrome)          :- palindrome([a,b,c,b,a]).
test(palindrome_empty)    :- palindrome([]).
test(palindrome_no, fail) :- palindrome([a,b]).

test(insert, all(S == [[1,2,3,4]])) :- insert(2, [1,3,4], S).
test(isort, all(S == [[1,2,3]]))    :- isort([3,1,2], S).
test(isort_dups, all(S == [[1,2,2]])) :- isort([2,1,2], S).

test(compress, all(C == [[a,b,c,a]])) :- compress([a,a,b,c,c,c,a], C).
test(compress_one, all(C == [[a]]))   :- compress([a], C).
test(compress_empty)      :- compress([], []).

:- end_tests(lists).
