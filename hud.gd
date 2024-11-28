extends CanvasLayer

func level(val):
	$current_level.text = "LVL. " + str(val)

func gems(val): 
	$gem_balance.text = "GEMS : " + str(val)
