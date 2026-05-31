extends Control



func _ready() -> void:
	JRPGSignalBus.instance.SelectedChar.connect(FillUI)

func FillUI(Char: JRPGBaseBattleChar):
	
