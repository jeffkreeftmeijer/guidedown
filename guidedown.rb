class Guidedown
  def initialize(input)
    @input = input
  end

  def to_s
    "```\n#{@input.gsub('    ', '')}\n```"
  end
end
