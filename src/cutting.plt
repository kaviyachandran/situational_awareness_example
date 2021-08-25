:- use_module(library('cutting')).

:- tripledb_load(
    'package://situation_awareness_example/owl/situation_awareness_example.owl',
    [ namespace(sa, 
      'http://www.ease-crc.org/ont/situation_awareness_example.owl#')
    ]).

:- rdf_db:rdf_register_ns(soma,
    'http://www.ease-crc.org/ont/SOMA.owl#', [keep(true)]).

:- begin_tests('cutting').

test('assert obj') :-
    gtrace,
    assert_objects_in_scene(['http://www.ease-crc.org/ont/situation_awareness_example.owl#Cucumber', 
        'http://www.ease-crc.org/ont/SOMA.owl#Bread',
        'http://www.ease-crc.org/ont/situation_awareness_example.owl#BreadKnife']).


:- end_tests('cutting').