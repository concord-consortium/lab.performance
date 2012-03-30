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

#
# Edit these Paths
#
PATH_TO_FIREFOX_NIGHTLY = "/Users/stephen/Applications/FireFox\ Nightly.app/Contents/MacOS/firefox"
PATH_TO_FIREFOX_10_0_2 = "/Users/stephen/Applications/FireFox.app/Contents/MacOS/firefox"
PATH_TO_CHROME_CANARY = "/Users/stephen/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary"

URL_TO_COMPLEX_MODEL = "http://lab.local/examples/complex-atoms-model/complex-atoms-model.html"

#
# Select which browser to test
#
Selenium::WebDriver::Chrome.path = PATH_TO_CHROME_CANARY
driver = Selenium::WebDriver.for :chrome

# Selenium::WebDriver::Firefox.path = PATH_TO_FIREFOX_10_0_2
# driver = Selenium::WebDriver.for :firefox

driver.navigate.to URL_TO_COMPLEX_MODEL

Selenium::WebDriver::Support::Select.new(driver.find_element(:id, 'select-molecule-number')).select_by(:value, "50")

coulomb_forces = driver.find_element(:id, 'coulomb-forces-checkbox')
coulomb_forces.click if coulomb_forces.attribute('checked') == "true"

driver.execute_script("document.getElementById('select-temperature').value='5'")
driver.execute_script("var s1 = document.getElementById('select-temperature-display'); if (s1) { s1.textContent='5' };")
driver.execute_script("temperature = 5")
driver.execute_script("if (typeof modelReset === 'function') { modelReset(); } else { model_controller.modelReset(); }")

# turn on temperature control
temperature_control = driver.find_element(:id, 'temperature-control-checkbox')
temperature_control.click if temperature_control.attribute('checked') == "false"
sleep 1

# turn off temperature control
temperature_control = driver.find_element(:id, 'temperature-control-checkbox')
temperature_control.click if temperature_control.attribute('checked') == "true"
sleep 1

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
puts "git commit"
puts system("git log -1")
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
