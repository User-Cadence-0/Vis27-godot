extends Control
class_name NumPlace 

@export var numval: int = 0
@export var inverted: bool = false
@onready var texArray = TexSetting()

# Called when the node enters the scene tree for the first time.
func _ready():
#	var tempArray = TexSetting()
#	for index in range(tempArray.size()):
#		print(str(tempArray[index])+" | "+str(tempArray[index].texture.load_path))
	updateValue(numval)
	pass
#	

func TexSetting():
	# first establish what nodes we're working with and put them into array
	# for accessing later on down
	var zerotex = get_node("VBoxCtrl/RatioCtrl/tex0")
	var onestex = get_node("VBoxCtrl/RatioCtrl/tex1")
	var threestex = get_node("VBoxCtrl/RatioCtrl/tex2")
	var ninestex = get_node("VBoxCtrl/RatioCtrl/tex3")
	
	var textempA = Array([zerotex,onestex,threestex,ninestex])
	
	# now check for inversion and, if inverted, set all textures
	# to the default inverted value
#	print("[TexSetting Loop Enter]")
	var numvar = 0
	for index in range(textempA.size()):
#		print("starts: "+str(textempA[index].texture.resource_path))
		if inverted:
			if index == 0:
				textempA[index].texture = load("res://assets/numtex/v0.svg")
			else:
				numvar = 3**(index-1)
#				print("numvar: "+str(numvar))
				
				var format_stl = "res://assets/numtex/v%s-1.svg"
				var stl = format_stl % numvar
				
				textempA[index].texture = load(stl)
			
#		print("became -> "+str(textempA[index].texture.resource_path))
	
	return textempA
	
func updateValue(newval = 0.0):
	var mathval = newval
	# so that we may update mathval without overwriting newval
	var nineval = 0
	var threeval = 0
	var oneval = 0
	
	var finalval = newval
	# will update the label at the end
	
	#print("updateValue: ["+str(newval)+"]")
	
	if newval > 26:
		print("[NumPlace.gd] ERROR: attempted to updateValue(), but newval > 26!\n")
		
		finalval = 26
	elif newval <= 0:
		for index in range(texArray.size()):
			if index == 0:
				texArray[index].visible = true
			else:
				texArray[index].visible = false
		if newval < 0:
			print("[Numplace.gd] Warning: Numval < 0!\n")
		else:
			pass
#			print("\n")
		
		finalval = 0
	else:
		nineval = floor(mathval/9)
#		print("nineval: "+str(nineval))
		mathval -= nineval*9
		
		threeval = floor(mathval/3)
#		print("threeval: "+str(threeval))
		mathval -= threeval*3
		
		oneval = mathval
#		print("oneval: "+str(oneval))
		
		# we'll be playing with two arrays, one which stores the numerical
		# values of the "sub-places" and one which stores the information 
		# of the tex nodes, to do what we want
		var valPlaceA = [0, oneval, threeval, nineval]
		var numvar = 0 # for text math later, such as in TexSetting()
		for index in range(texArray.size()):
			if valPlaceA[index] == 0:
				# set "0.svg" invisible
				texArray[index].visible = false
				# index applies to both arrays equally
			else:
				# the only values of valPlaceA[index] beyond this point
				# SHOULD BE ONLY either 1 or 2
				texArray[index].visible = true
				
				# mostly copied from TexSetting()
				# numvar set to 0, 1, 3, or 9
				numvar = 3**(index-1)
				var stl_format = "res://assets/numtex/%s%s-%s.svg"
				var invFlag = ""
				if inverted:
					invFlag = "v"
				var stl = stl_format % [invFlag, numvar, valPlaceA[index]]
				
				texArray[index].texture = load(stl)
			
		
	#print("\n")
	
	get_node("VBoxCtrl/Label").text = str(finalval)
	return finalval

@onready var numval_stored = numval
func _process(_delta):
	# Called every frame. 'delta' is the elapsed time since the previous frame.
	if numval != numval_stored:
		# Don't want to iterate this every frame
		numval = int(updateValue(numval))
		numval_stored = numval
