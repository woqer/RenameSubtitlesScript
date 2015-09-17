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

    context "when provided a video name and video pattern" do
      it "returns the guessed video extension" do
        pattern = videofile.file_pattern(videofile.video_extensions)
        value = videofile.try_match("adsfEpisode1.mkv", pattern, 0)
        expect(value.guess).to eq ".mkv"
      end
    end

    context "when provided a subtitle name and subtitle pattern" do
      it "returns the guessed subtitle extension" do
        pattern = videofile.file_pattern(videofile.subtitle_extensions)
        value = videofile.try_match("adsfEpisode1.srt", pattern, 0)
        expect(value.guess).to eq ".srt"
      end
    end

    context "when provided a video name and subtitle pattern" do
      it "returns empty guess" do
        pattern = videofile.file_pattern(videofile.subtitle_extensions)
        value = videofile.try_match("adsfEpisode1.mkv", pattern, 0)
        expect(value.guess).to eq ""
      end
    end

    context "when provided a video_nameEpisode1 and episode_patterns_lvl1" do
      it "returns a episode lvl2 guess" do
        pattern = videofile.episode_patterns_lvl1
        value = videofile.try_match("adsfEpisode1.mkv", pattern, 0)
        expect(value.guess).to eq "adsfEpisode1"
      end
    end

    context "when provided a video_nameS01E01 and episode_patterns_lvl1" do
      it "returns a episode lvl2 guess" do
        pattern = videofile.episode_patterns_lvl1
        value = videofile.try_match("adsfS01E01.mkv", pattern, 0)
        expect(value.guess).to eq "S01E01"
      end
    end

    context "when provided a video_name1x01 and episode_patterns_lvl1" do
      it "returns a episode lvl2 guess" do
        pattern = videofile.episode_patterns_lvl1
        value = videofile.try_match("adsf1x01.mkv", pattern, 0)
        expect(value.guess).to eq "1x01"
      end
    end
  end

  describe "#get_second_lvl_guess" do
    context "when provided a guessed lvl 2 (S01E01) and episode_patterns_lvl2" do
      it "returns an episode guess" do
        pattern = videofile.episode_patterns_lvl2
        value = videofile.try_match("S01E01", pattern, 0)
        expect(value.guess).to eq "E01"
      end
    end
    
    context "when provided a guessed lvl 2 (1x01) and episode_patterns_lvl2" do
      it "returns an episode guess" do
        pattern = videofile.episode_patterns_lvl2
        value = videofile.try_match("1x01", pattern, 0)
        expect(value.guess).to eq "x01"
      end
    end

    context "when provided a guessed lvl 2 (adsfEpisode1) and episode_patterns_lvl2" do
      it "returns an episode guess" do
        pattern = videofile.episode_patterns_lvl2
        value = videofile.try_match("adsfEpisode1", pattern, 0)
        expect(value.guess).to eq "1"
      end
    end
  end

  describe "#get_episode_number" do
    context "when provided filename (Episode 1 - blabla)" do
      it "returns the episode number 1 (integer)" do
        value = videofile.get_episode_number("Episode 1 - blabla")
        expect(value).to eq 1
      end
    end
    
    context "when provided filename (blabla S01E01)" do
      it "returns the episode number 1 (integer)" do
        value = videofile.get_episode_number("blabla S01E01")
        expect(value).to eq 1
      end
    end
    
    context "when provided filename (blabla 1x01)" do
      it "returns the episode number 1 (integer)" do
        value = videofile.get_episode_number("blabla 1x01")
        expect(value).to eq 1
      end
    end
    
    context "when provided invalid filename" do
      it "returns nil" do
        value = videofile.get_episode_number("asdf")
        expect(value).to eq nil
      end
    end
  end

  describe "#identify_file" do
    context "when provided video filename" do
      it "returns :video and name" do
        value = videofile.identify_file("blabla S01E01.avi")
        expect(value).to eq [:video, "blabla S01E01.avi"]
      end
    end

    context "when provided subtitle filename" do
      it "returns :subtitle and name" do
        value = videofile.identify_file("blabla S01E01.sub")
        expect(value).to eq [:subtitle, "blabla S01E01.sub"]
      end
    end

    context "when provided invalid filename" do
      it "returns :other and name" do
        value = videofile.identify_file("adsfadslkjeqr.mp3")
        expect(value).to eq [:other, "adsfadslkjeqr.mp3"]
      end
    end
  end

end
