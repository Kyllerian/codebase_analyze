# frozen_string_literal: true

require 'find'

module CodebaseAnalyzer
  class Analyzer
    SUPPORTED_EXTENSIONS = ['.rb', '.js']  # Расширения файлов для анализа

    def initialize(directory)
      @directory = directory
      @results = {
        total_files: 0,
        total_classes: 0,
        total_methods: 0,
        total_lines: 0
      }
    end

    def analyze
      raise "Directory does not exist" unless Dir.exist?(@directory)

      Find.find(@directory) do |path|
        next unless File.file?(path)
        analyze_file(path) if SUPPORTED_EXTENSIONS.include?(File.extname(path))
      end

      @results
    end

    private

    def analyze_file(path)
      content = File.read(path)
      @results[:total_files] += 1
      @results[:total_lines] += content.lines.count
      @results[:total_classes] += count_classes(content)
      @results[:total_methods] += count_methods(content)
    end

    def count_classes(content)
      # Пример простого подсчета классов в Ruby
      content.scan(/^\s*class\s/).size
    end

    def count_methods(content)
      # Пример подсчета методов в Ruby
      content.scan(/^\s*def\s/).size
    end
  end
end
