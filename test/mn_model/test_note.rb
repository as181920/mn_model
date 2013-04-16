require "minitest/autorun"
require "mn_model"

include MnModel

describe MnModel do
  before do
  end

  describe "test note" do
    it "must be hi note" do
      Note.new.hi.must_equal "hi note"
    end

    it "count is 0" do
      Note.all.count.must_equal 0
    end
  end

end
