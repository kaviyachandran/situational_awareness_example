:- module(cutting,
    [ 
        get_tasks(+, -),
        
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

get_tasks([Object | Rest], TaskList) :-
    get_potential_tasks_([Object | Rest], [], TaskList).    

get_potential_tasks_([O | R], Temp, TaskList) :-
    has_type(O, ObjectType),
    triple(ObjectType,rdfs:subClassOf,dul:'PhysicalObject'),
    get_task_for_objects_(ObjectType, Tasks),
    append(Tasks, Temp, Temp1),
    get_potential_tasks_(R, Temp1, TaskList).
    
get_potential_tasks_([], Temp, Temp).

    %To get role -  subclass_of(soma:'Bread', Desc), has_description(Desc, only(dul:hasRole, X)).%
    %to get task - subclass_of(sa:'Splitting', Desc), has_description(Desc, only(soma:affordsTask, Task)).%

get_task_for_objects_(ObjectType, Tasks) :-
   findall(Task,
        (transitive(subclass_of(ObjectType, C)),
        has_description(C, some(soma:hasDisposition, C1)), 
        has_description(C1, intersection_of(L)),
        member(Test, L), 
        has_description(Test, only(soma:'affordsTask', Task))),
        Tasks),
    writeln(Tasks).

% get_dispositions_(ObjectType, Disposition) :-
%     ((subclass_of(ObjectType, Desc), 
%     has_description(Desc, some(soma:hasDisposition, Disposition)));
%     (transitive(subclass_of(ObjectType, Desc)), 
%     has_description(Desc, only(dul:hasRole, Role)),
%     is_restriction(R1),
%     is_restriction(R1, only(soma:affordsTrigger, Role)), 
%     transitive(subclass_of(Disposition, R1))
%     )).

%create_affordances()