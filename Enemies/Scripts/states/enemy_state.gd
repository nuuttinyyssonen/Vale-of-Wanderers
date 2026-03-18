class_name EnemyState extends Node

var enemy : GoblinEnemy
var goblin_state_machine : GoblinStateMachine

func init() -> void:
	pass

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func Process(_delta: float) -> EnemyState:
	return null

func Physics(_delta: float) -> EnemyState:
	return null
