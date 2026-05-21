extends Node2D
class_name JRPGTurnManager

var PlayerTeam = Array[JRPGBaseBattleChar]
var EnemyTeam = Array[JRPGBaseBattleChar]
var turn := 0;

var TargetAlly: bool
var TargetEnemy: bool
var SelectedSkill: JRPGBaseSkill
var SelectedCharacter: JRPGBaseBattleChar

func _ready() -> void:
	JRPGSignalBus.instance.PlayerTurn.connect(CheckPlayerTurn)
	JRPGSignalBus.instance.EndTurn.connect(Turn)
	JRPGSignalBus.instance.Clicked.connect(SelectTarget)

func _physics_process(delta: float) -> void:
	#TODO: replace Highlight state
	if turn == 1:
		JRPGSignalBus.instance.UpdateHighlight.emit();
	else:
		JRPGSignalBus.instance.UpdateHighlight.emit();

func Turn():
	if turn == 0:
		turn = 1
		
		for i:int in PlayerTeam:
			PlayerTeam[i].AvailableAction = true
		
		JRPGSignalBus.instance.emit_signal("PlayerTurn")
		JRPGSignalBus.instance.SetHighlightState.emit(JRPGEnums.HighlightState.SELECTABLE_PLAYER)
	else:
		turn = 0
		JRPGSignalBus.instance.emit_signal("EnemyTurn")
		JRPGSignalBus.instance.SetHighlightState.emit(JRPGEnums.HighlightState.NONE)

func CheckPlayerTurn():
	var playerturn := true
	
	for i:int in PlayerTeam:
		var character: JRPGBaseBattleChar = PlayerTeam[i]
		if character.Char.IsAlive() && character.AvailableAction:
			playerturn = false;
			break;
	
	if playerturn:
		JRPGSignalBus.instance.EndTurn

func SelectTarget(MouseTarget: JRPGBaseBattleChar):
	if turn != 1 || MouseTarget == null:
		return;
	
	print("selected char: " + MouseTarget.to_string())
	
	if (TargetAlly && MouseTarget.Team == JRPGEnums.Team.Player) || (TargetEnemy && MouseTarget.Team == JRPGEnums.Team.Enemy):
		TargetAlly = false
		TargetEnemy = false
		SelectedCharacter.available_action = false;
		await SelectedSkill.Activate(SelectedCharacter, [MouseTarget])
		CheckPlayerTurn()
	elif MouseTarget.Team == JRPGEnums.Team.Player && SelectedCharacter == null && MouseTarget.AvailableAction:
		SelectedCharacter = MouseTarget
		JRPGSignalBus.instance.SetSelectedChar.emit(MouseTarget)
		FillUI(SelectedCharacter)

func FillUI(Character: JRPGBaseBattleChar):
	pass

func PrepareSkillTargeting(Skill: JRPGBaseSkill):
	if Skill == null:
		return
	print("selected skill: " + Skill.Name)
	SelectedSkill = Skill
	match SelectedSkill.Target:
		JRPGEnums.Target.All_Enemies:
			var enemies: Array[JRPGBaseBattleChar]
			for node:JRPGBaseBattleChar in get_tree().get_nodes_in_group("BattleChar"):
				if node.Team == JRPGEnums.Team.Enemy:
					enemies.append(node)
			SelectedSkill.activate(SelectedCharacter, enemies)
			JRPGSignalBus.instance.SetSelectedChar.emit(null)
			JRPGSignalBus.instance.SetHighlightState.emit(JRPGEnums.HighlightState.NONE)
			
		JRPGEnums.Target.Enemy:
			JRPGSignalBus.instance.SetHighlightState.emit(JRPGEnums.HighlightState.TARGET_ENEMY)
			TargetEnemy = true;
			
		JRPGEnums.Target.All_Allies:
			var allies: Array[JRPGBaseBattleChar]
			for node:JRPGBaseBattleChar in get_tree().get_nodes_in_group("BattleChar"):
				if node.Team == JRPGEnums.Team.Player:
					allies.append(node)
			SelectedSkill.activate(SelectedCharacter, allies)
			JRPGSignalBus.instance.SetSelectedChar.emit(null)
			JRPGSignalBus.instance.SetHighlightState.emit(JRPGEnums.HighlightState.NONE)
			
		JRPGEnums.Target.Ally:
			JRPGSignalBus.instance.SetHighlightState.emit(JRPGEnums.HighlightState.TARGET_ALLY)
			TargetAlly = true;
			
		JRPGEnums.Target.Self:
			SelectedSkill.activate(SelectedCharacter, [SelectedCharacter])
			JRPGSignalBus.instance.SetSelectedChar.emit(null)
			JRPGSignalBus.instance.SetHighlightState.emit(JRPGEnums.HighlightState.NONE)
			
		_:
			JRPGSignalBus.instance.SetSelectedChar.emit(null)
			JRPGSignalBus.instance.SetHighlightState.emit(JRPGEnums.HighlightState.NONE)
			push_error("Unhandled target: %s" % SelectedSkill.Target)
