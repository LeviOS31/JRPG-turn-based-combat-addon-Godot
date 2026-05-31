extends RefCounted
class_name JRPGActiveEffectInstance

var Effect : JRPGBaseEffect
var CurrentDuration : int

func _init(base_effect: JRPGBaseEffect):
	Effect = base_effect
	CurrentDuration = base_effect.Duration
