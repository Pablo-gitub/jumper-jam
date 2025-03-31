extends Node

signal unlock_new_skin

var google_payment = null

func _ready() -> void:
	if Engine.has_singleton("GodotGooglePlayBilling"):
		google_payment = Engine.get_singleton("GodotGooglePlayBilling")
		MyUtility.add_log_msg("Android IAP support is anabled.")
	else:
		MyUtility.add_log_msg("Android IAP support is not available.")
	

func purchase_skin():
	unlock_new_skin.emit()
