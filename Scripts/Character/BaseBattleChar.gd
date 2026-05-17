extends Node2D
class_name JRPGBaseBattleChar

var Animator : AnimationPlayer
var Char : JRPGCharInstance
var StatusEffects : Array[JRPGActiveEffectInstance]
var Team : JRPGEnums.Team

var AvailableAction := false

func _ready() -> void:
	Animator = $Animationplayer

func playstart(pos : Vector2, Char : Node2D):
	if Char != self:
		pass
	
	var tween = get_tree().create_tween()
	
	var time := 0.05 * global_position.distance_to(pos)
	tween.tween_property(self, "global_position", pos, time)
	
	if pos.x > global_position.x:
		Animator.play("WalkRight")
	elif pos.x < global_position.x:
		Animator.play("WalkLeft")
		
	await tween.finished
	Animator.play("Idle")
	JRPGSignalBus.instance.StartDone.emit()

func _on_select_area_mouse_entered() -> void:
	JRPGSignalBus.instance.MouseOver.emit(self)

func _on_select_area_mouse_exited() -> void:
	JRPGSignalBus.instance.MouseOut.emit(self)

func _on_select_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	JRPGSignalBus.instance.Clicked.emit(self)
