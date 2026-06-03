extends Node
class_name JRPGAIController

## A list of evaluation strategies this specific enemy uses [br](e.g., [color=BD1A00]Aggressive[/color], [color=1FFF5C]Healer[/color], [color=5EB9D1]Self-Preservation[/color])
@export var strategies: Array[JRPGAIStrategy]

func ChooseAction(ai_character: JRPGBaseBattleChar, combat_context: JRPGContext):
	var best_skill: JRPGBaseSkill = null
	var best_target = null
	var highest_score: float = -1.0
	
	for skill in ai_character.skills:
		for strategy in strategies:
			var evaluation = strategy.evaluate_skill(skill, ai_character, combat_context)
			
			if evaluation.score > highest_score:
				highest_score = evaluation.score
				best_skill = skill
				best_target = evaluation.target
				
	#return {"skill": best_skill, "target": best_target}
