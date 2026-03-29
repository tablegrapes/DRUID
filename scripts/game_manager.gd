extends Node

signal kill_count_changed(new_count: int)
signal experience_changed(new_experience: int)

var kill_count: int = 0:
	set(value):
		kill_count = value
		kill_count_changed.emit(kill_count)

var experience: int = 0:
	set(value):
		experience = value
		experience_changed.emit(experience)

func add_kill() -> void:
	kill_count += 1

func add_experience(amount: int) -> void:
	experience += amount

func reset_kills() -> void:
	kill_count = 0

func reset_experience() -> void:
	experience = 0
