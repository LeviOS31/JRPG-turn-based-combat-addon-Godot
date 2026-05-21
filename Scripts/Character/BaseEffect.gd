extends Resource
class_name JRPGBaseEffect

@export_group("Identity")
@export var Name : String
## The visual of the effect. Played at the position of the affected char. 
## Examples: fire particles for burning, blood for bleeding.
@export var EffectVis : PackedScene

@export_group("Application")
## Chance (0 to 100) that the effect successfully applies to the target.
@export_range(0, 100) var HitChance : int = 100
## Amount of turns the effect stays active.
@export var Duration : int = 3
## Dictates what happens when a effect that is already effecting a target gets cast on the target again
@export var DurationType: JRPGEnums.EffectDuration

@export_group("Mechanics")
## Does this modify a stat for the duration, or tick damage/healing every turn?
@export var EffectType : JRPGEnums.EffectType = JRPGEnums.EffectType.Tickperturn
## Which stat gets affected (e.g., HP, MP, ATK, DEF)
@export var statTarget : JRPGEnums.StatTarget = JRPGEnums.StatTarget.Health
## Is the amount a flat value (+10) or a percentage (+10%)?
@export var CalculationType : JRPGEnums.CalcType = JRPGEnums.CalcType.flat
## How much the stat is affected. (Positive for buffs/healing, negative for debuffs/damage)
@export var Amount : int = 1

func Attach(caster: JRPGBaseBattleChar, target: JRPGBaseBattleChar):
	if !EffectVis:
		push_warning("Error: No effect visual specified for: " + Name)
	
	randomize()

	if HitChance < 100:
		if !randi_range(0, 99) < HitChance:
			return
	
	if target.StatusEffects.has(self):
		match DurationType:
			JRPGEnums.EffectDuration.Add:
				target.StatusEffects[self] = target.StatusEffects[self] + Duration 
			JRPGEnums.EffectDuration.Refresh:
				target.StatusEffects[self] = Duration
	else:
		target.StatusEffects[self] = Duration

func Apply(target: JRPGBaseBattleChar):
	print("Apply effect to " + target.Char.species.Name)
	pass
