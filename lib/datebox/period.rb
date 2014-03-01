module Datebox
  class Period
    attr_reader :from, :to
    
    PREDEFINED = [:day, :n_days, :week, :month, :year]
    
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
      raise "Expected one of: #{Period::PREDEFINED}" unless Period::PREDEFINED.include?(period.to_sym)
      self.class.split_dates(from, to, period.to_sym, options)
    end

    class << self
      def split_dates(start_date, end_date, period, options = {})
        return (start_date..end_date).to_a                        if period == :day
        return split_days_dates(start_date, end_date, options)    if period == :n_days
        return split_weekly_dates(start_date, end_date, options)  if period == :week
        return split_monthly_dates(start_date, end_date)          if period == :month
        return split_yearly_dates(start_date, end_date)           if period == :year
      end

      def split_days_dates(start_date, end_date, options = {})
        days = options[:days] || options["days"]
        raise "days must be specified" if days.nil?
        
        end_dates = []
        (start_date..end_date).to_a.reverse.each_slice(days) do |range|
          end_dates << range.first
        end
        end_dates.sort
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

      def split_yearly_dates(start_date, end_date)
        end_dates = []
        beginning_of_year = ::Date.parse("#{end_date.year}-01-01").next_year
        end_of_year = (beginning_of_year - 1 == end_date) ? end_date : beginning_of_year.prev_year - 1
        while beginning_of_year.prev_year >= start_date
          end_dates << end_of_year
          beginning_of_year = ::Date.parse("#{end_of_year.year}-01-01")
          end_of_year =  beginning_of_year - 1
        end
        end_dates.sort
      end
    end

  end
end