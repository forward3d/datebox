module Datebox
  class Period
    attr_reader :from, :to
    
    def initialize(from, to)
      @from = from.is_a?(Date) ? from : Date.parse(from)
      @to = to.is_a?(Date) ? to : Date.parse(to)
      raise "FROM date should not be later than TO date" if @to < @from
    end
    
    def dates
      (@from..@to).to_a
    end
    
    def ==(other)
      @from == other.from && @to == other.to
    end
    
    def split_dates(period, options = {})
      self.class.split_dates(from, to, period, options)
    end

    class << self
      def split_dates(start_date, end_date, period, options = {})
        return (start_date..end_date).to_a if period == "day"
        return split_monthly_dates(start_date, end_date) if period == "month"
        if period =~ /week/
          return split_weekly_dates(start_date, end_date, options.merge({last_weekday: "Saturday"})) if period == "week_ss"
          return split_weekly_dates(start_date, end_date, options)
        end
      end

      def split_weekly_dates(start_date, end_date, options = {})
        last_weekday = options[:last_weekday] || "Sunday"
        end_dates = []
        end_of_week = (end_date.downto end_date - 6).to_a.find { |d| d.strftime("%A") == last_weekday }
        while end_of_week - 6 >= start_date
          end_dates << end_of_week
          end_of_week -= 7
        end
        end_dates.sort
      end

      def split_monthly_dates(start_date, end_date)
        end_dates = []
        beginning_of_month = ::Date.parse("#{end_date.year}-#{end_date.month}-01").next_month
        end_of_month = (beginning_of_month - 1 == end_date) ? end_date : beginning_of_month.prev_month - 1
        while beginning_of_month.prev_month >= start_date
          end_dates << end_of_month
          beginning_of_month = ::Date.parse("#{end_of_month.year}-#{end_of_month.month}-01")
          end_of_month =  beginning_of_month - 1
        end
        end_dates.sort
      end
    end

  end
end