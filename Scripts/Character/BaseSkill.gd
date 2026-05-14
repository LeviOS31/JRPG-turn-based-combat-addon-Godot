extends Resource
class_name JRPGBaseSkill

@export var Name : String
## Chance that the attack will even hit the target (Probably put to 100 for healing skills)
@export var HitChance : int
#@export var Type : JRPGEnums.AttackType (TO BE RECONSIDERD)
## how much damage the attack can do (effected by strength and weakness of target)
@export var Damage : int
## For if the attack heals of damages
@export var DamageType : JRPGEnums.DamageType
## Name of the animation in the instance of BaseBattle animationplayer
@export var AnimationName : String
## Element of the attack (for weakness and strength)
@export var Element : JRPGEnums.Elements
## Type that can be target by the skill
@export var Target : JRPGEnums.Target
## effect that can lingers after the skill
@export var Effect : JRPGBaseEffect
## cost of the skill in terms of something like [b]Mana[/b] 0 = no cost
@export var Cost : int 
