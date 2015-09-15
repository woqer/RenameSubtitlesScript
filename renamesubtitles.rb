#!/usr/bin/env ruby
#encoding: utf-8

require "pp"

module FileManagerHelper extend self
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

  def get_episode_number(file_name)
    guess_response = try_match(file_name, episode_patterns_lvl1, 0)
    guess2 = guess_response.guess[episode_patterns_lvl2[guess_response.iteration]]
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
      return :other, name if subtitle_name_response.guess.eql? ""
      return :subtitle, name
    else
      return :video, name
    end
  end
end

class VideoElement
  include VideoFile
  attr_reader :episode, :name

  def initialize(name)
    @episode = episode_initializer name
    @name = name
  end

  def episode_initializer(name)
    get_episode_number name    
  end

  def not_an_episode?
    !episode.nil?
  end
end

VideoFileClass = Class.new{extend VideoFile}

def process(line)
  VideoFileClass.identify_file line
end

def main_method
  # List directory and downcase extension of files
  extension_pattern = VideoFileClass.file_pattern([/(\w|\d)*/]).first
  files = FileManagerHelper.listdirectory.map do |entry|
    extension = entry[extension_pattern]
    if extension.nil?
      nil
    else
      entry.gsub(extension, extension.downcase)
    end
  end

  files.compact!

  # MAIN loop
  input = {subtitle: [], video: []}
  files.each do |file|
    key, value = process file
    if !key.eql? :other
      input[key] << VideoElement.new(value.gsub("\n",""))
    end
  end

  input
end
