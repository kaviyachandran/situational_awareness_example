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
    ]).

% add_subaction(ParentAction, Action, TaskType, Participants)
% Outcome no slices cut - action failed
% input - tasktype 
% PlacementFailure -> Knife not placed at right pose on the object?


cutting_action_episode :-
    %ParentAct
    tell([
        is_action(A),
        has_type(A, soma:'Slicing')
        ]),
    grasping_event(GraspingAct),

    tell(has_subevent(A, GraspingAct)),
    
   

grasping_event(GraspingAct) :-
    %GraspingPre ?
    %GraspingPost
    tell([
        is_Event(PostGrasp),
        has_type(PostGrasp, soma:'ContactState'),
        has_type(O2, soma:'Gripper'),
        has_type(O1, soma:'CuttingTool'),
        has_participant(PostGrasp, O1),
        has_participant(PostGrasp, O2)
        ]),
    % Grasping
    tell([
        is_action(GraspingAct),
        has_type(Task, soma:'Grasping'),
        executes_task(GraspingAct,Task),
        has_participant(GraspingAct, O1),
        has_participant(GraspingAct, O2),
        has_type(Role1, soma:'Accessor'),
        has_type(Role2, sa:'HeldObject'),
        has_role(O2, Role1),
        has_role(O1, Role2),
        has_type(Motion, soma:'PowerGrasp'),
        is_classified_by(GraspingAct,Motion)
        ]),
    tell(triple(GraspingAct, dul:hasPostcondition, PostGrasp)).

% Approach -> move to 
moving_arm_event(MoveAction) :
    %PreArm movement
    tell([
        is_Event(PreMove),
        has_type(PreMove, soma:'ContactState'),
        has_type(O1, soma:'CuttingBoard'),
        has_type(O2, soma:'Bread'),
        has_participant(PreMove, O1),
        has_participant(PreMove, O2),
        has_type(R1, soma),
        has_type(R2, ),
        has_role(),
        has_role()
    ]),
    
    % MoveAction involves : MovingTo (Navigating to the object bread) Assume it is already close to the object and 
    % AssumingArmPose (Moving Arm close to bread)
    tell([
    is_action(MovingArmAction),
    has_type(MovingArmAction, soma:'AssumingArmPose'),
    has_type(Obj1, soma:'Arm'),
    has_type(Obj2, soma:'CuttingTool'),
    has_particpant(MovingArmAction, Obj1),
    has_particpant(MovingArmAction, Obj2),
    has_type(Motion,soma:'LimbMotion'),
    is_classified_by(MovingArmAction, Motion),
    has_type(Role, soma:'MovedObject'),
    has_role(Obj2, Role)
    ]),
    

load_owl_(Package, FilePath) :-
    ros_package_path(Package, X),
    atom_concat(X, FilePath, Filename),
    tripledb_load(Filename).
    
load_urdf_(Name, Package, FilePath) :-
    ros_package_path(Package, X),
    atom_concat(X, FilePath, Filename), 
    urdf_load_file(Name, Filename).