# CodebaseAnalyzer

`CodebaseAnalyzer` — это инструмент на Ruby, предназначенный для анализа кодовой базы и сравнения метрик различных версий кода. Этот инструмент позволяет быстро получить представление о структуре проекта, количестве классов, методов и строк кода, а также сравнить текущие метрики с предыдущими анализами.

## Особенности

- **Анализ кодовой базы**: Получение метрик как количество файлов, классов, методов и строк.
- **Сравнение метрик**: Возможность сравнивать текущие метрики с результатами предыдущих анализов.
- **Поддержка множества языков**: Инструмент может быть расширен для поддержки различных языков программирования.

## Установка

Для использования `CodebaseAnalyzer` клонируйте этот репозиторий и установите зависимости:

```bash
git clone https://github.com/Kyllerian/codebase_analyze
cd codebase_analyzer
bundle install
```
## Использование

Для запуска анализа кодовой базы выполните следующую команду:

```bash
ruby demo.rb path/to/your/codebase
```

## Тесты

Для запуска тестов выполните следующие команды:

```bash
cd codebase_analyzer
bundle exec rspec spec/analyzer_spec.rb   
bundle exec rspec spec/metrics_comparator_spec.rb
```
----
# class Analyzer
Класс Analyzer, выполняет ключевую роль в анализе кодовой базы. Этот класс предназначен 
для извлечения метрик из заданной директории с кодом, что помогает оценить объем и сложность проекта. 
Вот подробное описание этого класса, его методов, свойств и предполагаемого использования.


### Свойства
 - **directory_path** (String): Путь к директории, которую нужно анализировать. Это должен быть абсолютный или относительный путь к папке с исходным кодом.


## Методы инициализация


### initialize(directory_path)

Параметры:
 - **directory_path** (String) — путь к директории для анализа.

    Описание: Конструктор класса, который инициализирует экземпляр с указанным путём к директории.


### analyze()
Возвращает: Hash

Описание: Основной метод класса, выполняющий анализ директории. 
Извлекает метрики, такие как количество файлов, классов, 
методов и общее количество строк кода. 
Возвращает хэш с этими данными.

пример возвращаемого значения:

```ruby
{
total_files: 100,
total_classes: 25,
total_methods: 75,
total_lines: 1500
}
```

### Пример использования класса
Для использования класса Analyzer необходимо создать его экземпляр, 
передав путь к директории с кодом, и вызвать метод analyze:

```ruby
analyzer = CodebaseAnalyzer::Analyzer.new('path/to/project')
metrics = analyzer.analyze
puts metrics
```

### Тестирование

Запуск тестов для класса Analyzer:
```bash
cd codebase_analyzer
bundle exec rspec spec/analyzer_spec.rb
```

------------
# class MetricsComparator

Класс MetricsComparator предназначен для сравнения метрик кодовой 
базы между двумя различными временными точками или версиями. 
Это позволяет пользователям видеть изменения в кодовой базе, 
такие как увеличение или уменьшение количества классов, методов, 
строк кода и других метрик.

### Свойства
 - **old_metrics** (Hash): Хеш с метриками предыдущего анализа.
 - **new_metrics** (Hash): Хеш с метриками текущего анализа.

### Методы инициализация

initialize(old_metrics, new_metrics)

Параметры:
 - **old_metrics** (Hash) — метрики предыдущего анализа.
 - **new_metrics** (Hash) — метрики текущего анализа.

Описание: Конструктор класса, который инициализирует экземпляр с двумя наборами метрик для сравнения.

### Сравнение метрик

 - **compare()**

    Возвращает: Hash

    Описание: Выполняет сравнение метрик из old_metrics и new_metrics. Возвращает хеш с деталями различий для каждой метрики.
    
    Пример возвращаемого значения:
    ```ruby
    {
      total_files: { old: 100, new: 105, difference: 5 },
      total_classes: { old: 10, new: 12, difference: 2 },
      total_methods: { old: 50, new: 55, difference: 5 },
      total_lines: { old: 1000, new: 1100, difference: 100 }
    }
    ```

### Пример использования
Для использования класса MetricsComparator необходимо создать 
его экземпляр с двумя наборами метрик и вызвать метод **compare**:

```ruby
    old_metrics = { total_files: 100, total_classes: 10, total_methods: 50, total_lines: 1000 }
    new_metrics = { total_files: 105, total_classes: 12, total_methods: 55, total_lines: 1100 }

    comparator = CodebaseAnalyzer::MetricsComparator.new(old_metrics, new_metrics)
    comparison_results = comparator.compare
    puts comparison_results
```

### Тестирование

Запуск тестов для класса Analyzer:
```bash
cd codebase_analyzer
bundle exec rspec spec/metrics_comparator.rb
```

------------