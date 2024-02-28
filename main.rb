require 'capybara/dsl'
require 'selenium-webdriver'

BASE_URL = 'https://whatson.bfi.org.uk'

Capybara.default_driver = :selenium_chrome_headless
Capybara.app_host = BASE_URL

class BFI
  include Capybara::DSL

  def initialize
  end

  def run
    visit('/Online/default.asp')

    events = []
    all('.event-list-item').each do |item| # Adjust the selector as per actual HTML structure
      title = item.find('.event-title').text rescue nil # Adjust the selector
      date = item.find('.event-date').text rescue nil # Adjust the selector
      link = item.find('.buy-link')['href'] rescue nil # Adjust the selector

      events << { title: title, date: date, link: link }
    end
  end
end

BFI.new.run
