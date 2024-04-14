# frozen_string_literal: true
require_relative "lib/codebase_analyzer/version"

Gem::Specification.new do |spec|
  spec.name = "codebase_analyzer"
  spec.version = CodebaseAnalyzer::VERSION
  spec.authors = ["kyllerian"]
  spec.email = ["kyllerian@icloud.com"]

  spec.summary = "A gem for analyzing codebases and generating metrics."
  spec.description = "This gem provides functionality to analyze codebases, generating reports on file, class, and line counts, and allowing comparison between different versions of the same codebase."
  spec.homepage = "https://github.com/kyllerian/codebase_analyzer"  # Пример URL вашего проекта на GitHub

  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"  # Обычный хост для публикации Ruby гемов

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage  # Используйте тот же URL, если у вас нет отдельного URL для исходного кода
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"  # Предполагаемый путь к файлу CHANGELOG

  # Указывает, какие файлы должны быть добавлены в гем при его релизе
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Добавьте зависимости, если они есть
  # spec.add_dependency "some-dependency", "~> 1.0"
end
