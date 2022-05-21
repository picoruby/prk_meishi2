require "via"

puts "=== meishi2 ==="

# Initialize a Keyboard
kbd = Keyboard.new

kbd.via = true
kbd.via_layer_count = 3

kbd.init_pins(
  [ 6, 7 ],   # row0, row1
  [ 28, 27 ]  # col0, col1
)

kbd.define_mode_key :VIA_FUNC0, [ Proc.new{ PicoRubyVM.print_alloc_stats }, nil, 200, 200 ]
kbd.define_mode_key :VIA_FUNC1, [ Proc.new{ kbd.bootsel! },    nil, 200, 200 ]

kbd.output_report_changed do |output|
  puts output.to_s(2)
end

kbd.start!
