# Datebox

Provides help with managing dates and periods

## Installation

    gem install datebox

## Usage

Include gem in Gemfile

    gem 'datebox'
    # or
    gem 'datebox', :git => 'git@github.com:forward3d/datebox'

Allows using periods

    period = Datebox::Period.new("2013-06-10", "2013-06-27")
    period.from
    period.to

Allows splitting periods (returns ending dates of periods)

    Datebox::Period.split_dates(Date.parse("2013-06-14"), Date.parse("2013-06-27"), "week")

It's also possible to calculate periods relative to given dates

    period_month = Datebox::Relative.last_month.to('2013-07-09') # uses period method
    preiod_week = Datebox::Relative.last(:week).to('2013-07-09') # uses period symbol

It's best to have a look at code & tests