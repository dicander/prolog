:- use_module(library(clpr)).

base_exponent_power(Base, Exponent, Result) :-
    {Result = Base ^ Exponent}.
base_exponent_power(_, 0, 1).
base_exponent_power(0, E, 0) :- {E > 0}.