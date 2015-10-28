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

  it "returns an ellipsis followed by the last two lines" do
    output = Guidedown::Formatter.new("...\ntwo\nthree").format("foo\nbar\nbaz\n")
    output.must_equal "...\nbar\nbaz\n"
  end

  it "returns the first line, an ellipsis, and the third line" do
    output = Guidedown::Formatter.new("one\n...\nthree").format("foo\nbar\nbaz\n")
    output.must_equal "foo\n...\nbaz\n"
  end

  it "handles indented ellipses" do
    output = Guidedown::Formatter.new("one\n  ...\nthree").format("foo\nbar\nbaz\n")
    output.must_equal "foo\n  ...\nbaz\n"
  end
end
