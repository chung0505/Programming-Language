class(lane).
class(stage).
class(swimlane).

abstract_class(lane).
concrete_class(stage).
concrete_class(swimlane).

subclass(stage, lane).
subclass(swimlane, lane).

:- dynamic instance_of/2.
:- dynamic child_of/2.

valid_instance_class(Class) :-
    concrete_class(Class).

new_instance(Instance, Class) :-
    valid_instance_class(Class),
    assert(instance_of(Instance, Class)).

is_descendant(Descendant, Ancestor) :-
    child_of(Descendant, Ancestor).
is_descendant(Descendant, Ancestor) :-
    child_of(Intermediate, Ancestor),
    is_descendant(Descendant, Intermediate).

same_concrete_class(Instance1, Instance2) :-
    instance_of(Instance1, Class),
    instance_of(Instance2, Class),
    concrete_class(Class).

has_parent(Instance) :-
    child_of(Instance, _).

add_child(Child, Parent) :-
    instance_of(Child, _),
    instance_of(Parent, _),
    
    (is_descendant(Parent, Child) ->
        write('Child not added: cannot add an ancestor as a new child'),
        nl, !
    ;
        (is_descendant(Child, Parent) ->
            write('Child not added: cannot add a descendant as a new child'),
            nl, !
        ;
            (has_parent(Child) ->
                write('Child not added: cannot add a child that is already a child of another parent'),
                nl, !
            ;
                (setof(ExistingChild, child_of(ExistingChild, Parent), ExistingChildren) ->
                    % Get the first child to compare class
                    ExistingChildren = [FirstChild|_],
                    (same_concrete_class(Child, FirstChild) ->
                        assert(child_of(Child, Parent))
                    ;
                        write('Child not added: cannot add a child with different class'),
                        nl
                    )
                ;
                    assert(child_of(Child, Parent))
                )
            )
        )
    ).

add_child(Child, Parent) :-
    instance_of(Child, _),
    instance_of(Parent, _),
    \+ child_of(_, Parent),
    \+ has_parent(Child),
    \+ is_descendant(Parent, Child),
    \+ is_descendant(Child, Parent),
    assert(child_of(Child, Parent)).

children(Parent, Children) :-
    setof(Child, child_of(Child, Parent), Children), !.
children(_, []).

descendants(Parent, Descendants) :-
    findall(Desc, collect_descendants(Parent, Desc), Descendants), !.
descendants(_, []).

collect_descendants(Parent, Descendant) :-
    child_of(Descendant, Parent).
collect_descendants(Parent, Descendant) :-
    child_of(Child, Parent),
    collect_descendants(Child, Descendant).

valid_children(Parent) :-
    \+ (
        child_of(Child1, Parent),
        child_of(Child2, Parent),
        Child1 \= Child2,
        instance_of(Child1, Class1),
        instance_of(Child2, Class2),
        Class1 \= Class2
    ).