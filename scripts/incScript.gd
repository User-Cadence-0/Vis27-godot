extends VBoxContainer

var increment: int = 1

@onready var UpB = get_node("buttonAdd")
@onready var DownB = get_node("buttonSub")
@onready var incEdit = get_node("incEdit")
@onready var modeNode = get_node("CheckButton")

@onready var pConNode = get_node("../VBoxMain/placesCon")

# # # button functions

func _on_check_button_toggled(button_pressed):
	# change display text of the buttons when mode is changed
	if button_pressed:
		UpB.text = "x"
		DownB.text = "÷"
	else:
		UpB.text = "+"
		DownB.text = "-"

func _on_button_add_pressed():
	if modeNode.button_pressed:
		pConNode.PlacesUpdateFull(pConNode.globalVal * increment)
	else:
		pConNode.PlacesUpdateFull(pConNode.globalVal + increment)
func _on_button_sub_pressed():
	if modeNode.button_pressed:
		pConNode.PlacesUpdateFull(pConNode.globalVal / increment)
	else:
		pConNode.PlacesUpdateFull(pConNode.globalVal - increment)

func _on_button_add_button_up():
	UpB.release_focus()
func _on_button_sub_button_up():
	DownB.release_focus()
# these are just a visual preference mostly, but also
# disables the up and down keys from moving focus
# instead of adjusting value like I want
# # #

func _on_inc_edit_text_submitted(new_text):
	# takes a lot from text_submitted signal in pCon
	print("LineEdit: "+new_text)
	incEdit.release_focus()
	
	var textInt = 0
	
	if !new_text.is_valid_int():
		if new_text == "":
			pass
		else:
			print("Invalid! >:(")
			incEdit.text = str(increment)
			return
	else:
		textInt = new_text.to_int()
	
	if textInt < 0:
		textInt = abs(textInt)
		incEdit.text = str(textInt)
	elif textInt == 0 or textInt == 1:
		incEdit.text = ""
		textInt = 1
	
	if textInt != increment:
		increment = textInt
	else:
		print("[same inc]")


