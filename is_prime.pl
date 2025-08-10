isprime(2).
isprime(3).
isprime(N) :-
    N > 3,
    N /\ 1 =:= 1, % Check if N is odd, don't you just love that bitwise AND syntax?
    \+ has_factor(N, 3).

has_factor(N, F) :-
    N mod F =:= 0.
has_factor(N, F) :-
    F2 is F + 2,
    F * F =< N,
    has_factor(N, F2).

% Create a list of prime numbers up to N
primes_up_to(N, Primes) :-
    findall(X, (between(1, N, X), isprime(X)), Primes).