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
kbd = Keyboard.new

kbd.init_pins(
  [ 6, 7 ],   # row0, row1
  [ 28, 27 ]  # col0, col1
)

# default layer should be added at first
kbd.add_layer :default, [
  %i(KC_A      KC_B),    %i(RAISE_ENTER LOWER_SPACE)
]
kbd.add_layer :raise, [
  %i(KC_C      KC_D),    %i(RAISE_ENTER ADJUST)
]
kbd.add_layer :lower, [
  %i(KC_E      KC_F),    %i(RAISE_ENTER LOWER_SPACE)
]
kbd.add_layer :adjust, [
  %i(KC_SCOLON KC_LSFT), %i(RAISE_ENTER ADJUST)
]

#                   Your custom     Keycode    Keycode (only modifiers)             Release time      Re-push time
#                   key name        or Proc    or Proc                              threshold(ms)     threshold(ms)
#                                   when you   while you                            to consider as    to consider as
#                                   click      keep press                           `click the key`   `hold the key`
kbd.define_mode_key :RAISE_ENTER, [ :KC_ENTER, Proc.new { kbd.hold_layer :raise  }, 200,              150 ]
kbd.define_mode_key :LOWER_SPACE, [ :KC_SPACE, Proc.new { kbd.hold_layer :lower  }, 300,              400 ]
kbd.define_mode_key :ADJUST,      [ nil,       Proc.new { kbd.hold_layer :adjust }, nil,              nil ]
                                                            # ^^^^^^^^^^ `hold_layer` will "hold" layer while pressed

#
# Alternatively, you can also write like:
#
# kbd.add_layer :default, [
#   %i(KC_A SHIFT_RAISE), %i(KC_B SHIFT_SPACE)
# ]
# kbd.add_layer :raise, [
#   %i(KC_C SHIFT_LOWER), %i(KC_D SPACE_LOWER)
# ]
# kbd.add_layer :lower, [
#   %i(KC_E SHIFT_DEFAULT), %i(KC_F LOWER_SPACE)
# ]
# kbd.define_mode_key :SHIFT_RAISE,   [ Proc.new { kbd.lock_layer :raise },   :KC_RSFT,         200,              200 ]
# kbd.define_mode_key :SHIFT_LOWER,   [ Proc.new { kbd.lock_layer :lower },   :KC_RSFT,         200,              200 ]
# kbd.define_mode_key :SHIFT_DEFAULT, [ Proc.new { kbd.lock_layer :default }, :KC_RSFT,         200,              200 ]
#                                                      ^^^^^^^^^^ `lock_layer` will "lock" layer to specified one
# kbd.define_mode_key :SHIFT_SPACE,   [ :KC_SPACE,                            :KC_LSFT,         300,              400 ]
# kbd.define_mode_key :SPACE_LOWER,   [ Proc.new { kbd.lower_layer },         :KC_LCTL,         200,              200 ]
#
# Other than `hold_layer` and `lock_layer`, `raise_layer` and `lower_layer` will switch current layer in order
#


# `before_report` will work just right before reporting what keys are pushed to USB host.
# You can use it to hack data by adding an instance method to Keyboard class by yourself.
# ex) Use Keyboard#before_report filter if you want to input `":" w/o shift` and `";" w/ shift`
kbd.before_report do
  kbd.invert_sft if kbd.keys_include?(:KC_SCOLON)
  # You'll be also able to write `invert_ctl`, `invert_alt` and `invert_gui`
end

kbd.start!
