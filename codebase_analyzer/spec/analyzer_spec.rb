# frozen_string_literal: true

require 'spec_helper'
require_relative '../src/codebase_analyzer'

RSpec.describe CodebaseAnalyzer::Analyzer do
  describe "#analyze" do
    let(:test_directory) { 'spec/fixtures/test_project' }
    let(:analyzer) { CodebaseAnalyzer::Analyzer.new(test_directory) }

    before do
      allow(Dir).to receive(:exist?).and_call_original
      allow(Dir).to receive(:exist?).with(test_directory).and_return(true)
      allow(File).to receive(:file?).and_call_original
      allow(File).to receive(:file?).with(any_args).and_return(true)
      allow(File).to receive(:extname).and_call_original
      allow(File).to receive(:extname).with(any_args).and_return('.rb')
      allow(File).to receive(:read).with(any_args).and_return("class TestClass\n def test_method; end\nend\n")
    end

    it "correctly counts total files, classes, methods, and lines" do
      expected_results = {
        total_files: 1,
        total_classes: 1,
        total_methods: 1,
        total_lines: 3
      }
      expect(analyzer.analyze).to eq(expected_results)
    end

    context "when directory does not exist" do
      before do
        allow(Dir).to receive(:exist?).with(test_directory).and_return(false)
      end

      it "raises an error" do
        expect { analyzer.analyze }.to raise_error(RuntimeError, "Directory does not exist")
      end
    end
  end
end
