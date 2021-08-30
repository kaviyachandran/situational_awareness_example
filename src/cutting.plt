:- use_module(library('cutting')).

:- tripledb_load(
    'package://situation_awareness_example/owl/situation_awareness_example.owl',
    [ namespace(sa, 
      'http://www.ease-crc.org/ont/situation_awareness_example.owl#')
    ]).

:- rdf_db:rdf_register_ns(soma,
    'http://www.ease-crc.org/ont/SOMA.owl#', [keep(true)]).

:- use_module(library('db/tripledb'), [tripledb_load/2, tripledb_load/1]).
:- use_module(library('lang/terms/transitive.pl'),   [ transitive/1 ]).

:- begin_tests('cutting').

%% Find the object that has disposition that affords the specific task

/* test('assert obj') :-
    gtrace,
    assert_objects_in_scene(['http://www.ease-crc.org/ont/situation_awareness_example.owl#Cucumber', 
        'http://www.ease-crc.org/ont/SOMA.owl#Bread',
        'http://www.ease-crc.org/ont/situation_awareness_example.owl#BreadKnife']). */

% test('owl load') :-
%     gtrace,
%     tripledb_load('package://situation_awareness_example/owl/situation_awareness_example.owl').

create_objects(OT, O) :-
    tell([is_physical_object(O),has_type(O, OT)]).

test('get tasks of objects') :-
    %OT is sa:'BreadKnife',
   % gtrace,
    %findall(Task,
        % (transitive(subclass_of(sa:'Cucumber', C)),
        % has_description(C, some(soma:hasDisposition, C1)), 
        % has_description(C1, intersection_of(L)),
        % member(Test, L), 
        % has_description(Test, only(soma:'affordsTask', Task))),
        % % Tasks),
    create_objects('http://www.ease-crc.org/ont/situation_awareness_example.owl#Cucumber', O),
    create_objects('http://www.ease-crc.org/ont/SOMA.owl#Bread', O1),
    get_tasks([O,O1], Tasks),
    writeln(Tasks).

test('get objects for the task') :-
    Task = 'http://www.ease-crc.org/ont/SOMA.owl#Cutting',
    OT = ['http://www.ease-crc.org/ont/situation_awareness_example.owl#Cucumber', 'http://www.ease-crc.org/ont/SOMA.owl#Bread'],
    findall(O,
        (member(O, OT),
        transitive(subclass_of(O, C)),
        has_description(C, some(soma:hasDisposition, C1)), 
        has_description(C1, intersection_of(L)),
        member(Test, L), 
        has_description(Test, only(soma:'affordsTask', TaskType)),
        transitive(subclass_of(TaskType, Task))),
    Os),
    writeln(Os),
    length(Os, Len),
    gtrace,
    ((Len is 0 -> (print_message('warn', "These objects do not afford to do the task"), OList = ['Trigger', 'Bearer']));
    get_missing_objects_(Os, [], OList)),
    writeln(OList). 

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

create_list_([L | R], Temp, A) :-
    X is L+1,
    Temp1 = [X | Temp],
    create_list_(R, Temp1, A).

create_list_([], Temp, Temp).

% test('recursion list') :-
%     create_list_([2,3,4,5,6], [], A),
%     writeln(A).


:- end_tests('cutting').

 

%test('get task') :-
    


% C: http://www.ease-crc.org/ont/situation_awareness_example.owl#_:Description15,
% Task: http://www.ease-crc.org/ont/situation_awareness_example.owl#Sawing,
% L: [u'http://www.ease-crc.org/ont/situation_awareness_example.owl#Splitting', u'http://www.ease-crc.org/ont/situation_awareness_example.owl#_:Description17', u'http://www.ease-crc.org/ont/situation_awareness_example.owl#_:Description18'],
% Val: http://www.ease-crc.org/ont/situation_awareness_example.owl#_:Description16

 %To get role -  subclass_of(soma:'Bread', Desc), has_description(Desc, only(dul:hasRole, X)).%
    %to get task - subclass_of(sa:'Splitting', Desc), has_description(Desc, only(soma:affordsTask, Task)).%d