require 'spec_helper'
require "pry"

describe VideoFile do

  let(:videofile_class) { Class.new { include VideoFile } }
  let(:videofile) { videofile_class.new }

  describe "#video_extensions" do
    context "when calling method" do
      it "returns array of video extensions" do
        # binding.pry
        expect(videofile.video_extensions).to eq ["mkv", "avi", "mp4"]
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

end
