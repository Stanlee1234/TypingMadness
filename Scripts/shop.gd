extends Control

func _on_buy_auto_typer_pressed() -> void:
	var cost = 10 * (GameManager.auto_typer_level + 1)
	if GameManager.spend_juice(cost):
		GameManager.auto_typer_level += 1
		update_auto_typer()
		print("Auto typer upgraded to level: ", GameManager.auto_typer_level)
	else:
		print("Not enough juice!")

# Add this missing function to clear the error
func update_auto_typer() -> void:
	var next_cost = 10 * (GameManager.auto_typer_level + 1)
	$BuyAutoTyper.text = "Buy Auto Typer (%d Juice)" % next_cost
	pass
