require 'spec_helper'

describe VideoElement do

  let(:videoelement) { VideoElement.new("Episode 1.mp4") }
  let(:notvideo) { VideoElement.new("adsf") }

  describe "#episode_initializer" do
    context "when correct episode" do
      it "returns the episode number" do
        value = videoelement.episode_initializer("Episode 1.mp4")
        expect(value).to eq 1
      end
    end

    context "when incorrect episode" do
      it "returns nil" do
        expect(notvideo.episode_initializer("asdf")).to eq nil
      end
    end
  end

  describe "#episode" do
    it "returns the number of the episode (integer)" do
      expect(videoelement.episode).to eq 1
    end
  end

  describe "#name" do
    it "returns the name of the episode" do
      expect(videoelement.name).to eq "Episode 1.mp4"
    end
  end

  describe "#not_an_episode?" do
    context "when given an episode" do
      it "returns false" do
        expect(videoelement.not_an_episode?).to eq false
      end
    end

    context "when given not an episode file" do
      it "returns true" do
        expect(notvideo.not_an_episode?).to eq true
      end
    end
  end

  describe "#==" do
    context "when given same videoelement" do
      it "returns true" do
        other = VideoElement.new("Episode 1.mp4")
        expect(videoelement==other).to eq true
      end
    end

    context "when given different videoelement (episode)" do
      it "returns true" do
        other = VideoElement.new("Episode 2.mp4")
        expect(videoelement==other).to eq false
      end
    end

    context "when given different videoelement (name)" do
      it "returns true" do
        other = VideoElement.new("Episode 1.srt")
        expect(videoelement==other).to eq false
      end
    end

  end

end
