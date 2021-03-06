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


## tetromino/Location.gd
# Location represents the location of a square in the grid
var r
var c

func _init(row=0, column=0):
	r = row
	c = column

# Takes either 1 argument, annother Location object, or two
# ints, row and column.
func add(row, column=null):
	if column == null:
		column = row.c
		row = row.r
	return get_script().new(r+row, c+column)

func sub(row, column=null):
	if column == null:
		column = row.c
		row = row.r
	return get_script().new(r-row, c-column)

func rotate_clockwise():
	return get_script().new(-c, r)

func to_str():
	return "{%2d, %2d}" % [r, c]