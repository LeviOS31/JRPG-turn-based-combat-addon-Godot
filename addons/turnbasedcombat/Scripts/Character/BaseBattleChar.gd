extends Node2D
class_name JRPGBaseBattleChar

var Animator : AnimationPlayer
var Char : JRPGCharInstance
var StatusEffects : Dictionary[JRPGBaseEffect,int]
var Team : JRPGEnums.Team

var AvailableAction := false

func _ready() -> void:
	Animator = $Animationplayer

func playstart(pos : Vector2):
	var tween = get_tree().create_tween()
	
	var time := 0.01 * global_position.distance_to(pos)
	tween.tween_property(self, "global_position", pos, time)
	
	if pos.x > global_position.x:
		Animator.play("WalkRight")
	elif pos.x < global_position.x:
		Animator.play("WalkLeft")
		
	await tween.finished
	Animator.play("Idle")
	JRPGSignalBus.instance.StartDone.emit()

func ApplyDamage(Amount: int, DamageType: JRPGEnums.DamageType, Element: JRPGEnums.Elements, Caster: JRPGBaseBattleChar):
	if DamageType == JRPGEnums.DamageType.Damage:
		Char.current_hp -= Amount;
	elif DamageType == JRPGEnums.DamageType.Health:
		Char.current_hp = clampi(Char.current_hp + Amount, Char.current_hp, Char.max_hp)

func update_state_highlight(state: JRPGEnums.HighlightState, selected: JRPGBaseBattleChar, hovered: JRPGBaseBattleChar) -> void:
	HighLight(false, Color(0.781, 0.781, 0.781, 1.0))
	match state:
		JRPGEnums.HighlightState.SELECTABLE_PLAYER:
			if Team != JRPGEnums.Team.Player: 
				HighLight(false, Color(0.781, 0.781, 0.781, 1.0))
				
			if self == selected:
				HighLight(true, Color(0.97, 1.0, 0.445, 1.0))
			elif self == hovered && AvailableAction:
				HighLight(true, Color(0.97, 1.0, 0.445, 1.0))
			elif AvailableAction:
				HighLight(true, Color(0.781, 0.781, 0.781, 1.0))

		JRPGEnums.HighlightState.TARGET_ENEMY:
			# Special case: Always keep the acting player highlighted yellow
			if self == selected:
				HighLight(true, Color(0.97, 1.0, 0.445, 1.0))
				return
				
			if Team == JRPGEnums.Team.Enemy:
				var red = Color(1.0, 0.242, 0.242, 1.0) if self == hovered else Color(0.473, 0.0, 0.0, 1.0)
				HighLight(true, red)

		JRPGEnums.HighlightState.TARGET_ALLY:
			if Team == JRPGEnums.Team.Player:
				if self == hovered:
					HighLight(true, Color(0.0, 0.742, 0.0, 1.0))
				elif self == selected:
					HighLight(true, Color(0.97, 1.0, 0.445, 1.0))
				else:
					HighLight(true, Color(0.0, 0.512, 0.0, 1.0))


func _on_select_area_mouse_entered() -> void:
	JRPGSignalBus.instance.MouseOver.emit(self)

func _on_select_area_mouse_exited() -> void:
	JRPGSignalBus.instance.MouseOut.emit(self)

func _on_select_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	JRPGSignalBus.instance.Clicked.emit(self)

func HighLight(enable: bool, color: Color):
	material.set_shader_parameter("outline_enabled", enable)
	material.set_shader_parameter("outline_color", color)
