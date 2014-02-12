require File.join(File.dirname(__FILE__), '..', 'test_helper')

class TestRelative < Test::Unit::TestCase
  
  def test_calculates_correctly
    # day
    assert_equal [Date.parse('2013-07-07')], Datebox::Relative.new.same_day.to('2013-07-07').dates
    assert_equal [Date.parse('2013-07-06')], Datebox::Relative.new.day_before.to('2013-07-07').dates

    # week
    assert_equal Datebox::Period.new('2013-07-01', '2013-07-07'), Datebox::Relative.new.last_week.to('2013-07-09') #tue
    assert_equal Datebox::Period.new('2013-06-30', '2013-07-06'), Datebox::Relative.new.last_week("Saturday").to('2013-07-09') #tue
    assert_equal Datebox::Period.new('2013-07-01', '2013-07-05'), Datebox::Relative.new.last_weekdays_between("Monday", "Friday").to('2013-07-09') #tue
    assert_equal Datebox::Period.new('2013-07-08', '2013-07-09'), Datebox::Relative.new.last_weekdays_between("Monday", "Tuesday").to('2013-07-09') #tue

    # month
    assert_equal Datebox::Period.new('2013-06-01', '2013-06-30'), Datebox::Relative.new.last_month.to('2013-07-09')
    assert_equal Datebox::Period.new('2013-07-01', '2013-07-09'), Datebox::Relative.new.month_to_date.to('2013-07-09')

    # year
    assert_equal Datebox::Period.new('2012-01-01', '2012-12-31'), Datebox::Relative.new.last_year.to('2013-07-09')
    assert_equal Datebox::Period.new('2013-01-01', '2013-07-09'), Datebox::Relative.new.year_to_date.to('2013-07-09')

    # anything
    assert_equal Datebox::Period.new('2013-06-01', '2013-06-01'), Datebox::Relative.new.last(:day).to('2013-06-02')
    assert_equal Datebox::Period.new('2013-06-01', '2013-06-30'), Datebox::Relative.new.last(:month).to('2013-07-09')
    assert_equal Datebox::Period.new('2014-02-03', '2014-02-09'), Datebox::Relative.new.last(:week).to('2014-02-10')
    assert_equal Datebox::Period.new('2014-02-02', '2014-02-08'), Datebox::Relative.new.last(:week_ss).to('2014-02-10')

    # the one that's different
    assert_equal [Date.parse('2013-07-01'), Date.parse('2013-07-03')], Datebox::Relative.new.last_weeks_weekdays_as!("Monday", "Wednesday").to('2013-07-05') #fri
  end

end