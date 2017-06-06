require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

class AlrayanScraper
  extend Capybara::DSL

  class << self
    def phantomjs_binary
      File.expand_path(__dir__ + '/../bin/phantomjs-linux64')
    end

    def setup
      Capybara.register_driver :poltergeist do |app|
        options = {
          phantomjs: phantomjs_binary
        }
        Capybara::Poltergeist::Driver.new(app, options)
      end
      Capybara.default_driver = :poltergeist
    end

    def screenshot
      file = "#{__dir__}/../tmp/screenshot.jpeg"
      page.save_screenshot(file)
      system("xdg-open #{file}")
    end

    def scrape
      setup

      base = 'https://online.alrayanbank.co.uk'

      visit "#{base}/online/aspscripts/Logon.asp"
      if ! page.has_content?('#username') and page.has_content?('#passcode')
        raise '#username and #passcode not found'
      end
      screenshot
    end
  end
end
