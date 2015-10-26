class Guidedown
  def initialize(input)
    @input = input
  end

  def to_s
    @input.gsub(/ {4,}.+(\n+ {4,}.+)*\n/).each do |match|
      "```\n#{match.gsub(/ {4}/, '')}```"
    end
  end
end
