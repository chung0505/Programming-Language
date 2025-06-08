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

h_distance_sequence([Empty | Tiles], H) :-
    goal([_Empty1 | GoalSquares]), 
    totdist(Tiles, GoalSquares, D),
    seq(Tiles, S),
    H is D + S.

h_greater_sequence([Empty | Tiles], H) :-
    goal([_Empty1 | GoalSquares]), 
    totdist(Tiles, GoalSquares, D),
    seq(Tiles, S),
    H is D + 4*S.

h_large_sequence([Empty | Tiles], H) :-
    goal([_Empty1 | GoalSquares]), 
    totdist(Tiles, GoalSquares, D),
    seq(Tiles, S),
    H is D + 10*S.

test_diff_heuristic(Pos, H) :-
    retractall(h(_,_)),
    (H = distance ->
        assertz((h(N,H_VAL) :- h_distance(N,H_VAL))); 
    H = sequence ->
        assertz((h(N,H_VAL) :- h_sequence(N,H_VAL)));
    H = distance_sequence ->
        assertz((h(N,H_VAL) :- h_distance_sequence(N,H_VAL))); 
    H = greater_sequence ->
        assertz((h(N,H_VAL) :- h_greater_sequence(N,H_VAL)));
    H = large_sequence ->
        assertz((h(N,H_VAL) :- h_large_sequence(N,H_VAL)))
    ),
    bestfirst(Pos, Solution).

initialize_tests :-
    save_original_h.

:- begin_tests(hw6_test).

test(start1_node_count) :-
    start1(Pos), 
    bestfirst(Pos, Sol),
    node_count(N),
    assertion(N == 10),
    !.

test(start2_node_count) :-
    start2(Pos), 
    bestfirst(Pos, Sol),
    node_count(N),
    assertion(N == 12),
    !.

test(start3_node_count) :-
    start3(Pos), 
    bestfirst(Pos, Sol),
    node_count(N),
    assertion(N == 69),
    !.

test(start1_node_count_distance) :-
    start1(Pos), 
    test_diff_heuristic(Pos, distance),
    node_count(N),
    format('Actual node count: ~w~n', [N]),
    assertion(N == 10),
    !.

test(start2_node_count_distance) :-
    start2(Pos),
    test_diff_heuristic(Pos, distance),
    node_count(N),
    format('Actual node count: ~w~n', [N]),
    assertion(N == 12),
    !.

test(start3_node_count_distance) :-
    start3(Pos),
    test_diff_heuristic(Pos, distance),
    node_count(N),
    format('Actual node count: ~w~n', [N]),
    assertion(N == 170),
    !.

test(start1_node_count_sequence) :-
    start1(Pos), 
    test_diff_heuristic(Pos, sequence),
    node_count(N),
    format('Actual node count: ~w~n', [N]),
    assertion(N == 10),
    !.

test(start2_node_count_sequence) :-
    start2(Pos),
    test_diff_heuristic(Pos, sequence),
    node_count(N),
    format('Actual node count: ~w~n', [N]),
    assertion(N == 12),
    !.

test(start3_node_count_sequence) :-
    start3(Pos),
    test_diff_heuristic(Pos, sequence),
    node_count(N),
    format('Actual node count: ~w~n', [N]),
    assertion(N == 1443),
    !.

test(start1_node_count_distance_sequence) :-
    start1(Pos), 
    test_diff_heuristic(Pos, distance_sequence),
    node_count(N),
    format('Actual node count: ~w~n', [N]),
    assertion(N == 10),
    !.

test(start2_node_count_distance_sequence) :-
    start2(Pos),
    test_diff_heuristic(Pos, distance_sequence),
    node_count(N),
    format('Actual node count: ~w~n', [N]),
    assertion(N == 12),
    !.

test(start3_node_count_distance_sequence) :-
    start3(Pos),
    test_diff_heuristic(Pos, distance_sequence),
    node_count(N),
    format('Actual node count: ~w~n', [N]),
    assertion(N == 83),
    !.

test(start1_node_count_greater_sequence) :-
    start1(Pos), 
    test_diff_heuristic(Pos, greater_sequence),
    node_count(N),
    format('Actual node count: ~w~n', [N]),
    assertion(N == 10),
    !.

test(start2_node_count_greater_sequence) :-
    start2(Pos),
    test_diff_heuristic(Pos, greater_sequence),
    node_count(N),
    format('Actual node count: ~w~n', [N]),
    assertion(N == 12),
    !.

test(start3_node_count_greater_sequence) :-
    start3(Pos),
    test_diff_heuristic(Pos, greater_sequence),
    node_count(N),
    format('Actual node count: ~w~n', [N]),
    assertion(N == 78),
    !.

test(start1_node_count_large_sequence) :-
    start1(Pos), 
    test_diff_heuristic(Pos, large_sequence),
    node_count(N),
    format('Actual node count: ~w~n', [N]),
    assertion(N == 10),
    !.

test(start2_node_count_large_sequence) :-
    start2(Pos),
    test_diff_heuristic(Pos, large_sequence),
    node_count(N),
    format('Actual node count: ~w~n', [N]),
    assertion(N == 12),
    !.

test(start3_node_count_large_sequence) :-
    start3(Pos),
    test_diff_heuristic(Pos, large_sequence),
    node_count(N),
    format('Actual node count: ~w~n', [N]),
    assertion(N == 103),
    !.

:- end_tests(hw6_test).