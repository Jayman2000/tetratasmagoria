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


## tetromino/Tetromino.gd
# Stuff common to all Tetrominos
extends Node
const Location = preload("res://hemi-games/tetromino/Location.gd")

# The current absolute location of the tetromino's relitive origin.
var location = Location.new(20, 4)

# The relitive location of each square in default orientation. It is assumed that
# (0, 0) has a square in it, even though it's not listed here.
var SQUARE_LOCATIONS

# Returns a array with the absolute location of each square in the tetromino
func get_square_locations():
	var return_value = [location]
	for l in SQUARE_LOCATIONS:
		return_value.append(location.add(l))
	return return_value

## Return a list of locations that are immediately below this tetromino
#func get_floor():
#	var lowest_row = 0
#	for l in SQUARE_LOCATIONS:
#		lowest_row = min(lowest_row, l.r)
#
#	var return_value = []
#	for l in [Location.new(0, 0)] + SQUARE_LOCATIONS:
#		if l.r == lowest_row:
#			return_value.append(l.add(location).add(-1, 0))
#
#	return return_value