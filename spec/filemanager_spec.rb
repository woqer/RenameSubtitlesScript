require 'spec_helper'
require 'fileutils'

describe FileManagerHelper do
  original_filename = "prueba-renombrado.orig"

  project_path = FileUtils.pwd

  before :all do
    FileUtils.mkdir_p("tmp")
    FileUtils.cd("tmp")
    FileUtils.touch(original_filename)
    current_path = FileUtils.pwd
    puts "\n[FileManagerHelper Tests] before all --> [#{current_path}]\n"
  end

  after :all do
    FileUtils.cd(project_path)
    FileUtils.rm Dir.glob("tmp/*")
    current_path = FileUtils.pwd
    puts "\n[FileManagerHelper Tests] after all --> [#{current_path}]\n"
  end

  describe "::listdirectory" do
    it "lists contents of current directory" do
      expect(FileManagerHelper.listdirectory).to eq ([original_filename])
    end
  end

  describe "::rename" do
    context "when renaming existent file" do
      dest = "prueba-renombrado.dest"

      it "origin should not exist" do
        FileManagerHelper.rename(original_filename, dest)
        expect(File.exists?(original_filename)).to eq false
      end

      it "destiny should exist" do
        expect(File.exists?(dest)).to eq true
      end
    end
  end
end
