ENV["RACK_ENV"] = "test"

require 'bundler'
Bundler.require :default, :test
require_relative '../app'


class IdeaBoxAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    IdeaBoxApp.new
  end

  def test_group_default_route_respons_with_a_delete_button
    get '/group/default'
    html = Nokogiri::HTML(last_response.body)
    assert last_response.ok?
    assert_equal "delete", html.at_css('form input')['value']
  end
end
