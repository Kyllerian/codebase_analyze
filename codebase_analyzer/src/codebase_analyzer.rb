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

  class MetricsComparator
    # Инициализация с двумя хэшами метрик для сравнения
    def initialize(metrics1, metrics2)
      @metrics1 = metrics1
      @metrics2 = metrics2
    end

    # Сравнивает метрики и возвращает хэш с результатами
    def compare
      comparison_result = {}

      # Перебор всех ключей в первом наборе метрик
      @metrics1.each_key do |key|
        value1 = @metrics1[key]
        value2 = @metrics2[key] || 0  # Поддержка случаев, когда во втором наборе отсутствует ключ
        comparison_result[key] = {
          old: value1,
          new: value2,
          difference: value2 - value1
        }
      end

      # Проверка на новые ключи во втором наборе метрик
      @metrics2.each_key do |key|
        next if comparison_result.key?(key)  # Пропустить ключи, которые уже были обработаны

        value1 = @metrics1[key] || 0  # Поддержка случаев, когда в первом наборе отсутствует ключ
        value2 = @metrics2[key]
        comparison_result[key] = {
          old: value1,
          new: value2,
          difference: value2 - value1
        }
      end

      comparison_result
    end

    # Форматирование результатов сравнения в читабельный формат
    def format_comparison(comparison_results)
      comparison_results.map do |key, values|
        formatted_key = key.to_s.gsub('_', ' ').capitalize  # Заменяем подчеркивания на пробелы и делаем первую букву заглавной
        "#{formatted_key}:\n" \
          "  Previous: #{values[:old]}\n" \
          "  Current: #{values[:new]}\n" \
          "  Difference: #{values[:difference]}\n\n"
      end.join
    end
  end
end
