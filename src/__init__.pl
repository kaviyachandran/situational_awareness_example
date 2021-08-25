:- register_ros_package(knowrob).

:- use_module(library('cutting.pl')).

:- use_module(library('db/tripledb'), 
              [tripledb_load/2]).
            
:- tripledb_load(
    'package://situation_awareness_example/owl/situation_awareness_example.owl',
    [ namespace(sa, 
      'http://www.ease-crc.org/ont/situation_awareness_example.owl#')
    ]).