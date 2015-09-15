require 'spec_helper'

describe RecursivePattern do
  before :all do
    @recursivepattern = RecursivePattern.new(guess: "Lost.S01E01.720p.BluRay.x264-CtrlHD.srt", iteration: 0)
  end

  describe "#new" do
    it "takes 2 parameters and return a RecursivePattern object" do
      @recursivepattern.should be_an_instance_of RecursivePattern
    end
  end
end