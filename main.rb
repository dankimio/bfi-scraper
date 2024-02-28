require 'debug'
require 'capybara/dsl'
require 'selenium-webdriver'

BASE_URL = 'https://whatson.bfi.org.uk'

Capybara.default_driver = :selenium_chrome
# Capybara.default_driver = :selenium_chrome
# Capybara.default_driver = :selenium_chrome_headless
Capybara.app_host = BASE_URL

class BFI
  include Capybara::DSL

  def initialize
  end

  def run
    visit('/Online/default.asp')

    find('.calendar-container').find_button('29').click

    events = []
    all('.item-name').each do |item|
      title = item.find('a.more-info')['title'] rescue nil

      result = { title: title }
      puts result

      events << result
    end
  end
end

BFI.new.run
