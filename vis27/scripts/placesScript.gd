extends HBoxContainer

var globalVal: int = 0

# hello, Github?

@onready var numplaceArray = get_children()
@onready var lineEditNode = get_node("../MarginContainer/LineEdit")

# on main text submitted, do the following:
# print to console (temporary) for code tracking
# test for valid integer input
# -> send int to numplace
func _on_line_edit_text_submitted(new_text):
	print("LineEdit: "+new_text)
	lineEditNode.release_focus()
	
	if !new_text.is_valid_int():
		# abort!
		print("Invalid! >:(")
		return
	
	var textInt = new_text.to_int()
	
	if textInt < 0:
		textInt = abs(textInt)
		lineEditNode.text = str(textInt)
		
	if textInt != globalVal:
		PlacesUpdateFull(textInt)

func PlacesUpdateFull(value: int = 0):
	
	if value < 0:
		value = 0
		# last catch for negative numbers, since they can dip below
		# zero and not be seen
	if value == globalVal:
		return
		# no need to go through it all if it's the same already
	
	var valueArray = NumberSorting(value)
	if valueArray.size() == 0:
		# abort function, NumberSorting determined no valid value
		print("PUF: aborting, valueArray.size() == 0")
		return
	
	await PlacenodeOrg(valueArray.size()-numplaceArray.size())
	# if number of places in our value is different than number of nodes 
	# available to represent it, adjust accordingly
	# value# 5 - node# 3 = add 2 more nodes
	
	for i in valueArray.size():
		numplaceArray[i].updateValue(valueArray[i])
	
	globalVal = value
	lineEditNode.text = str(globalVal) # to update it as a display when inc is used

# big number go in, find highest place val
# update number with math, feed into new NumberSorting call one place lower
func NumberSorting(value, place = 0):
	if value / 27**place >= 27:
		# we will do this until we hit the highest number place for the given value	
		return NumberSorting(value, place+1)
	
	var mathval = float(value)
	var mathArray = []
	
	for p in range(place, -1, -1):
		var storeval = 0
		
		print(str(mathval)+" / 27**"+str(p))
		if mathval < 27:
			if p == 0:
				storeval = mathval
			else:
				storeval = 0
		else:
			storeval = floor(mathval/27**p)
		print("-> "+str(storeval))
		
		mathArray.insert(0, storeval)
		mathval = mathval - (storeval*27**p)
		
	print(str(mathArray))
	return mathArray

func PlacenodeOrg(change: int = 0):
	
	if change == 0: #no change needed
		return
	
	print("PnO: change = "+str(change))
	
	if change >= 1: # add (duplicate) nodes
		for i in change:
			# append to array a duplicate of node at end of array
			var newPlace = numplaceArray[-1].duplicate()
			add_child(newPlace) 
			# invert if needed
			# todo: how the hell do I find out if the number is odd or even?
			# Bitwise? & Remainder? %
			
			numplaceArray.append(newPlace)
			if numplaceArray.size()%2 == 0:
				newPlace.inverted = true
			else:
				newPlace.inverted = false
		
	else: # remove nodes
		change = abs(change)
		numplaceArray.reverse() # easier to grab elements from reverse
		for i in change:
			numplaceArray[i].queue_free()
		# put it BACK
		numplaceArray.reverse()
		# cut off the remainder
		numplaceArray.resize(numplaceArray.size()-change)
