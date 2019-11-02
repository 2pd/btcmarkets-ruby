# frozen_string_literal: true

module RSpecHelpers
  def file_fixture(path)
    File.read(File.join('spec', 'fixtures', path))
  end

  def json_fixture(fixture_name)
    file_fixture("#{fixture_name}.json")
  end
end
