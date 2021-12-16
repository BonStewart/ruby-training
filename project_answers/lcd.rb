# frozen_string_literal: true

class LCD
  attr_reader :input, :width, :height

  def initialize(input, width: 1, height: 1)
    @input = input
    @width = width
    @height = height
  end

  def render
    "#{render_line_one}\n"\
    "#{render_height_between_lines_one_and_two}"\
    "#{render_line_two}\n"\
    "#{render_height_between_lines_two_and_three}"\
    "#{render_line_three}\n"
  end

  private

  def render_height_between_lines_one_and_two
    return if no_height_extension?

    one_line = number_as_digits.map { |digit| first_height_extender(digit) }.join

    "#{one_line}\n" * (height - 1)
  end

  def render_height_between_lines_two_and_three
    return if no_height_extension?

    one_line = number_as_digits.map { |digit| second_height_extender(digit) }.join

    "#{one_line}\n" * (height - 1)
  end

  def no_height_extension?
    height == 1
  end

  def render_line_one
    number_as_digits.map { |digit| line_one(digit) }.join
  end

  def render_line_two
    number_as_digits.map { |digit| line_two(digit) }.join
  end

  def render_line_three
    number_as_digits.map { |digit| line_three(digit) }.join
  end

  def number_as_digits
    if input.is_a?(Integer)
      input.digits.reverse
    else
      input.each_char
    end
  end

  def line_one(digit)
    " #{underscore(digit, :top)} "
  end

  def first_height_extender(digit)
    spaces = ' ' * width
    "#{pipe(digit, :mid_left)}#{spaces}#{pipe(digit, :mid_right)}"
  end

  def line_two(digit)
    "#{pipe(digit, :mid_left)}#{underscore(digit, :mid)}#{pipe(digit, :mid_right)}"
  end

  def second_height_extender(digit)
    spaces = ' ' * width
    "#{pipe(digit, :bottom_left)}#{spaces}#{pipe(digit, :bottom_right)}"
  end

  def line_three(digit)
    "#{pipe(digit, :bottom_left)}#{underscore(digit, :bottom)}#{pipe(digit, :bottom_right)}"
  end

  def underscore(digit, position)
    if write_character?(digit, position)
      '_' * width
    else
      ' ' * width
    end
  end

  def pipe(digit, position)
    if write_character?(digit, position)
      '|'
    else
      ' '
    end
  end

  def write_character?(digit, position)
    lcd_table[digit].include?(position)
  end

  def lcd_table
    # Key reference is as follows ...
    # 0 -> Top
    # 1 -> Mid-Left
    # 2 -> Mid
    # 3 -> Mid-Right
    # 4 -> Bottom-Left
    # 5 -> Bottom
    # 6 -> Bottom-Right
    #
    {
      0 => [:top, :mid_left, :mid_right, :bottom_left, :bottom, :bottom_right],
      1 => [:mid_right, :bottom_right],
      2 => [:top, :mid, :mid_right, :bottom_left, :bottom],
      3 => [:top, :mid, :mid_right, :bottom, :bottom_right],
      4 => [:mid_left, :mid, :mid_right, :bottom_right],
      5 => [:top, :mid_left, :mid, :bottom, :bottom_right],
      6 => [:top, :mid_left, :mid, :bottom_left, :bottom, :bottom_right],
      7 => [:top, :mid_right, :bottom_right],
      8 => [:top, :mid_left, :mid, :mid_right, :bottom_left, :bottom, :bottom_right],
      9 => [:top, :mid_left, :mid, :mid_right, :bottom, :bottom_right],
      'a' => [:top, :mid_left, :mid, :mid_right, :bottom_left, :bottom_right],
      'b' => [:mid_left, :mid, :bottom_left, :bottom, :bottom_right],
      'c' => [:top, :mid_left, :bottom_left, :bottom],
      'd' => [:mid, :mid_right, :bottom_left, :bottom, :bottom_right],
      'e' => [:top, :mid_left, :mid, :bottom_left, :bottom],
      'f' => [:top, :mid_left, :mid, :bottom_left]
    }
  end
end
