# frozen_string_literal: true

module RSpecHelpers
  def file_fixture(path)
    File.read(File.join('spec', 'fixtures', path))
  end

  def json_fixture(fixture_name)
    file_fixture("#{fixture_name}.json")
  end

  def to_return_404
    to_return(status: 404, body: json_fixture('error_404'))
  end
end

module WebMock
  class RequestStub
    [200, 400, 404].each do |status|
      define_method("to_return_#{status}") do |body = {}|
        to_return(status: status, body: body.to_json)
      end

      define_method("to_return_#{status}_with") do |body|
        send("to_return_#{status}", body: body)
      end
    end
  end
end
