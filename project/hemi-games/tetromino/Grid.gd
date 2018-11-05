extends Node2D

const WIDTH = 10 # in squares
const HEIGHT = 20 # in squares

# NOTE: It is assumed that SQUARES is a horizontal sprite sheet with 8 sprites
export(Texture) var SQUARES = null
const SQUARE_GENERIC = 0
const SQUARE_I = 1
const SQUARE_J = 2
const SQUARE_L = 3
const SQUARE_O = 4
const SQUARE_S = 5
const SQUARE_T = 6
const SQUARE_Z = 7

var squares = []

func _ready():
	# squares[r][c]
	# r is for rows starting at the bottom (I would start at the top, but that would result in row 0 being in the buffer zone)
	# c is for columns starting on the left side
	var SQUARE_WIDTH = SQUARES.get_height()
	var SQUARE_HEIGHT = SQUARES.get_width() / 8
	var HEIGHT_IN_PIXELS = SQUARE_HEIGHT * HEIGHT # height of the entire grid
	
	$Lines.position.y -= SQUARE_HEIGHT
	
	for r in range(HEIGHT): # add extra space over the top to make room for off screen locks (make sure the border covers it)
		squares.append([])
		for c in range(WIDTH):
			var to_add = Sprite.new()
			squares[r].append(to_add)
			to_add.texture = SQUARES
			to_add.hframes = 8
			
			# Make sure the sprite is in the right position
			to_add.centered = false
			var x = c * SQUARE_WIDTH
			var y = HEIGHT_IN_PIXELS - (r+1) * SQUARE_HEIGHT
			to_add.position = Vector2(x, y)
			
			to_add.hide()
			add_child(to_add)

"""
func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
"""
# Debug/testing functions
func print_squares():
	for r in range(HEIGHT):
		print("%2s: %s" % [r, squares[r]])