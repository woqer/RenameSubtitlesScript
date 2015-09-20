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

# describe "#process" do
#   context "when given a filename of video" do
#     it "returns :video key" do
#       expect(process("Episode 10 - Raised by Another.mkv")).to eq [:video, "Episode 10 - Raised by Another.mkv"]
#     end
#   end
# end

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
        ],
        other: []
      }
      value = organize_files files 
      expect(value).to eq compare_result
    end
  end
end

describe "#subs_to_video_map" do
  context "when given a hash of video and subtitle elements" do
    it "returns a hash with matching subtitles" do
      subtitle = VideoElement.new("S01E10 - Raised by Another.srt")
      video = VideoElement.new("Episode 10 - Raised by Another.mkv")
      elements = {
        subtitle: [
          subtitle, VideoElement.new("S01E01 - adf.srt")
        ],
        video: [
          video
        ],
        other: [
          VideoElement.new("asdfdsaf.txt")
        ]
      }
      result = subs_to_video_map(elements)
      compare_result = {}
      compare_result[subtitle] = video
      expect(result).to eq compare_result
    end
  end
end

describe "#rename_subtitles" do

  project_path = FileUtils.pwd
  
  video_name = "Episode 22.mkv"
  subtitle_name = "1x22.srt"
  subtitle = VideoElement.new(subtitle_name)
  video = VideoElement.new(video_name)

  before :all do
    FileUtils.mkdir_p("tmp")
    FileUtils.cd("tmp")
    FileUtils.touch(video_name)
    FileUtils.touch(subtitle_name)
  end

  after :all do
    FileUtils.cd(project_path)
    FileUtils.rm Dir.glob("tmp/*")
  end

  context "when given a hash with the matching subtitles-videos" do
    it "renames the subtitles to video names with sub extension" do
      map = { subtitle: [subtitle], video: [video] }
      rename_subtitles(map)
      expect(File.exists?("Episode 22.srt")).to eq true 
    end
  end
end
