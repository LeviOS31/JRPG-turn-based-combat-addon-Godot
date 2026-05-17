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

@export_group("Mechanics")
## Does this modify a stat for the duration, or tick damage/healing every turn?
@export var EffectType : JRPGEnums.EffectType
## Which stat gets affected (e.g., HP, MP, ATK, DEF)
@export var statTarget : JRPGEnums.StatTarget
## Is the amount a flat value (+10) or a percentage (+10%)?
@export var CalculationType : JRPGEnums.CalcType
## How much the stat is affected. (Positive for buffs/healing, negative for debuffs/damage)
@export var Amount : int
