#   Copyright 2018 Jason A. Yundt
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


## tetromino/Grid.gd
# Setup the grid to display tiles
extends Node2D

const WIDTH = 10 # in squares
const HEIGHT = 20 # in squares

# NOTE: It is assumed that SQUARES is a horizontal sprite sheet with 8 sprites
const SQUARE = preload("res://hemi-games/tetromino/Square.tscn")

var squares = []

func _ready():
	# squares[r][c]
	# r is for rows starting at the bottom (I would start at the top, but that would result in row 0 being in the buffer zone)
	# c is for columns starting on the left side
	var tmp = SQUARE.instance()
	var SQUARE_WIDTH = tmp.texture.get_height()
	var SQUARE_HEIGHT = tmp.texture.get_width() / 8
	var HEIGHT_IN_PIXELS = SQUARE_HEIGHT * HEIGHT # height of the entire grid
	tmp.free()
	
	for r in range(HEIGHT*2): # add extra space over the top to make room for off screen locks (make sure the border covers it)
		squares.append([])
		for c in range(WIDTH):
			var to_add = SQUARE.instance()
			squares[r].append(to_add)
			
			# Make sure the sprite is in the right position
			var x = c * SQUARE_WIDTH
#			Explanation of the formula for calculating y:
#
#			The point (0, 0) is on the bottom left most corner of the grid. As y decreases, we move up the grid.
#			The (r+1) is there because the Sprites's orgins are at their top left corner, and we don't want the
#			0th row to be below the grid.
#			the -(*rest of the equation*) part is due to the fact that as y decreases we move up (as opposed to
#			moving down when y decreases)
			var y = -((r+1) * SQUARE_HEIGHT)
			to_add.position = Vector2(x, y)
			
			to_add.hide()
			add_child(to_add)


## Debug/testing functions
#func print_squares():
#	for r in range(HEIGHT):
#		print("%2s: %s" % [r, squares[r]])
