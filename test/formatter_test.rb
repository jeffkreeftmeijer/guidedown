require_relative 'test_helper'

describe Guidedown::Formatter do
  it "returns the file's contents" do
    output = Guidedown::Formatter.new("one\ntwo").format("foo\nbar\nbaz\n")
    output.must_equal "foo\nbar\nbaz\n"
  end

  it "returns the first two lines followed by an ellipsis" do
    output = Guidedown::Formatter.new("one\ntwo\n...").format("foo\nbar\nbaz\n")
    output.must_equal "foo\nbar\n...\n"
  end
end
