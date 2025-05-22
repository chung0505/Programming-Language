:- use_module(library(plunit)).
:- use_module(fig12_3).
:- use_module(fig12_6).

:- begin_tests(hw6_test).

test(start1_node_count) :-
    with_output_to(string(Output), start1(Pos), bestfirst(Pos, Sol)),
    sub_string(Output, _, _, _, "Total number of nodes generated: 10"),
    !.


:- end_tests(hw6_test).