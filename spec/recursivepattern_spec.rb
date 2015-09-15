require 'spec_helper'

describe RecursivePattern do

  let(:rp_def) { RecursivePattern.new }
  let(:rp_happy) { RecursivePattern.new(guess: "Lost.S01E01.720p.BluRay.x264-CtrlHD.srt", iteration: 1) }

  describe "#new" do
    context "when no arguments" do
      it "is instance of class" do
        expect(rp_def).to be_an_instance_of RecursivePattern
      end
    end

    context "when happy arguments" do
      it "is instance of class" do
        expect(rp_happy).to be_an_instance_of RecursivePattern
      end
    end
  end

  describe "#guess" do
    context "when no arguments" do
      it "returns empty string" do
        expect(rp_def.guess).to eq ""
      end
    end

    context "when happy arguments" do
      it "returns file name" do
        expect(rp_happy.guess).to eq "Lost.S01E01.720p.BluRay.x264-CtrlHD.srt"
      end
    end
  end

  describe "#iteration" do
    context "when no arguments" do
      it "returns 0" do
        expect(rp_def.iteration).to eq 0
      end
    end
    
    context "when happy arguments" do
      it "returns 1" do
        expect(rp_happy.iteration).to eq 1
      end
    end
  end

  describe "#==" do
    context "when equal contents" do
      it "returns true" do
        response = (rp_happy == RecursivePattern.new(guess: "Lost.S01E01.720p.BluRay.x264-CtrlHD.srt", iteration: 1))
        expect(response).to eq true
      end
    end

    context "when different contents" do
      it "returns false" do
        response = (rp_happy == RecursivePattern.new)
        expect(response).to eq false
      end
    end
  end
end
