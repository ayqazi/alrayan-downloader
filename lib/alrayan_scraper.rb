require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'yaml'
require 'pry'

class AlrayanScraper
  include Capybara::DSL

  BASE = 'https://online.alrayanbank.co.uk'

  def self.phantomjs_binary
    File.expand_path(__dir__ + '/../bin/phantomjs-linux64')
  end

  def self.configure_capybara
    Capybara.register_driver :poltergeist do |app|
      options = {
        phantomjs: phantomjs_binary
      }
      Capybara::Poltergeist::Driver.new(app, options)
    end
    Capybara.default_driver = :poltergeist
  end

  def initialize(account)
    @account = account
    @cfg = YAML.load_file("#{__dir__}/../config.yaml").fetch(account)
  end

  attr_reader :cfg, :account

  def screenshot
    file = "#{__dir__}/../tmp/#{account}/screenshot.jpeg"
    page.save_screenshot(file)
    system("xdg-open #{file}")
  end

  def password2(chars)
    cfg['password2'].chars.values_at(*chars.map { |c| c-1 })
  end

  def login
    visit "#{BASE}/online/aspscripts/Logon.asp"
    raise '#username and #passcode not found' if ! page.has_content?('#username') and page.has_content?('#passcode')

    fill_in 'username', with: cfg['username']
    fill_in 'passcode', with: cfg['password']
    click_on 'Continue'

    matches = page.text.match(/Please enter characters (\d+), (\d+) and (\d+) from your memorable information/)
    raise '2nd password prompt not found' if ! matches
    chars = password2(matches[1..3].map(&:to_i))
    fill_in 'RequestChar1', with: chars[0]
    fill_in 'RequestChar2', with: chars[1]
    fill_in 'RequestChar3', with: chars[2]
    click_on 'Log On'
  end

  def scrape
    login
  end
end

AlrayanScraper.configure_capybara
