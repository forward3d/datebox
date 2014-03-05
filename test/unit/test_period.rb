require File.join(File.dirname(__FILE__), '..', 'test_helper')

class TestPeriod < Test::Unit::TestCase
  
  def test_splits_periods_correctly
    #day
    assert_equal [Date.today - 1], Datebox::Period.split_dates(Date.today - 1, Date.today - 1, "day")
    assert_equal [Date.today - 3, Date.today - 2, Date.today - 1], Datebox::Period.split_dates(Date.today - 3, Date.today - 1, "day")

    #week
    assert_equal [], Datebox::Period.split_dates(Date.parse("2013-06-15"), Date.parse("2013-06-22"), "week") #sat to sat
    assert_equal [Date.parse("2013-06-23")], Datebox::Period.split_dates(Date.parse("2013-06-14"), Date.parse("2013-06-27"), "week") #fri to thu
    assert_equal [Date.parse("2013-06-23")], Datebox::Period.split_dates(Date.parse("2013-06-17"), Date.parse("2013-06-23"), "week") #mon to sun
    assert_equal [Date.parse("2014-02-15")], Datebox::Period.split_dates(Date.parse("2014-02-09"), Date.parse("2014-02-15"), "week", {:last_weekday => "Saturday"}) #sun to sat
    assert_equal [Date.parse("2013-06-16"), Date.parse("2013-06-23")], Datebox::Period.split_dates(Date.parse("2013-06-10"), Date.parse("2013-06-27"), "week") #mon to thu

    #month
    assert_equal [], Datebox::Period.split_dates(Date.parse("2013-01-02"), Date.parse("2013-01-31"), "month")
    assert_equal [Date.parse("2013-01-31")], Datebox::Period.split_dates(Date.parse("2013-01-01"), Date.parse("2013-01-31"), "month")
    assert_equal [Date.parse("2013-01-31")], Datebox::Period.split_dates(Date.parse("2012-12-02"), Date.parse("2013-02-02"), "month")
    assert_equal [Date.parse("2013-01-31"), Date.parse("2013-02-28")], Datebox::Period.split_dates(Date.parse("2012-12-10"), Date.parse("2013-03-03"), "month")

    #instance method test
    assert_equal [Date.parse("2013-06-16"), Date.parse("2013-06-23")], Datebox::Period.new("2013-06-10", "2013-06-27").split_dates("week") #mon to thu
  end

end