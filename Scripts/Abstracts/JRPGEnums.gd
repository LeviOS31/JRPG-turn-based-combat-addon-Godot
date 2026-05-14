class_name JRPGEnums

enum DamageType{
	Damage,
	Health,
}

enum AttackType{
	Physical,
	Magi
}

enum StatusEffects{
	Buff,
	Debuff,
	## Damage over time
	DOT,
	## Heal over time
	HOT,  
	Custom
}

enum Target{
	##Target a single Enemy
	Enemy, 
	##Target all Enemies
	All_Enemies,
	##Target single Ally
	Ally,
	##Target all Allies
	All_Allies,
	##Target Self
	Self
}

enum Elements{
	Fire,
	Ice,
	Earth,
	Poison,
	Physical,
	Magik
}

enum StatTarget{
	Damage,
	Hit_Chance,
	Max_Health,
	Defense,
}

enum  Team{
	Player,
	Enemy
}
