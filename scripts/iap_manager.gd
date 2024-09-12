extends Node

signal unlock_new_skin


func purchase_skin() -> void:
	unlock_new_skin.emit()
