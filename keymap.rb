# This example assumes to use "meishi2" which has 2x2 matrix circuit.
#
# If you use a larger one, let's say 40% keyboard, the code will look like:
# (Note that GPIO pin numbers in this example are written at random. They are fishy)
# ```
#   kbd = Keyboard.new(
#     [ 2, 3, 4, 5 ],                                 # row0, row1,... respectively
#     [ 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 ]  # col0, col1,... respectively
#   )
#   kbd.add_layer :default, [
#     %i(KC_ESC  KC_Q   KC_W .....),
#     %i(KC_TAB  KC_A   KC_S .....),
#     %i(KC_LSFT KC_Z   KC_X .....),
#     %i(KC_NO   KC_NO  KC_LGUI .....),
#   ]
# ```

# Wait until Keyboard class is ready
while !$mutex
  relinquish
end

# Initialize a Keyboard with GPIO assign
kbd = Keyboard.new(
  [ 2, 3 ], # row0, row1,... respectively
  [ 6, 7 ]  # col0, col1,... respectively
)

# default layer should be added at first
kbd.add_layer :default, [
  %i(KC_A RAISE_ENTER),
  #%i(KC_B LOWER_SPACE),
  %i(KC_B SHIFT_SPACE),
]
kbd.add_layer :raise, [
  %i(KC_C RAISE_ENTER),
  %i(KC_D ADJUST),
  #%i(KC_D LOWER_SPACE),
]
kbd.add_layer :lower, [
  %i(KC_E RAISE_ENTER),
  %i(KC_F LOWER_SPACE),
]
kbd.add_layer :adjust, [
  %i(KC_SCOLON RAISE_ENTER),
  %i(KC_LSFT   ADJUST),
  #%i(KC_LSFT LOWER_SPACE),
]

#                   Your custom     Keycode    Keycode (only modifiers)             Release time      Re-push time
#                   key name        or Proc    or Proc                              threshold(ms)     threshold(ms)
#                                   when you   while you                            to consider as    to consider as
#                                   click      keep press                           `click the key`   `hold the key`
kbd.define_mode_key :RAISE_ENTER, [ :KC_ENTER, Proc.new { kbd.hold_layer :raise  }, 200,              150 ]
#kbd.define_mode_key :LOWER_SPACE, [ :KC_SPACE, Proc.new { kbd.hold_layer :lower  }, 300,              400 ]
kbd.define_mode_key :SHIFT_SPACE, [ :KC_SPACE, :KC_LSFT, 300,              400 ]
#kbd.define_mode_key :ADJUST,      [ nil,       Proc.new { kbd.hold_layer :adjust }, nil,              nil ]

#kbd.define_mode_key :RAISE_ENTER, [ Proc.new { kbd.raise_layer }, :KC_LSFT,         200,              200 ]
#kbd.define_mode_key :LOWER_SPACE, [ Proc.new { kbd.lower_layer }, :KC_LCTL,         200,              200 ]

# ex) Use Keyboard#before_report filter if you want to input `":" w/o shift` and `";" w/ shift`
# 
# before_report will work just right before your keyboard reports which keys are pushed to USB host.
# You can use it to hack data by adding an instance method to Keyboard class by yourself.
kbd.before_report do
  kbd.invert_sft if kbd.keys_include?(:KC_SCOLON)
  # You'll be also able to write `invert_ctl`, `invert_alt` and `invert_gui`
end

kbd.start!
