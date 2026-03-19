class_name PlayerStateMachine
extends Node

var states: Array[State]
var prev_state: State
var current_state: State

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	if current_state:
		ChangeState(current_state.Process(delta))

func _physics_process(delta: float) -> void:
	if current_state:
		ChangeState(current_state.Physics(delta))

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		ChangeState(current_state.HandleInput(event))

func Initialize(_actor: CharacterBody2D) -> void:
	states = []

	for c in get_children():
		if c is State:
			c.actor = _actor
			states.append(c)
	
	if states.size() == 0:
		return
	
	states[0].actor = _actor
	states[0].state_machine = self
	
	for state in states:
		state.init()

	ChangeState(states[0])
	process_mode = Node.PROCESS_MODE_INHERIT

func ChangeState(new_state: State) -> void:
	if new_state == null or new_state == current_state:
		return

	if current_state:
		current_state.Exit()

	prev_state = current_state
	current_state = new_state
	current_state.Enter()
