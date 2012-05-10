For measuring performance of molecular simulations in this project:  https://github.com/concord-consortium/lab

Gem prequisites:

    gem install selenium-webdriver

Selenium WebDriver References: http://code.google.com/p/selenium/wiki/RubyBindings

Installation:

In your working copy of the Lab project:

    git checkout git://github.com/concord-consortium/lab.performance.git

Create `./lab.performance/config.yml` by copying the sample and edit the result
entering the locations for the browsers you want to test and the url for a runnable
local copy of the Complex Atoms Model.

    cp ./lab.performance/config.sample.yml ./lab.performance/config.yml

Example of measuring performance:

    $ ./lab.performance/performance.rb

    browser: Firefox: 12.0, Intel Mac OS X 10.6
    Date: 2012-05-10 15:21
    Molecule number: 50
    Temperature: 3

    git commit
    commit 49850c073d221f56d5cff07ee231f470e69b91a7
    Author: Stephen Bannasch <stephen.bannasch@gmail.com>
    Date:   Fri Mar 30 09:16:32 2012 -0400

        readme: formatting updates, remove gist reference in script
    true

    average steps                  180.14
    average steps w/graphics       58.87

    browser: Chrome: 18.0.1025.142, Intel Mac OS X 10_6_8
    Date: 2012-05-10 15:21
    Molecule number: 50
    Temperature: 3

    git commit
    commit 49850c073d221f56d5cff07ee231f470e69b91a7
    Author: Stephen Bannasch <stephen.bannasch@gmail.com>
    Date:   Fri Mar 30 09:16:32 2012 -0400

        readme: formatting updates, remove gist reference in script
    true

    average steps                  413.44
    average steps w/graphics       156.87
    
