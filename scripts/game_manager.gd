extends Node

signal kill_count_changed(new_count: int)

var kill_count: int = 0:
	set(value):
		kill_count = value
		kill_count_changed.emit(kill_count)

func add_kill() -> void:
	kill_count += 1

func reset_kills() -> void:
	kill_count = 0
