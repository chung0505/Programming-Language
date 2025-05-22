:- use_module(library(plunit)).
:- use_module(fig12_3).
:- use_module(fig12_6).

:- dynamic h/2.
:- multifile original_h/2.
:- dynamic original_h/2.

save_original_h :-
    clause(h(A,B), Body),
    assertz((original_h(A,B) :- Body)),
    retractall(h(_,_)).

h_distance([Empty | Tiles], H) :-
    goal([_Empty1 | GoalSquares]), 
    totdist(Tiles, GoalSquares, D),
    H is D.

h_sequence([Empty | Tiles], H) :-
    seq(Tiles, S),
    H is S.

h_distance_sequence() :-
    goal([_Empty1 | GoalSquares]), 
    totdist(Tiles, GoalSquares, D),
    seq(Tiles, S),
    H is D + S.

h_greater_sequence() :-
    goal([_Empty1 | GoalSquares]), 
    totdist(Tiles, GoalSquares, D),
    seq(Tiles, S),
    H is D + 4*S.

test_diff_heuristic(Pos, H) :-
    format('~nTesting with heuristic: ~w~n', [H]),
    retractall(h(_,_)),
    (H = distance ->
        assertz((h(N,H) :- h_distance(N,H)))
    ; H = sequence ->
        assertz((h(N,H) :- h_sequence(N,H)))
    ; H = distance_sequence ->
        assertz((h(N,H) :- h_distance_sequence(N,H)))
    ; H = greater_sequence ->
        assertz((h(N,H) :- h_greater_sequence(N,H)))
    ),
    bestfirst(Pos, Solution),
    length(Solution, L),
    format('Solution length: ~w steps~n', [L]).

initialize_tests :-
    save_original_h.

:- begin_tests(hw6_test).

test(start1_node_count) :-
    start1(Pos), 
    bestfirst(Pos, Sol),
    node_count(N),
    assert(N == 10).

test(start2_node_count) :-
    start1(Pos), 
    bestfirst(Pos, Sol),
    node_count(N),
    assert(N == 12).

test(start3_node_count) :-
    start1(Pos), 
    bestfirst(Pos, Sol),
    node_count(N),
    assert(N == 69).

test(start1_node_count_distance) :-
    start1(Pos), 
    test_heuristic(Pos, distance),
    node_count(N),
    assert(N == 10).

test(start2_node_count_distance) :-
    start2(Pos),
    test_heuristic(Pos, distance),
    node_count(N),
    assertion(N == 12).

test(start3_node_count_distance) :-
    start3(Pos),
    test_heuristic(Pos, distance),
    node_count(N),
    assertion(N == 170).

:- end_tests(hw6_test).