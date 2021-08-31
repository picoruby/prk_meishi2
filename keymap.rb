# Wait until Keyboard class is ready
while !$mutex
  relinquish
end

# Initialize a Keyboard
kbd = Keyboard.new

kbd.init_pins(
  [ 6, 7 ],   # row0, row1
  [ 28, 27 ]  # col0, col1
)

# default layer should be added at first
kbd.add_layer :default, %i[
  FIBONACCI PASSWD  RAISE_ENTER LOWER_SPACE
]
kbd.add_layer :raise, %i[
  KC_C      KC_D    RAISE_ENTER ADJUST
]
kbd.add_layer :lower, %i[
  KC_E      KC_F    RAISE_ENTER LOWER_SPACE)
]
kbd.add_layer :adjust, %i[
  KC_SCOLON KC_LSFT RAISE_ENTER ADJUST
]
#
#                   Your custom     Keycode or             Keycode (only modifiers)      Release time      Re-push time
#                   key name        Array of Keycode       or Layer Symbol to be held    threshold(ms)     threshold(ms)
#                                   or Proc                or Proc which will run        to consider as    to consider as
#                                   when you click         while you keep press          `click the key`   `hold the key`
kbd.define_mode_key :RAISE_ENTER, [ :KC_ENTER,             :raise,                       200,              150 ]
kbd.define_mode_key :LOWER_SPACE, [ :KC_SPACE,             :lower,                       300,              400 ]
kbd.define_mode_key :ADJUST,      [ nil,                   :adjust,                      nil,              nil ]

class Fibonacci
  def initialize
    @a = 0 ; @b = 1
  end
  def take
    result = @a + @b
    @a = @b
    @b = result
  end
end
fibonacci = Fibonacci.new
kbd.define_mode_key :FIBONACCI, [ Proc.new { kbd.macro fibonacci.take }, :KC_NO, 300, nil ]

class Password
  def initialize
    @c = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_!@#$%^&*()=-+/[]{}<>'
  end
  def generate
    unless @srand
      # generate seed with board_millis
      srand(board_millis)
      @srand = true
    end
    password = ""
    while true
      i = rand % 100
      password << @c[i].to_s
      break if password.length == 8
    end
    return password
  end
end
password = Password.new
kbd.define_mode_key :PASSWD, [ Proc.new { kbd.macro password.generate, [] }, :KC_NO, 300, nil ]

kbd.before_report do
  kbd.invert_sft if kbd.keys_include?(:KC_SCOLON)
  # You'll be also able to write `invert_ctl`, `invert_alt` and `invert_gui`
end

kbd.start!
