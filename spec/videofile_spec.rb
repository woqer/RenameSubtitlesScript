require 'spec_helper'

describe VideoFile do

  let(:videofile_class) { Class.new { include VideoFile } }
  let(:videofile) { videofile_class.new }

  describe "#episode_patterns_lvl1" do
    context "when calling method" do
      it "returns array of episode_patterns_lvl1" do
        expect(videofile.episode_patterns_lvl1).to eq [/S\d+E\d+/, /\d+x\d+/, /.*\d+/]
      end
    end
  end

  describe "#episode_patterns_lvl2" do
    context "when calling method" do
      it "returns array of episode_patterns_lvl2" do
        expect(videofile.episode_patterns_lvl2).to eq [/E\d+/, /x\d+/, /\d+/]
      end
    end
  end

  describe "#video_extensions" do
    context "when calling method" do
      it "returns array of video extensions" do
        expect(videofile.video_extensions).to eq ["mkv", "avi", "mp4"]
      end
    end
  end

  describe "#subtitle_extensions" do
    context "when calling method" do
      it "returns array of subtitle extensions" do
        expect(videofile.subtitle_extensions).to eq ["srt", "sub"]
      end
    end
  end

  describe "#file_pattern" do
    context "when video_extensions" do
      it "returns array of patterns" do
        extensions = videofile.video_extensions
        expect(videofile.file_pattern extensions).to eq [/\.mkv$/,/\.avi$/,/\.mp4$/]
      end
    end
  end

  describe "#try_match" do
    context "when iterations overflow" do
      it "returns default RecursivePattern" do
        value = videofile.try_match("adsf", ["qwer"], 1)
        expect(value).to eq RecursivePattern.new
      end
    end
  end

end
