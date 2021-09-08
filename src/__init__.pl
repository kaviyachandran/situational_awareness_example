:- register_ros_package(knowrob).
:- register_ros_package(situation_awareness_example).

:- use_module(library('cutting')).

:- use_module(library('db/tripledb'), [tripledb_load/2, tripledb_load/1]).
            
:- tripledb_load('package://situation_awareness_example/owl/situation_awareness_example.owl', 
    [ namespace(sa, 'http://www.ease-crc.org/ont/situation_awareness_example.owl#')]).

- tripledb_load('package://failrecont/owl/failure_and_recovery.owl.owl', 
    [ namespace(failure, 'http://www.ease-crc.org/ont/failure_and_recovery.owl#')]).

:- rdf_db:rdf_register_ns(soma,
    'http://www.ease-crc.org/ont/SOMA.owl#', [keep(true)]).