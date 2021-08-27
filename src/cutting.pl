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
*/

assert_objects_in_scene([ObjectType | Rest]) :-
    writeln('nothing2'),
    tell( [ is_physical_object(Object),
        has_type(Object, ObjectType)]),
    assert_objects_in_scene(Rest),
    has_disposition(ObjectType, Disposition).
    
    /* subclass_of(sa:'Cucumber', C), 
    has_description(C, exactly(soma:hasDisposition, 1, C1)), 
    has_description(C1, intersection_of(L)), 
    member(Test, L), 
    has_description(Test, only(soma:'affordsTask', Task)). */
    %To get role -  subclass_of(soma:'Bread', Desc), has_description(Desc, only(dul:hasRole, X)).%
    %to get task - subclass_of(sa:'Splitting', Desc), has_description(Desc, only(soma:affordsTask, Task)).%
    
assert_objects_in_scene([]) :- writeln('nothing').

%create_affordances()