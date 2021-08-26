:- use_module(library('cutting')).

/* :- tripledb_load(
    'package://situation_awareness_example/owl/situation_awareness_example.owl',
    [ namespace(sa, 
      'http://www.ease-crc.org/ont/situation_awareness_example.owl#')
    ]). */

:- rdf_db:rdf_register_ns(soma,
    'http://www.ease-crc.org/ont/SOMA.owl#', [keep(true)]).

:- use_module(library('db/tripledb'), [tripledb_load/2, tripledb_load/1]).

:- begin_tests('cutting').

/* test('assert obj') :-
    gtrace,
    assert_objects_in_scene(['http://www.ease-crc.org/ont/situation_awareness_example.owl#Cucumber', 
        'http://www.ease-crc.org/ont/SOMA.owl#Bread',
        'http://www.ease-crc.org/ont/situation_awareness_example.owl#BreadKnife']). */

test('owl load') :-
    gtrace,
    tripledb_load('package://situation_awareness_example/owl/situation_awareness_example.owl').


:- end_tests('cutting').