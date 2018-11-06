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


## tetromino/I.gd
# Static information about the I tetromino
extends Node

# The position of each square in default orientation. It is assumed that
# (0, 0) has a square in it, even though it's not listed here.
const LAYOUT = [Vector2(-1,  0),                  Vector2( 1,  0), Vector2( 2,  0)]