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


## tetromino/Z.gd
# Static information about the Z tetromino (See I.gd for more helpful comments).
extends Object
const Location = preload("res://hemi-games/tetromino/Location.gd")

var LAYOUT = [Location.new( 1, -1), Location.new( 1,  0),
                                                          Location.new( 0,  1)]