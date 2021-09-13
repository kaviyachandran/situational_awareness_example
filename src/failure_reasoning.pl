:- module(failure_reasoning,
    [   init_episode/0,
        satisfies_scene(+, +, -),
        get_failure_type(+, +, -)
    ]).


:- use_module(library('model/DUL/Event.pl'), 
            [executes_task/2
            ]).
% :- use_module(library('lang/terms/is_a')).

% Idea
% - Compare the state to know if there is a failure
% - based on the state of the object, we can infer the type of failure - Classifying failure like we classified facings
% - Recovery based on the failure type

satisfies_scene(StateOutcome, Action, RoleTypes) :-
    % get task
    executes_task(Action, TaskPerformed), 
    has_type(TaskPerformed, TaskType),
    subclass_of(TaskType, dul:'Task'),

    triple(Tr, rdf:type, soma:'StateTransition'), 
    triple(Tr, dul:'includesEvent', Event), 
    executes_task(Event, STask), 
    has_type(STask, TaskType),

    % Get Terminal scene
    triple(Tr, soma:hasTerminalScene, TransformedScene),
    findall(RoleType,
        (triple(TransformedScene, sa:usesRole, Role),
        has_type(Role, RoleType),
        subclass_of(RoleType, dul:'Concept'),
        \+ get_object_of_role_(StateOutcome, RoleType, Object)),
    RoleTypes).

get_object_of_role_(State, RoleType, Obj) :-
    has_participant(State, Object),
    has_role(Object, StateRole),
    has_type(StateRole, RoleType),
    writeln(Object).

get_role_of_object_(State, ObjectType, RoleType) :-
    has_participant(State, Object),
    has_type(Object, ObjectType),
    has_role(Object, Role),
    has_type(Role, RoleType).

get_failure_type(RolesNotSatisfied, ActionPerformed, StateOutcome, FailureType) :-
    % get the participants of the action
    % 
    % get_object_undergoing_transform -> 
    % compare the object which has undergone change from hte action executed to state outcome
    get_role_of_object_(State, soma:'Bread', BreadRoleType),
    get_role_of_object_(State, sa:'BreadSlice', SliceRoleType);true,
    (BreadRoleType is sa:'UnalteredObject') -> 
        tell([has_type(FailureType, failure:'FinishedFailure'), triple(ActionPerformed, rdf:type, FailureType)]);
    (BreadRoleType is soma:'DestroyedObject') -> 
        tell([has_type(FailureType, failure:'ObjectLost'), triple(ActionPerformed, rdf:type, FailureType)]);
    (BreadRoleType is soma:'ShapedObject', BreadSliceType is soma:'DestroyedObject') -> tell();
    writeln('Failure type unknown')
    true.

test_scene(State,TransformedScene) :-
    writeln('hello'),
    findall(RoleType,
        (triple(TransformedScene, sa:usesRole, Role),
        has_type(Role, RoleType),
        subclass_of(RoleType, dul:'Concept'),
        \+ get_role_(State, RoleType, Object)),
    Roles),
    writeln(Roles).
   
%     findall(UnsatisfiedRole,
%         (triple(TransformedScene, sa:usesRole, UnsatisfiedRole),
%         has_role(Object, UnsatisfiedRole),
%         \+ has_participant(State, Object)),
%     Roles),
%     length(Roles, L),
%     (L > 0) -> False; True.



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

load_owl_(Package, FilePath) :-
    ros_package_path(Package, X),
    atom_concat(X, FilePath, Filename),
    tripledb_load(Filename).
    
load_urdf_(Name, Package, FilePath) :-
    ros_package_path(Package, X),
    atom_concat(X, FilePath, Filename), 
    urdf_load_file(Name, Filename).

% start_episode(TaskType, Action) :-
%     init_episode,
%     get_time(Now),
%     tell([is_action(Action),
%     is_task(Task),
%     has_type(Task, TaskType), % soma:'Cutting' -> Task
%     executes_task(Action, Task),
%     action_active(Action),
%     ]).

% % add_subaction(ParentAction, Action, TaskType, Participants)
% % Outcome no slices cut - action failed
% % input - tasktype 
% % PlacementFailure -> Knife not placed at right pose on the object?


% cutting_action_episode :-
%     %ParentAct
%     tell([
%         is_action(A),
%         has_type(A, soma:'Slicing')
%         ]),
%     grasping_event(GraspingAct),

%     tell(has_subevent(A, GraspingAct)),
    
   

% grasping_event(GraspingAct) :-
%     %GraspingPre ?
%     %GraspingPost
%     tell([
%         is_Event(PostGrasp),
%         has_type(PostGrasp, soma:'ContactState'),
%         has_type(O2, soma:'Gripper'),
%         has_type(O1, soma:'CuttingTool'),
%         has_participant(PostGrasp, O1),
%         has_participant(PostGrasp, O2)
%         ]),
%     % Grasping
%     tell([
%         is_action(GraspingAct),
%         has_type(Task, soma:'Grasping'),
%         executes_task(GraspingAct,Task),
%         has_participant(GraspingAct, O1),
%         has_participant(GraspingAct, O2),
%         has_type(Role1, soma:'Accessor'),
%         has_type(Role2, sa:'HeldObject'),
%         has_role(O2, Role1),
%         has_role(O1, Role2),
%         has_type(Motion, soma:'PowerGrasp'),
%         is_classified_by(GraspingAct,Motion)
%         ]),
%     tell(triple(GraspingAct, dul:hasPostcondition, PostGrasp)).

% % Approach -> move to 
% moving_arm_event(MoveAction) :
%     %PreArm movement
%     tell([
%         is_Event(PreMove),
%         has_type(PreMove, soma:'ContactState'),
%         has_type(O1, soma:'CuttingBoard'),
%         has_type(O2, soma:'Bread'),
%         has_participant(PreMove, O1),
%         has_participant(PreMove, O2),
%         has_type(R1, soma),
%         has_type(R2, ),
%         has_role(),
%         has_role()
%     ]),
    
%     % MoveAction involves : MovingTo (Navigating to the object bread) Assume it is already close to the object and 
%     % AssumingArmPose (Moving Arm close to bread)
%     tell([
%     is_action(MovingArmAction),
%     has_type(MovingArmAction, soma:'AssumingArmPose'),
%     has_type(Obj1, soma:'Arm'),
%     has_type(Obj2, soma:'CuttingTool'),
%     has_particpant(MovingArmAction, Obj1),
%     has_particpant(MovingArmAction, Obj2),
%     has_type(Motion,soma:'LimbMotion'),
%     is_classified_by(MovingArmAction, Motion),
%     has_type(Role, soma:'MovedObject'),
%     has_role(Obj2, Role)
%     ]),
    

