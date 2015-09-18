#!/usr/bin/env ruby
#encoding: utf-8

require "pp"
require "pry"

module FileManagerHelper
  extend self

  def listdirectory
    Dir["*"]
  end

  def rename(origin, destiny)
    File.rename(origin, destiny)
  end
end

class RecursivePattern
  attr_reader :guess, :iteration
  def initialize(args={})
    @guess = args[:guess] || ""
    @iteration = args[:iteration] || 0
  end

  def ==(other)
    guess == other.guess && iteration == other.iteration
  end
end

module VideoFile
  def episode_patterns_lvl1
    [/S\d+E\d+/, /\d+x\d+/, /.*\d+/]
  end

  def episode_patterns_lvl2
    [/E\d+/, /x\d+/, /\d+/]
  end

  def file_pattern(extensions)
    extensions.map { |extension| /\.#{extension}$/ }
  end

  def video_extensions
    ["mkv", "avi", "mp4"]
  end

  def subtitle_extensions
    ["srt", "sub"]
  end

  def try_match(name, pattern_array, iteration)
    return RecursivePattern.new() if iteration > pattern_array.size - 1

    guess = name[pattern_array[iteration]]

    if guess.nil?
      try_match name, pattern_array, iteration + 1
    else
      return RecursivePattern.new(guess: guess, iteration: iteration)
    end
  end

  def get_second_lvl_guess(guess_response)
    guess_response.guess[episode_patterns_lvl2[guess_response.iteration]]
  end

  def get_episode_number(file_name)
    guess_response = try_match(file_name, episode_patterns_lvl1, 0)
    guess2 = get_second_lvl_guess(guess_response)
    if guess2.nil?
      guess2
    else
      guess2[/\d+/].to_i
    end
  end

  def identify_file(name)
    video_name_response = try_match name, file_pattern(video_extensions), 0

    if video_name_response.guess.eql? ""
      subtitle_name_response = try_match name, file_pattern(subtitle_extensions), 0
      return :other  if subtitle_name_response.guess.eql? ""
      return :subtitle
    else
      return :video
    end
  end
end

class VideoElement
  include VideoFile
  attr_reader :episode, :name, :type, :extension, :new_name

  def initialize(name)
    @extension = File.extname(name)
    @episode = episode_initializer name
    @name = name_initializer name
    @type = type_initializer name
    @new_name = nil
  end

  def name_initializer(name)
    File.basename(name, extension)
  end

  def type_initializer(name)
    identify_file name
  end

  def episode_initializer(name)
    get_episode_number name    
  end

  def not_an_episode?
    episode.nil?
  end

  def ==(other)
    episode == other.episode && name == other.name && type == other.type
  end

  def same_episode?(other)
    episode == other.episode
  end

  def save_new_name!(other)
    @new_name = other.name
  end

  def get_filename
    "#{name}#{extension}"
  end

  def get_rename_filename
    "#{new_name}#{extension}"
  end
end

# def process(line)
#   VideoFileClass.identify_file line
# end

def extension_pattern
  VideoFileClass.file_pattern(["(\\w|\\d)*"]).first
end

def prepare_files
  FileManagerHelper.listdirectory.map do |entry|
    extension = entry[extension_pattern]
    if extension.nil?
      nil
    else
      entry.gsub(extension, extension.downcase)
    end
  end
end

def organize_files(files)
  input = {subtitle: [], video: [], other: []}
  files.each do |file|
    ve = VideoElement.new(file.gsub("\n", ""))
    input[ve.type] << ve
  end

  input
end

def subs_to_video_map(elements)
  elements[:subtitle].reduce({}) do |mem, subtitle|
    matching_video = elements[:video].find { |video| video.same_episode?(subtitle) }
    mem[subtitle] = matching_video
    mem
  end
end

def rename_subtitles(elements)
  subs_to_video_map(elements).each do |sub, video|
    sub.save_new_name! video
    FileManagerHelper.rename(sub.get_filename, sub.get_rename_filename)
  end
end

VideoFileClass = Class.new { extend VideoFile }

files = prepare_files

elements = organize_files(files.compact)

rename_subtitles(elements)
