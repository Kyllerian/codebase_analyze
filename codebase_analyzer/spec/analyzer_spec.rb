# frozen_string_literal: true

require 'spec_helper'
require_relative '../src/codebase_analyzer'

# Описываем тесты для класса Analyzer в модуле CodebaseAnalyzer
RSpec.describe CodebaseAnalyzer::Analyzer do
  # Группируем тесты, касающиеся метода #analyze
  describe "#analyze" do
    # Определяем тестовые переменные, которые будем использовать в тестах
    let(:test_directory) { 'spec/fixtures/test_project' }  # Путь к тестовой директории
    let(:analyzer) { CodebaseAnalyzer::Analyzer.new(test_directory) }  # Экземпляр анализатора

    # Настройка моков перед выполнением тестов
    before do
      # Разрешаем вызовы к Dir.exist? возвращать реальные значения, кроме одного конкретного случая
      allow(Dir).to receive(:exist?).and_call_original
      allow(Dir).to receive(:exist?).with(test_directory).and_return(true)

      # Настраиваем моки для File, чтобы они возвращали контролируемые результаты
      allow(File).to receive(:file?).and_call_original
      allow(File).to receive(:file?).with(any_args).and_return(true)
      allow(File).to receive(:extname).and_call_original
      allow(File).to receive(:extname).with(any_args).and_return('.rb')
      allow(File).to receive(:read).with(any_args).and_return("class TestClass\n def test_method; end\nend\n")
    end

    # Тест на корректное подсчёт файлов, классов, методов и строк кода
    it "correctly counts total files, classes, methods, and lines" do
      expected_results = {
        total_files: 1,
        total_classes: 1,
        total_methods: 1,
        total_lines: 3
      }
      expect(analyzer.analyze).to eq(expected_results)
    end

    # Группировка тестов для случая, когда директория не существует
    context "when directory does not exist" do
      before do
        # Имитируем отсутствие директории
        allow(Dir).to receive(:exist?).with(test_directory).and_return(false)
      end

      # Проверяем, что при отсутствии директории вызывается исключение
      it "raises an error" do
        expect { analyzer.analyze }.to raise_error(RuntimeError, "Directory does not exist")
      end
    end
  end
end
