# frozen_string_literal: true


require 'spec_helper'
require_relative '../src/codebase_analyzer'

# Начинаем блок тестирования для класса MetricsComparator
RSpec.describe CodebaseAnalyzer::MetricsComparator do
  # Группируем тесты, касающиеся метода #compare
  describe "#compare" do
    # Определяем переменные, используемые в тестах, для двух наборов метрик
    let(:metrics1) { { total_files: 10, total_classes: 5, total_methods: 15, total_lines: 100 } }
    let(:metrics2) { { total_files: 12, total_classes: 5, total_methods: 17, total_lines: 110 } }
    let(:comparator) { described_class.new(metrics1, metrics2) }  # Экземпляр компаратора

    # Тест на корректное вычисление различий между двумя наборами метрик
    it "returns differences in metrics between two data sets" do
      # Ожидаемые результаты после сравнения
      expected_results = {
        total_files: { old: 10, new: 12, difference: 2 },
        total_classes: { old: 5, new: 5, difference: 0 },
        total_methods: { old: 15, new: 17, difference: 2 },
        total_lines: { old: 100, new: 110, difference: 10 }
      }
      # Проверяем, что метод compare возвращает правильные результаты
      expect(comparator.compare).to eq(expected_results)
    end
  end

  # Группируем тесты, касающиеся метода #format_comparison
  describe "#format_comparison" do
    # Тестовые данные для форматирования
    let(:comparison_results) {
      {
        total_files: { old: 10, new: 12, difference: 2 },
        total_classes: { old: 5, new: 5, difference: 0 },
        total_methods: { old: 15, new: 17, difference: 2 },
        total_lines: { old: 100, new: 110, difference: 10 }
      }
    }
    # Создаём экземпляр компаратора для тестирования форматирования
    let(:comparator) { described_class.new({}, {}) }

    # Тест на корректное форматирование результатов сравнения
    it "formats the comparison results into a readable string" do
      # Ожидаемый результат в виде строк
      formatted_string = "Total files:\n  Previous: 10\n  Current: 12\n  Difference: 2\n\n" +
        "Total classes:\n  Previous: 5\n  Current: 5\n  Difference: 0\n\n" +
        "Total methods:\n  Previous: 15\n  Current: 17\n  Difference: 2\n\n" +
        "Total lines:\n  Previous: 100\n  Current: 110\n  Difference: 10\n\n"
      # Проверяем, что метод format_comparison возвращает правильно отформатированную строку
      expect(comparator.format_comparison(comparison_results)).to eq(formatted_string)
    end
  end
end
