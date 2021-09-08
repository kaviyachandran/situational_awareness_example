:- module(log_event,
    [ 
        init_episode/0,
        start_episode(+, -)
    ]).


/* 1. load the agent, environment - urdf, owl
2. */

init_episode :-
% pr2 - knowrob/urdf
% iai_kitchen - iai_maps package, ../iai_maps/iai_kitchen/urdf
    load_urdf_(pr2, 'knowrob', '/urdf/pr2.urdf'),
    load_urdf_(iai_kitchen, 'iai_kitchen', 
        'urdf/IAI_kitchen.urdf'),
    load_owl_('knowrob', '/owl/robots/PR2.owl'),
    load_owl_('iai_kitchen', '/owl/iai-kitchen-knowledge.owl'),
    load_owl_('iai_kitchen', '/owl/iai-kitchen-objects.owl').

start_episode(TaskType, Action) :-
    init_episode,
    get_time(Now),
    tell([is_action(Action),
    is_task(Task),
    has_type(Task, TaskType), % soma:'Cutting' -> Task
    executes_task(Action, Task),
    action_active(Action),
    occurs(Action) since Now
    ]).

% add_subaction(ParentAction, Action, TaskType, Participants)
% Outcome no slices cut - action failed
% input - tasktype 
% PlacementFailure -> Knife not placed at right pose on the object?


load_owl_(Package, FilePath) :-
    ros_package_path(Package, X),
    atom_concat(X, FilePath, Filename),
    tripledb_load(Filename).
    
load_urdf_(Name, Package, FilePath) :-
    ros_package_path(Package, X),
    atom_concat(X, FilePath, Filename), 
    urdf_load_file(Name, Filename).