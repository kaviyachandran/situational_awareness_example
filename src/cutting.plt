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
    Task is 'http://www.ease-crc.org/ont/SOMA.owl#Cutting',
    OT is ['http://www.ease-crc.org/ont/situation_awareness_example.owl#Cucumber', 'http://www.ease-crc.org/ont/SOMA.owl#KitchenKnife'],
    findall(O,
        (member_of(O, OT),
        transitive(subclass_of(O, C)),
        has_description(C, some(soma:hasDisposition, C1)), 
        has_description(C1, intersection_of(L)),
        member(Test, L), 
        has_description(Test, only(soma:'affordsTask', Task)),
    Os),
    length(Os, Len),
    ((Len is 0 -> print('warn', "These objects do not afford to do the task"),
                OList = ['Trigger', 'Bearer']);
    get_missing_objects_(Os, Task, [], OList)).

get_missing_objects_([O | R], Task, Temp, OList) :-
    compare_objects(O, R, Task, Miss),
    append(Miss, Temp, Temp1),
    get_missing_objects_(R, Task, Temp1, OList).

compare_objects(O, R, Miss) :-
    transitive(subclass_of(sa:'Cucumber', C)), 
    has_description(C, some(soma:hasDisposition, C1)), 
    has_description(C1, intersection_of(L)), 
    member(Test, L), 
    has_description(Test, only(soma:'affordsTrigger', Desc)),
    has_description(Desc, only(dul:classifies, TriggerObjectType)),
    findall(TriggerObj,
        (member(Other, R),
        transitive(subclass_of(Other, TriggerObjectType))),
        Objs),
    length(Objs, L),
    L is 0 -> Miss is [TriggerObjectType]; Miss is [].

create_list_([L | R], Temp, A) :-
    X is L+1,
    Temp1 = [X | Temp],
    create_list_(R, Temp1, A).

create_list_([], Temp, Temp).

% test('recursion list') :-
%     create_list_([2,3,4,5,6], [], A),
%     writeln(A).


:- end_tests('cutting').

 


% C: http://www.ease-crc.org/ont/situation_awareness_example.owl#_:Description15,
% Task: http://www.ease-crc.org/ont/situation_awareness_example.owl#Sawing,
% L: [u'http://www.ease-crc.org/ont/situation_awareness_example.owl#Splitting', u'http://www.ease-crc.org/ont/situation_awareness_example.owl#_:Description17', u'http://www.ease-crc.org/ont/situation_awareness_example.owl#_:Description18'],
% Val: http://www.ease-crc.org/ont/situation_awareness_example.owl#_:Description16
