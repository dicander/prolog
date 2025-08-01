isprime(N) :-
    %either N is 2 or 
    N is 2;
    N > 2,
    \+ has_factor(N, 2).

has_factor(N, F) :-
    N mod F =:= 0.
has_factor(N, F) :-
    F * F =< N,
    F2 is F + 1,
    has_factor(N, F2).

% Create a list of prime numbers up to N
primes_up_to(N, Primes) :-
    findall(X, (between(1, N, X), isprime(X)), Primes).