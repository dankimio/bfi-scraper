require 'capybara/dsl'
require 'date'
require 'debug'
require 'selenium-webdriver'

BASE_URL = 'https://whatson.bfi.org.uk'

Capybara.default_driver = :selenium_chrome
# Capybara.default_driver = :selenium_chrome
# Capybara.default_driver = :selenium_chrome_headless
Capybara.app_host = BASE_URL

class BFI
  include Capybara::DSL

  def run
    visit('/Online/default.asp')

    find('.calendar-container').find_button('29').click

    events = []
    all('.item-name')[0..4].each do |item|
      url = item.find('a.more-info')['href']
      # new_window = window_opened_by { item.find('a.more-info').click }

      within_window(open_new_window) do
        visit(url)
        title = find('h1').text

        values = all('.Film-info__information__value')
          .map(&:text)
          .join

        match = values.match(/\d{4}/)

        if match
          matched_year = match[0].to_i

          if (1900..2030).include?(matched_year)
            year = matched_year
          end
        end

        next unless year

        showtimes = all('.result-box-item').map do |item|
          date_and_time_string = item.find('.start-date').text
          next unless date_and_time_string

          date_and_time = DateTime.strptime(date_and_time_string, "%A %d %B %Y %H:%M") rescue nil
          next unless date_and_time

          venue = item.find('.item-venue').text

          { date: date_and_time, venue: venue }
        end

        events << { title: title, year: year, showtimes: showtimes }
      end
    end

    events
  end
end

data = BFI.new.run

File.open('data.json', 'w') do |f|
  f.write(data.to_json)
end
