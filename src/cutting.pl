:- module(cutting,
    [ 
        get_potential_tasks(+, -),
        get_missing_objects_for_task(+, +, -)
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

get_potential_tasks([Object | Rest], TaskList) :-
    get_potential_tasks_([Object | Rest], [], TaskList). 

get_missing_objects_for_task(Objects, Task, MissingObj) :-
    findall(O,
        (member(O, Objects),
        transitive(subclass_of(O, Desc)),
        has_description(Desc, some(soma:hasDisposition, Disp)),
        has_description(Disp, intersection_of(L)),
        member(Desc1, L),
        has_description(Desc1, only(soma:'affordsTask', TaskType)),
        transitive(subclass_of(TaskType, Task))),
    Os),
    length(Os, Len),
    gtrace,
    ((Len is 0 -> (print_message('warn', "These objects do not afford to do the task"), OList = ['Trigger', 'Bearer']));
    get_missing_objects_(Os, [], OList)).

get_missing_objects_([O | R], Temp, OList) :-
    compare_objects(O, R, Miss),
    (\+ground(Miss) -> Miss = []; true),
    append(Miss, Temp, Temp1),
    get_missing_objects_(R, Temp1, OList).

get_missing_objects_([], Temp, Temp).

compare_objects(_, [], _).

compare_objects(O, R, Miss) :-
    transitive(subclass_of(O, C)),
    has_description(C, some(soma:hasDisposition, C1)),
    has_description(C1, intersection_of(L)),
    member(Test, L),
    has_description(Test, only(soma:'affordsTrigger', Desc)),
    has_description(Desc, only(dul:classifies, TriggerObjectType)),
    findall(TriggerObj,
        (member(TriggerObj, R),
        transitive(subclass_of(TriggerObj, TriggerObjectType))),
        Objs),
    length(Objs, Length),
    Length is 0 -> Miss = [TriggerObjectType] ; true.

get_potential_tasks_([O | R], Temp, TaskList) :-
    has_type(O, ObjectType),
    triple(ObjectType,rdfs:subClassOf,dul:'PhysicalObject'),
    get_task_for_objects_(ObjectType, Tasks),
    append(Tasks, Temp, Temp1),
    get_potential_tasks_(R, Temp1, TaskList).
    
get_potential_tasks_([], Temp, Temp).

get_task_for_objects_(ObjectType, Tasks) :-
   findall(Task,
        (transitive(subclass_of(ObjectType, C)),
        has_description(C, some(soma:hasDisposition, C1)), 
        has_description(C1, intersection_of(L)),
        member(Test, L), 
        has_description(Test, only(soma:'affordsTask', Task))),
        Tasks),
    writeln(Tasks).
