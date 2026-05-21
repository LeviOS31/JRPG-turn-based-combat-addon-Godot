extends Node2D

enum TurnManagerStyle {
	## per turn the player can choose all of the characters to do something once
	PerTeam,
	## per turn the player get to choose the action of one character in the order of [color=green]ally1,ally2,ally3[/color],[color=red]enemy1,enemy2,enemy3[/color]
	OrderTeam,
	## per turn the player get to choose the action of one character in the order of [color=green]ally1[/color],[color=red]enemy1[/color],[color=green]ally2[/color],[color=red]enemy2[/color],[color=green]ally3[/color],[color=red]enemy3[/color]
	OrderAternating,
	## the turn order gets decided by the [color=yellow][b]speed[/b][/color] stat of the character
	OrderStat,
	## the turn order gets decided by the [color=yellow][b]speed[/b][/color] stat of the character and this stat can be affected mid battle
	LooseOrderStat,
}

## choice for which [b]TurnManager[/b] you want to use in combat
@export var turnmanagerstyle: TurnManagerStyle = TurnManagerStyle.PerTeam
@export var PlayerTeamNode: Node2D
@export var EnemyTeamNode: Node2D
## array of character for the players team [color=green][b]3 max[/b][/color]
var PlayerTeam: Array[JRPGCharInstance]
## array of character for the enemy team [color=green][b]3 max[/b][/color]
var EnemyTeam: Array[JRPGCharInstance]

func start():
	match turnmanagerstyle:
		TurnManagerStyle.PerTeam:
			var preinstance = load("res://Scripts/TurnManagers/TurnManagerPerTeam.gd")
			var instance : JRPGTurnManager = preinstance.instantiate()
			add_child(instance)
			SetupPerTeam()
		TurnManagerStyle.OrderTeam:
			pass
		TurnManagerStyle.OrderAternating:
			pass
		TurnManagerStyle.OrderStat:
			pass
		TurnManagerStyle.LooseOrderStat:
			pass

func LoadChars() -> Array[JRPGCharInstance]: 
	var characters: Array[JRPGCharInstance] 
	
	for i:int in PlayerTeam.size():
		var instance : JRPGBaseBattleChar = load("res://Scenes/BattleChars/" + PlayerTeam[i].species.Name + "/Battle.tscn").instantiate()
		instance.add_to_group("BattleChar")
		instance.Team = JRPGEnums.Team.Player
		characters.push_back(instance)
		PlayerTeamNode.add_child(instance)
		instance.global_position = PlayerTeamNode.get_child(i).global_position - Vector2(450,0)
	
	for i:int in EnemyTeam.size():
		var instance : JRPGBaseBattleChar = load("res://Scenes/BattleChars/" + PlayerTeam[i].species.Name + "/Battle.tscn").instantiate()
		instance.add_to_group("BattleChar")
		instance.Team = JRPGEnums.Team.Enemy
		characters.push_back(instance)
		EnemyTeamNode.add_child(instance)
		instance.global_position = EnemyTeamNode.get_child(i).global_position + Vector2(450,0)
	
	return characters

func SetupPerTeam():
	var Characters = LoadChars()
	
