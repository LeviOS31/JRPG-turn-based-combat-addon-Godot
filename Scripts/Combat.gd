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

func SetupPerTeam():
	for i:int in PlayerTeam.size():
		var instance : JRPGBaseBattleChar = load("res://Scenes/BattleChars/" + PlayerTeam[i].species.Name + "/Battle.tscn").instantiate()
		
