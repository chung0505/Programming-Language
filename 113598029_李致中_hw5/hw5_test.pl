:- use_module(library(plunit)).
:- use_module(hw5).

:- begin_tests(hw5_test).

test(class_hierarchy) :-
    assertion(class(lane)),
    assertion(class(stage)),
    assertion(class(swimlane)),
    
    assertion(abstract_class(lane)),
    assertion(concrete_class(stage)),
    assertion(concrete_class(swimlane)),
    
    assertion(subclass(stage, lane)),
    assertion(subclass(swimlane, lane)).

test(instance_creation) :-
    assertion(new_instance(s1, stage)),

    \+ new_instance(i, lane).

test(children_basic) :-
    new_instance(parent_stage, stage),
    new_instance(child_swimlane, swimlane),

    assertion(add_child(child_swimlane, parent_stage)),

    children(parent_stage, Children),
    assertion(Children = [child_swimlane]).

test(children_same_type) :-
    retractall(child_of(_, _)),
    retractall(instance_of(_, _)),

    new_instance(s1, stage),
    new_instance(child1_swimlane, swimlane),
    new_instance(child2_swimlane, swimlane),


    add_child(child1_swimlane, s1),
    add_child(child2_swimlane, s1),

    children(s1, Children),
    assertion(Children = [child1_swimlane, child2_swimlane]),
    !.  

test(descendant) :-
    retractall(child_of(_, _)),
    retractall(instance_of(_, _)),

    new_instance(grandparent, stage),
    new_instance(parent, swimlane),
    new_instance(child, stage),

    add_child(parent, grandparent),
    add_child(child, parent),

    descendants(grandparent, Desc),
    assertion(Desc = [parent, child]),
    !.

test(add_different_type_of_children) :-
    retractall(child_of(_, _)),
    retractall(instance_of(_, _)),

    new_instance(ancestor1, stage),
    new_instance(d1, swimlane),
    new_instance(d2, stage),

    add_child(d1, ancestor1),
    with_output_to(string(Output), add_child(d2, ancestor1)),
    sub_string(Output, _, _, _, "Child not added: cannot add a child with different class"),
    !.

test(add_ancestor_as_child) :-
    retractall(child_of(_, _)),
    retractall(instance_of(_, _)),

    new_instance(ancestor2, stage),
    new_instance(d3, swimlane),

    add_child(d3, ancestor2),
    with_output_to(string(Output), add_child(ancestor2, d3)),
    sub_string(Output, _, _, _, "Child not added: cannot add an ancestor as a new child"),
    !.

test(add_descendant_as_child) :-
    retractall(child_of(_, _)),
    retractall(instance_of(_, _)),

    new_instance(ancestor3, stage),
    new_instance(d4, swimlane),
    new_instance(d5, swimlane),

    add_child(d4, ancestor3),
    add_child(d5, d4),

    with_output_to(string(Output), add_child(d5, ancestor3)),
    sub_string(Output, _, _, _, "Child not added: cannot add a descendant as a new child"),
    !.

test(add_child_already_has_parent) :-
    retractall(child_of(_, _)),
    retractall(instance_of(_, _)),

    new_instance(ancestor4, stage),
    new_instance(d6, swimlane),
    new_instance(d7, swimlane),

    add_child(d6, ancestor4),
    add_child(d7, ancestor4),

    with_output_to(string(Output), add_child(d6, d7)),
    sub_string(Output, _, _, _, "Child not added: cannot add a child that is already a child of another parent"),
    !.

test(valid_children) :-
    retractall(child_of(_, _)),
    retractall(instance_of(_, _)),

    new_instance(ancestor5, stage),
    new_instance(d8, swimlane),
    new_instance(d9, swimlane),

    add_child(d8, ancestor5),
    add_child(d9, ancestor5),

    assertion(valid_children(ancestor5)),
    !.

test(mutiple_level_valid_children) :-
    retractall(child_of(_, _)),
    retractall(instance_of(_, _)),

    new_instance(ancestor6, stage),
    new_instance(d10, swimlane),
    new_instance(d11, swimlane),
    new_instance(d12, swimlane),
    new_instance(d13, swimlane),

    add_child(d10, ancestor6),
    add_child(d11, ancestor6),
    add_child(d12, d10),
    add_child(d13, d10),

    assertion(valid_children(d10)),
    !.

:- end_tests(hw5_test).

