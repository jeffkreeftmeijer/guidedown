require 'linguist'

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
    include Linguist::BlobHelper
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def name
      @data.lines.first.match(/# (.+)/)
      $1
    end

    def to_s
      "```\n#{@data.gsub(/^ {4}/, '')}```"
    end

    def language_name
      language.name.downcase
    end
  end
end
