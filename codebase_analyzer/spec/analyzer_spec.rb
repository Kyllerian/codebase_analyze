# frozen_string_literal: true
# Подключаем вспомогательные файлы RSpec и класс Analyzer для тестирования
require 'spec_helper'
require_relative '../src/codebase_analyzer'

# Описание тестов для класса Analyzer в рамках модуля CodebaseAnalyzer
RSpec.describe CodebaseAnalyzer::Analyzer do
  # Группировка тестов, связанных с методом #analyze
  describe "#analyze" do
    # Использование let для определения переменных, доступных во всех тестах данной группы
    let(:test_directory) { 'spec/fixtures/test_project' }  # Путь к тестовой директории
    let(:analyzer) { CodebaseAnalyzer::Analyzer.new(test_directory) }  # Создание экземпляра анализатора

    # Настройка моков перед каждым тестом
    before do
      # Мокируем метод Dir.exist? для заданного пути, чтобы он всегда возвращал true
      allow(Dir).to receive(:exist?).with(test_directory).and_return(true)
      # Мокируем метод Find.find, чтобы он имитировал нахождение одного файла Ruby
      allow(Find).to receive(:find).with(test_directory).and_yield('test_project/test.rb')
      # Мокируем метод File.file?, чтобы он всегда возвращал true для предоставленного пути
      allow(File).to receive(:file?).with('test_project/test.rb').and_return(true)
      # Мокируем метод File.extname, чтобы он возвращал расширение '.rb' для файла
      allow(File).to receive(:extname).with('test_project/test.rb').and_return('.rb')
      # Мокируем метод File.read, чтобы он возвращал содержимое файла с кодом Ruby
      allow(File).to receive(:read).with('test_project/test.rb').and_return("class TestClass\n def test_method; end\nend\n")
    end

    # Тест на проверку корректности подсчёта файлов, классов, методов и строк
    it "correctly counts total files, classes, methods, and lines" do
      # Ожидаемые результаты сравниваются с результатами выполнения метода analyze
      expected_results = {
        total_files: 1,
        total_classes: 1,
        total_methods: 1,
        total_lines: 3
      }
      expect(analyzer.analyze).to eq(expected_results)
    end
  end
end
