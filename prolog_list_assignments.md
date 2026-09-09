# Prolog exercises: lists

## Before you start

- A list is either the empty list `[]` or a term `[Head|Tail]` where `Tail` is a list. `[a,b,c]` is shorthand for `[a|[b|[c|[]]]]`. Nearly every predicate below has one clause for `[]` and one for `[H|T]`.
- Do not use the library predicates (`length/2`, `append/3`, `member/2`, `reverse/2`, `last/2`, `nth0/3`, `flatten/2`, `msort/2`, ...). The exercises exist so that you write them. Names that would collide with a built-in are prefixed with `my_`; SWI-Prolog will not let you redefine `length/2` at all.
- Put everything in one file, `lists.pl`, and load it with `swipl lists.pl` (or `?- [lists].` from inside SWI-Prolog). After each answer at the toplevel, press `;` to ask for more answers or Enter to stop.
- Whether the toplevel prints `X = c.` or `X = c ;` followed by `false.` depends on whether Prolog has an untried alternative left over. Both count as correct unless the exercise says otherwise.
- The sample queries show the expected answers. Try queries of your own too, particularly ones with a variable where the sample has a value.

## Part A: Recursion over a list

**1. Length.** Define `my_length(List, N)`: `N` is the number of elements in `List`.

```
?- my_length([a,b,c], N).
N = 3.
?- my_length([], N).
N = 0.
```

**2. Membership.** Define `my_member(X, List)`: `X` is an element of `List`.

```
?- my_member(b, [a,b,c]).
true ;
false.
?- my_member(d, [a,b,c]).
false.
?- my_member(X, [a,b,c]).
X = a ;
X = b ;
X = c.
```

Explain the `true ; false.` in the first query, and where the three answers in the third one come from.

**3. Sum.** Define `sum(List, S)`: `S` is the sum of the numbers in `List`. The sum of `[]` is 0.

```
?- sum([1,2,3,4], S).
S = 10.
```

Replace `is` with `=` in your solution and run the query again. What do you get, and why?

**4. Last element.** Define `my_last(List, X)`: `X` is the last element of `List`. It should fail for `[]`.

```
?- my_last([a,b,c], X).
X = c.
?- my_last([], X).
false.
```

## Part B: Building lists

**5. Append.** Define `my_append(L1, L2, L3)`: `L3` is `L1` followed by `L2`.

```
?- my_append([1,2], [3,4], L).
L = [1,2,3,4].
```

Now run these, pressing `;` until Prolog answers `false.`, and explain each set of answers:

```
?- my_append(X, Y, [1,2,3]).
?- my_append(X, [3], [1,2,3]).
?- my_append(_, [X], [1,2,3]).
```

Using `my_append` only (no recursion of your own), define `prefix(P, L)` and `suffix(S, L)`.

**6. Reverse.** Define `my_reverse(List, Rev)`.

```
?- my_reverse([1,2,3], R).
R = [3,2,1].
```

(a) Write it using `my_append`. (b) Write a second version `rev_acc(List, Rev)` that calls a three-argument helper `rev_acc(List, Acc, Rev)`, where `Acc` accumulates the result so far. (c) Compare the two:

```
?- numlist(1, 10000, L), time(my_reverse(L, _)).
?- numlist(1, 10000, L), time(rev_acc(L, _)).
```

Explain the difference in the number of inferences.

**7. Duplicate.** Define `dup(List, D)`: `D` is `List` with every element repeated twice in a row.

```
?- dup([a,b,c], D).
D = [a,a,b,b,c,c].
```

**8. Delete and count.** Define `del(X, List, Rest)`: `Rest` is `List` with every occurrence of `X` removed. Define `count(X, List, N)`: `N` is the number of occurrences of `X` in `List`.

```
?- del(a, [a,b,a,c], R).
R = [b,c].
?- count(a, [a,b,a,c], N).
N = 2.
```

After the first answer to each query, press `;`. If you get a second answer, your solution is wrong. Work out why, and fix it.

**9. Range.** Define `range(Lo, Hi, List)`: `List` is the integers from `Lo` to `Hi` inclusive, and empty if `Lo > Hi`.

```
?- range(3, 7, L).
L = [3,4,5,6,7].
?- range(5, 2, L).
L = [].
```

## Part C: A bit more

**10. Largest.** Define `largest(List, M)`: `M` is the largest number in the non-empty list `List`.

```
?- largest([3,9,2,7], M).
M = 9.
```

Time your solution on `numlist(1, 25, L)`. If it takes seconds rather than a blink, you are computing something twice.

**11. Zip.** Define `zip(Xs, Ys, Pairs)`: `Pairs` pairs up the elements of the two lists position by position, as terms of the form `X-Y`. The two lists have the same length.

```
?- zip([a,b,c], [1,2,3], P).
P = [a-1, b-2, c-3].
```

Then run `?- zip(Xs, Ys, [a-1, b-2]).` You did not write an unzip. Where did it come from?

**12. Flatten.** Define `flat(Nested, Flat)`: `Flat` contains the non-list elements of `Nested`, in order, with all nesting removed. You may use the built-in `is_list/1`.

```
?- flat([a, [b, [c, d]], [], e], F).
F = [a,b,c,d,e].
```

Press `;` after the answer. As in exercise 8, a second answer means a bug.

**13. Palindrome.** Define `palindrome(List)`: true if `List` reads the same backwards.

```
?- palindrome([a,b,c,b,a]).
true.
?- palindrome([a,b]).
false.
```

The solution is one line.

## Stretch

**14. Insertion sort.** Define `insert(X, Sorted, Sorted2)`: `Sorted2` is the sorted list `Sorted` with `X` inserted in its place. Then define `isort(List, Sorted)`.

```
?- insert(2, [1,3,4], S).
S = [1,2,3,4].
?- isort([3,1,2], S).
S = [1,2,3].
```

**15. Compress.** Define `compress(List, C)`: `C` is `List` with every run of consecutive equal elements collapsed to a single element.

```
?- compress([a,a,b,c,c,c,a], C).
C = [a,b,c,a].
```

Hint: a clause head can match the first two elements at once, as in `[X,Y|T]`, or even `[X,X|T]`.
