

kbd = Keyboard.new

kbd.init_pins(
  [ 6, 7 ],   # row0, row1
  [ 28, 27 ]  # col0, col1
)

class Keyboard
end

#                            key1      key2
kbd.add_layer :default, %i(SPC_LAYER1 STATS BOOT  CTR_ENT_LAYER2)
kbd.add_layer :layer1,  %i(SPC_LAYER1 KC_1  KC_2  CTR_ENT_LAYER2)
kbd.add_layer :layer2,  %i(SPC_LAYER1 KC_F1 KC_F2 CTR_ENT_LAYER2)
kbd.define_mode_key :SPC_LAYER1,    [ :KC_SPACE,            :layer1, 200, 200 ]
kbd.define_mode_key :CTR_ENT_LAYER2,[ %i(KC_RCTL KC_ENTER), :layer2, 300, 150 ]

kbd.define_mode_key :STATS ,[ Proc.new { PicoRubyVM.print_alloc_stats }, nil, 300, 0 ]
kbd.define_mode_key :BOOT  ,[ Proc.new { kbd.bootsel! }, nil, 300, 0 ]

kbd.start!
