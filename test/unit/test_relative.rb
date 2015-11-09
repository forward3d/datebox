require File.join(File.dirname(__FILE__), '..', 'test_helper')

class TestRelative < Test::Unit::TestCase

  def test_gives_back_correct_period_name_in_proc
    assert_equal :day_in_19, Datebox::Relative.day_in_19.period_name
  end
  
  def test_calculates_correctly
    # day
    assert_equal [Date.parse('2013-07-07')], Datebox::Relative.same_day.to('2013-07-07').dates
    assert_equal [Date.parse('2013-07-06')], Datebox::Relative.day_before.to('2013-07-07').dates
    assert_equal [Date.parse('2013-07-02')], Datebox::Relative.day_apart(1).to('2013-07-01').dates
    assert_equal [Date.parse('2013-08-03')], Datebox::Relative.day_apart(-2).to('2013-08-05').dates
    assert_equal [Date.parse('2013-08-03')], Datebox::Relative.day_apart(-2).to('2013-08-05').dates
    assert_equal [Date.parse('2013-08-03')], Datebox::Relative.day_ago_2.to('2013-08-05').dates
    assert_equal [Date.parse('2013-08-08')], Datebox::Relative.day_in_3.to('2013-08-05').dates
    assert_equal [Date.parse('2013-08-20')], Datebox::Relative.day_in_19.to('2013-08-01').dates

    # n days
    assert_equal Datebox::Period.new('2014-06-01', '2014-06-30'), Datebox::Relative.last(:n_days, {:days => 30}).to('2014-06-30')
    assert_equal Datebox::Period.new('2014-06-01', '2014-06-30'), Datebox::Relative.last(:n_days, {days: 30, exclusive: true}).to('2014-07-01')

    # week
    assert_equal Datebox::Period.new('2013-07-01', '2013-07-07'), Datebox::Relative.last_week.to('2013-07-09') # tue
    assert_equal Datebox::Period.new('2013-06-30', '2013-07-06'), Datebox::Relative.last_week({:last_weekday => "Saturday"}).to('2013-07-09') #tue
    assert_equal Datebox::Period.new('2013-07-01', '2013-07-05'), Datebox::Relative.last_weekdays_between("Monday", "Friday").to('2013-07-09') # tue
    assert_equal Datebox::Period.new('2013-07-08', '2013-07-09'), Datebox::Relative.last_weekdays_between("Monday", "Tuesday").to('2013-07-09') #tue

    # month
    assert_equal Datebox::Period.new('2013-06-01', '2013-06-30'), Datebox::Relative.last_month.to('2013-07-09')
    assert_equal Datebox::Period.new('2013-07-01', '2013-07-09'), Datebox::Relative.month_to_date.to('2013-07-09')
    assert_equal Datebox::Period.new('2013-02-01', '2013-02-28'), Datebox::Relative.last(:month).to('2013-03-02')

    # year
    assert_equal Datebox::Period.new('2012-01-01', '2012-12-31'), Datebox::Relative.last_year.to('2013-07-09')
    assert_equal Datebox::Period.new('2013-01-01', '2013-07-09'), Datebox::Relative.year_to_date.to('2013-07-09')

    # anything, past
    assert_equal Datebox::Period.new('2013-06-01', '2013-06-01'), Datebox::Relative.last(:day).to('2013-06-02')
    assert_equal Datebox::Period.new('2013-06-01', '2013-06-30'), Datebox::Relative.last(:month).to('2013-07-09')
    assert_equal Datebox::Period.new('2014-02-03', '2014-02-09'), Datebox::Relative.last(:week).to('2014-02-10')
    assert_equal Datebox::Period.new('2014-02-02', '2014-02-08'), Datebox::Relative.last(:week, {:last_weekday => "Saturday"}).to('2014-02-10')

    # andything, up to date
    assert_equal Datebox::Period.new('2015-03-15', '2015-03-21'), Datebox::Relative.to_date(:week, {:last_weekday => "Saturday"}).to('2015-03-21')
    assert_equal Datebox::Period.new('2015-03-15', '2015-03-20'), Datebox::Relative.to_date(:week, {:last_weekday => "Saturday"}).to('2015-03-20')
    assert_equal Datebox::Period.new('2015-03-01', '2015-03-20'), Datebox::Relative.to_date(:month).to('2015-03-20')
    assert_equal Datebox::Period.new('2015-01-01', '2015-03-20'), Datebox::Relative.to_date(:year).to('2015-03-20')
    assert_equal Datebox::Period.new('2015-01-01', '2015-03-20'), Datebox::Relative.year_to_date.to('2015-03-20')

    # the one that's different
    assert_equal [Date.parse('2013-07-01'), Date.parse('2013-07-03')], Datebox::Relative.last_weeks_weekdays_as!("Monday", "Wednesday").to('2013-07-05') #fri
   
   
    assert_equal Datebox::Period.new('2015-11-02', '2015-11-08'), Datebox::Relative.same_week.to('2015-11-02') # mon
    assert_equal Datebox::Period.new('2015-11-02', '2015-11-08'), Datebox::Relative.same_week.to('2015-11-03') # tue
    assert_equal Datebox::Period.new('2015-11-02', '2015-11-08'), Datebox::Relative.same_week.to('2015-11-08') # sun

    assert_equal Datebox::Period.new('2015-11-01', '2015-11-30'), Datebox::Relative.same_month.to('2015-11-30')
  end

end