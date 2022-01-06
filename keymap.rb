# Initialize a Keyboard
kbd = Keyboard.new

kbd.init_pins(
  [ 6, 7 ],   # row0, row1
  [ 28, 27 ]  # col0, col1
)

# default layer should be added at first
kbd.add_layer :default, %i(CUT COPY PASTE RAISE_ENTER)
kbd.add_layer :raise, [ %i(KC_LCTL KC_X), %i(KC_LCTL KC_C), %i(KC_LCTL KC_V), :RAISE_ENTER ]

kbd.define_composite_key :CUT, %i(KC_LCTL KC_X)
kbd.define_composite_key :COPY, %i(KC_LCTL KC_C)
kbd.define_composite_key :PASTE, %i(KC_LCTL KC_V)

kbd.define_mode_key :RAISE_ENTER, [ :KC_ENTER, :raise, 150, 200 ]

kbd.start!
