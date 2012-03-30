For measuring performance of molecular simulations in this project:  https://github.com/concord-consortium/lab

Gem prequisites:

    gem install selenium-webdriver

Selenium WebDriver References: http://code.google.com/p/selenium/wiki/RubyBindings

Installation:

In your working copy of the Lab project:

    git checkout git://github.com/concord-consortium/lab.performance.git

Edit paths in the script performance.rb to reference locations for FireFox and Chrome
on your computer.

Measuring performance:

    $ ./lab.performance/performance.rb

    browser: Chrome: 19.0.1085.0, Intel Mac OS X 10_6_8
    Date: 2012-03-30 08:44
    Molecule number: 50
    Temperature: 5

    git commit
    commit 2c3a9328a43964485ed5f661cfb6e6cc6850ce95
    Author: Stephen Bannasch <stephen.bannasch@gmail.com>
    Date:   Fri Mar 30 08:44:05 2012 -0400

        whitespace fixups
    true

    average steps                  167.30
    average steps w/graphics       101.63

