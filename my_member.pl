in(H, [H | _]).
in(X, [_ | T]) :- in(X, T).