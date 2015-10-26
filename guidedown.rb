class Guidedown
  def initialize(input)
    @input = input
  end

  def to_s
    @input.gsub(/ {4,}.+(\n+ {4,}.+)*\n/).each do |match|
      Codeblock.new(match).to_s
    end
  end

  class Codeblock
    def initialize(input)
      @input = input
    end

    def to_s
      "```\n#{@input.gsub(/^ {4}/, '')}```"
    end
  end
end
