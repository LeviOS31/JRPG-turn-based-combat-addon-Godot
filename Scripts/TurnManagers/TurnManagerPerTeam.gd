extends Node2D
class_name JRPGTurnManager

var turn := 0;

func _ready() -> void:
	pass

func Turn():
	if turn == 0:
		turn = 1
		JRPGSignalBus.instance.emit_signal("PlayerTurn")
	else:
		turn = 0
		JRPGSignalBus.instance.emit_signal("EnemyTurn")
