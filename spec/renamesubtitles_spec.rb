require 'spec_helper'

describe "#extension_pattern" do
  it "returns the pattern for extensions" do
    expect(extension_pattern).to eq (/\.(\w|\d)*$/)
  end
end

describe "#prepare_files" do
  it "returns and array of filenames, discarding directories" do
    expect(prepare_files.compact).to eq ["README.md", "Gemfile.lock", "episodes-list.txt"]
  end
end

describe "#process" do
  context "when given a filename of video" do
    it "returns :video key" do
      expect(process("Episode 10 - Raised by Another.mkv")).to eq [:video, "Episode 10 - Raised by Another.mkv"]
    end
  end
end

describe "#organize_files" do
  context "when given an array of video/subtitles filenames" do
    it "returns a hash with videos and subtitles separated" do
      files = ["Episode 10 - Raised by Another.mkv", "Episode 10 - Raised by Another.srt"]
      compare_result = {
        subtitle: [
          VideoElement.new("Episode 10 - Raised by Another.srt")
        ],
        video: [
          VideoElement.new("Episode 10 - Raised by Another.mkv")
        ]
      }
      value = organize_files files 
      expect(value).to eq compare_result
    end
  end
end
