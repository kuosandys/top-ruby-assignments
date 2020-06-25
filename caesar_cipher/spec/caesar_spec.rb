require './lib/caesar.rb'

describe "#caesar_cipher" do
  it "encrypts a word" do
    expect(caesar_cipher("hello", 2)).to eql("jgnnq")
  end

  it "is case sensitive" do
    expect(caesar_cipher("Hello", 2)).to eql("Jgnnq")
  end

  it "encrypts a sentence" do
    expect(caesar_cipher("Hello, world!", 2)).to eql("Jgnnq, yqtnf!")
  end

  it "works with negative shifts" do
    expect(caesar_cipher("Hello, world!", -2)).to eql("Fcjjm, umpjb!")
  end

  it "works with large (>26) shifts" do
    expect(caesar_cipher("Hello, world!", 28)).to eql("Jgnnq, yqtnf!")
  end
end

