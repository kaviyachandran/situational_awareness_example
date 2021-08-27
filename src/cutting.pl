:- module(cutting,
    [ 
        assert_objects_in_scene(r)
    ]).

:- rdf_db:rdf_register_ns(soma,
    'http://www.ease-crc.org/ont/SOMA.owl#', [keep(true)]).

/*
queries to think about : 
- what tasks can I do with the given objects - Detecting potentials
- Preconditions - State of the situation
- what is the missing object for the task
- will I able to do the task given the objects

Sol:
1. Get the dispositions of the objects
2. Get the task afforded by these dispositions
3. Find the common tasks when there is more than one object
*/

assert_objects_in_scene([ObjectType | Rest]) :-
    writeln('nothing2'),
    tell( [ is_physical_object(Object),
        has_type(Object, ObjectType)]),
    assert_objects_in_scene(Rest),
    get_task_for_objects_(ObjectType, Task).
    
    /* subclass_of(sa:'Cucumber', C), 
    has_description(C, exactly(soma:hasDisposition, 1, C1)), 
    has_description(C1, intersection_of(L)), 
    member(Test, L), 
    has_description(Test, only(soma:'affordsTask', Task)). */
    %To get role -  subclass_of(soma:'Bread', Desc), has_description(Desc, only(dul:hasRole, X)).%
    %to get task - subclass_of(sa:'Splitting', Desc), has_description(Desc, only(soma:affordsTask, Task)).%
    
assert_objects_in_scene([]) :- writeln('nothing').

get_task_for_objects_(ObjectType, Task) :-
    get_dispositions_(ObjectType, Dispositions),

    subclass_of(Disposition, Desc1), 
    has_description(Desc1, only(soma:affordsTask, Task)).

get_dispositions_(ObjectType, Disposition) :-
    ((subclass_of(ObjectType, Desc), 
    has_description(Desc, some(soma:hasDisposition, Disposition)));
    (transitive(subclass_of(ObjectType, Desc)), 
    has_description(Desc, only(dul:hasRole, Role)),
    is_restriction(R1),
    is_restriction(R1, only(soma:affordsTrigger, Role)), 
    transitive(subclass_of(Disposition, R1))
    )).

%create_affordances()