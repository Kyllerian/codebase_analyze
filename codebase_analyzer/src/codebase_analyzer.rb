# frozen_string_literal: true

require 'find'

module CodebaseAnalyzer
  class Analyzer
    # Определение массива поддерживаемых расширений файлов для языков Ruby, JavaScript, Python, Java и Kotlin.
    SUPPORTED_EXTENSIONS = ['.rb', '.js', '.py', '.java', '.kt']

    # Конструктор класса инициализирует экземпляр с заданной директорией и нулевыми начальными значениями метрик.
    def initialize(directory)
      @directory = directory  # Директория для анализа
      @results = {            # Хэш для хранения результатов анализа
                              total_files: 0,
                              total_classes: 0,
                              total_methods: 0,
                              total_lines: 0
      }
    end

    # Метод analyze проводит анализ файлов в указанной директории.
    def analyze
      # Проверка существования директории; если директория не существует, выбрасывается исключение.
      raise "Directory does not exist" unless Dir.exist?(@directory)

      # Проход по всем файлам в директории с использованием библиотеки Find.
      Find.find(@directory) do |path|
        next unless File.file?(path)  # Пропускаем, если текущий путь не файл
        extension = File.extname(path)  # Получаем расширение файла
        # Анализируем файл, если его расширение поддерживается
        analyze_file(path, extension) if SUPPORTED_EXTENSIONS.include?(extension)
      end

      @results  # Возвращаем собранные метрики
    end

    private

    # Метод analyze_file читает файл и обновляет метрики.
    def analyze_file(path, extension)
      content = File.read(path)  # Чтение содержимого файла
      @results[:total_files] += 1  # Увеличиваем счетчик файлов
      @results[:total_lines] += content.lines.count  # Подсчитываем строки
      @results[:total_classes] += count_classes(content, extension)  # Подсчитываем классы
      @results[:total_methods] += count_methods(content, extension)  # Подсчитываем методы
    end

    # Метод count_classes возвращает количество классов в зависимости от языка программирования.
    def count_classes(content, extension)
      case extension
      when '.rb', '.py'  # Для Ruby и Python классы начинаются с ключевого слова class.
        content.scan(/^\s*class\s/).size
      when '.java', '.kt'  # Для Java и Kotlin классы могут начинаться с модификаторов доступа.
        content.scan(/^\s*public\s+class\s/).size + content.scan(/^\s*class\s/).size
      else
        0
      end
    end

    # Метод count_methods возвращает количество методов в зависимости от языка программирования.
    def count_methods(content, extension)
      case extension
      when '.rb'  # Для Ruby методы начинаются с def.
        content.scan(/^\s*def\s/).size
      when '.py'  # То же для Python.
        content.scan(/^\s*def\s/).size
      when '.java', '.kt'  # Для Java и Kotlin методы могут начинаться с модификаторов доступа и включать тип возвращаемого значения.
        content.scan(/^\s*public\s+\S+\s+\S+\(/).size + content.scan(/^\s*private\s+\S+\s+\S+\(/).size
      else
        0
      end
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
