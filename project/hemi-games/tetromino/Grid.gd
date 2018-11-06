extends Node2D

const WIDTH = 10 # in squares
const HEIGHT = 20 # in squares

# NOTE: It is assumed that SQUARES is a horizontal sprite sheet with 8 sprites
export(Texture) var SQUARES = null

var squares = []

func _ready():
	# squares[r][c]
	# r is for rows starting at the bottom (I would start at the top, but that would result in row 0 being in the buffer zone)
	# c is for columns starting on the left side
	var SQUARE_WIDTH = SQUARES.get_height()
	var SQUARE_HEIGHT = SQUARES.get_width() / 8
	var HEIGHT_IN_PIXELS = SQUARE_HEIGHT * HEIGHT # height of the entire grid
	
	for r in range(HEIGHT*2): # add extra space over the top to make room for off screen locks (make sure the border covers it)
		squares.append([])
		for c in range(WIDTH):
			var to_add = Sprite.new()
			squares[r].append(to_add)
			to_add.texture = SQUARES
			to_add.hframes = 8
			
			# Make sure the sprite is in the right position
			to_add.centered = false
			var x = c * SQUARE_WIDTH
			var y = -((r+1) * SQUARE_HEIGHT)
			"""
			Explanation of the formula for calculating y:
			
			The point (0, 0) is on the bottom left most corner of the grid. As y decreases, we move up the grid.
			The (r+1) is there because the Sprites's orgins are at their top left corner, and we don't want the
			0th row to be below the grid.
			the -(*rest of the equation*) part is due to the fact that as y decreases we move up (as opposed to
			moving down when y decreases)
			"""
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