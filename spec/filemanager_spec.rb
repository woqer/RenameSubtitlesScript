require 'spec_helper'

describe FileManagerHelper do
  let(:original_filename) { "prueba-renombrado.orig" }

  Dir.chdir("tmp")
  File.new("prueba-renombrado.orig", "w+")

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
