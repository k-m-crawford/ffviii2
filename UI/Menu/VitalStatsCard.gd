class_name VitalStatsCard extends HBoxContainer

@onready var portrait:TextureRect = %Portrait as TextureRect
@onready var vital_headers:Label = %VitalHeaders as Label

func update_view(view:PlayerCharacter) -> void:
	portrait.texture = view.portrait
	vital_headers.text = view.name + "\nLV\nHP"
