#!/usr/bin/env ruby
#
# file: performance.rb
#
# For measuring performance of molecular simulation in this
# project:  https://github.com/concord-consortium/lab
#
# Gem prequisites:
#
#   gem install selenium-webdriver
#
# Selenium WebDriver References:
#
#   http://code.google.com/p/selenium/wiki/RubyBindings
#
# Installation:
#
#   curl https://raw.github.com/gist/2026947/performance.rb -o performance.rb
#   chmod u+x performance.rb
#
# Edit paths in the file to reference locations for FireFox and Chrome
# on your computer.
#

require "selenium-webdriver"

require 'fileutils'
require 'yaml'

PROJECT_ROOT = File.expand_path('../',  __FILE__)
CONFIG_PATH = File.join(PROJECT_ROOT, 'config.yml')
begin
  CONFIG = YAML.load_file(CONFIG_PATH)
rescue Errno::ENOENT
  msg = <<-HEREDOC

*** missing #{CONFIG_PATH}

    cp config_sample.yml config.yml

    and edit appropriately ...

  HEREDOC
  raise msg
end

drivers = { 
  :firefox => Selenium::WebDriver::Firefox,
  :chrome  => Selenium::WebDriver::Chrome,
  :safari => Selenium::WebDriver::Safari
}

browsers_to_test = CONFIG[:browsers_to_test]
URL_TO_COMPLEX_MODEL = CONFIG[:url]

puts
puts "*** git commit"
puts
puts `git log -1`
puts

browsers_to_test.each do |browser|

  drivers[browser[:driver]].path = browser[:path]
  driver =  Selenium::WebDriver.for browser[:driver]

  driver.manage.window.resize_to(1280, 800)

  driver.navigate.to URL_TO_COMPLEX_MODEL

  Selenium::WebDriver::Support::Select.new(driver.find_element(:id, 'select-molecule-number')).select_by(:value, "50")

  coulomb_forces = driver.find_element(:id, 'coulomb-forces-checkbox')
  coulomb_forces.click if coulomb_forces.attribute('checked') == "true"

  driver.execute_script("document.getElementById('select-temperature').value='5'")
  driver.execute_script("var s1 = document.getElementById('select-temperature-display'); if (s1) { s1.textContent='5' };")
  driver.execute_script("temperature = 5")
  driver.execute_script("if (typeof modelReset === 'function') { modelReset(); } else { controller.modelReset(); }")

  # turn on temperature control
  temperature_control = driver.find_element(:id, 'temperature-control-checkbox')
  temperature_control.click if temperature_control.attribute('checked') == "false"
  sleep 1

  # turn off temperature control
  temperature_control = driver.find_element(:id, 'temperature-control-checkbox')
  temperature_control.click if temperature_control.attribute('checked') == "true"
  sleep 2

  benchmark_button = driver.find_element(:id, 'start-benchmarks')
  10.times { 
    benchmark_button.click
  }

  table = driver.find_element(:id, 'benchmarks-table')
  rows = table.find_elements(:xpath, './/tr')
  headers = rows.shift

  data = rows[0].find_elements(:xpath, './/td')

  puts
  puts "browser: #{data[0].text}: #{data[1].text}, #{data[2].text}"
  puts "Date: #{data[3].text}"
  puts "Molecule number: #{data[4].text}"
  puts "Temperature: #{data[5].text}"
  puts

  steps = steps_graphics = 0

  # for some (perhaps strange xpath thing) there are twice as many
  # rows returned than actual rows -- so hack together a way of
  # ignoring the blank rows
  count = 0
  rows.each do |row|
    next if row.text == ""
    count += 1
    data = row.find_elements(:xpath, './/td')
    steps +=  data[-2].text.to_f
    steps_graphics +=  data[-1].text.to_f
  end
  steps_ave = steps/count
  steps_graphics_ave = steps_graphics/count
  puts sprintf("%-30s %.2f", "average steps", steps_ave)
  puts sprintf("%-30s %.2f", "average steps w/graphics", steps_graphics_ave)
  driver.quit
end
puts
