require 'spec_helper'

describe VideoElement do

  let(:videoelement) { VideoElement.new("Episode 1.mp4") }
  let(:notvideo) { VideoElement.new("adsf") }
  let(:subtitleelement) { VideoElement.new("1x01.srt") }

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
      expect(videoelement.name).to eq "Episode 1"
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
      it "returns false" do
        other = VideoElement.new("Episode 2.mp4")
        expect(videoelement==other).to eq false
      end
    end

    context "when given different videoelement (name)" do
      it "returns false" do
        other = VideoElement.new("Episode 1.srt")
        expect(videoelement==other).to eq false
      end
    end
  end

  describe "#same_episode?" do
    context "when given same episode" do
      it "returns true" do
        other = VideoElement.new("Episode 1.srt")
        expect(videoelement.same_episode?(other)).to eq true
      end
    end

    context "when given different episode" do
      it "returns false" do
        other = VideoElement.new("Episode 2.srt")
        expect(videoelement.same_episode?(other)).to eq false
      end
    end
  end

  describe "#type_initializer" do
    context "when given video filename" do
      it "returns :video key and name" do
        expect(videoelement.type_initializer("Episode 1.avi")).to eq :video
      end
    end
  end

  describe "#save_new_name!" do
    context "when given video name" do
      it "saves the new name" do
        subtitleelement.save_new_name!(videoelement)
        expect(subtitleelement.new_name).to eq videoelement.name
      end
    end
  end

  describe "#get_filename" do
    it "returns string of filename" do
      expect(subtitleelement.get_filename).to eq "1x01.srt"
    end
  end

  describe "#get_rename_filename" do
    it "returns the new filename for renaming" do
      subtitleelement.save_new_name!(videoelement)
      expect(subtitleelement.get_rename_filename).to eq "Episode 1.srt"
    end
  end
end
