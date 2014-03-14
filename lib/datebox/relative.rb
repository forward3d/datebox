module Datebox
  class Relative

    @period_proc = nil
    
    def initialize(proc)
      @period_proc = proc
    end

    def to(relative_to)
      relative_to = (relative_to.is_a?(Date) ? relative_to : Date.parse(relative_to))
      @period_proc.call relative_to
    end

    class << self

      def last(period, options = {})
        raise "Expected one of: #{Period::PREDEFINED}" unless Period::PREDEFINED.include?(period.to_sym)
        case period.to_sym
          when :day then day_before
          when :n_days then last_n_days(options)
          when :week then last_week(options)
          when :month then last_month
          when :year then last_year
        end
      end

      def same_day
        new Proc.new {|relative_to| Period.new(relative_to, relative_to) }
      end

      def day_before
        new Proc.new {|relative_to| Period.new(relative_to - 1, relative_to - 1) }
      end
      
      def last_n_days(options = {})
        days = (options[:days] || options['days']).to_i
        inclusive = (options[:exclusive] || options['exclusive']) ? false : true # inclusive by default
        days = 1 if days.nil? || days <= 0 # days should always > 0 since it only return last x days
        proc = inclusive ?
          Proc.new {|relative_to| Period.new(relative_to - days + 1, relative_to) } :
          Proc.new {|relative_to| Period.new(relative_to - days, relative_to - 1) }
        new proc
      end

      def last_week(options = {})
        last_weekday = options[:last_weekday] || options['last_weekday'] || 'Sunday'
        new Proc.new { |relative_to|
          end_date = (relative_to.downto relative_to - 6).to_a.find { |d| d.strftime("%A") == last_weekday }
          Period.new(end_date - 6, end_date)
        }
      end

      def last_weekdays_between(start_day, end_day)
        new Proc.new { |relative_to|
          end_date = (relative_to.downto relative_to - 6).to_a.find { |d| d.strftime("%A") == end_day }
          start_date = (end_date - 7 .. end_date).to_a.find { |d| d.strftime("%A") == start_day }
          Period.new(start_date, end_date)
        }
      end

      def last_weeks_weekdays_as!(*days) #this one returns array!
        new Proc.new { |relative_to|
          days.map do |p|
            (relative_to.downto relative_to - 6).to_a.find { |d| d.strftime("%A") == p }
          end
        }
      end

      def last_month
        new Proc.new { |relative_to| 
          previous_month_start = Date.parse("#{relative_to.prev_month.strftime('%Y-%m')}-01")
          previous_month_end = previous_month_start.next_month - 1
          Period.new(previous_month_start, previous_month_end)
        }
      end

      def month_to_date
        new Proc.new { |relative_to|
          month_start = Date.parse("#{relative_to.strftime('%Y-%m')}-01")
          Period.new(month_start, relative_to)
        }
      end

      def last_year
        new Proc.new { |relative_to|
          previous_year_start = Date.parse("#{relative_to.prev_year.year}-01-01")
          previous_year_end = previous_year_start.next_year - 1
          Period.new(previous_year_start, previous_year_end)
        }
      end

      def year_to_date
        new Proc.new { |relative_to|
          year_start = Date.parse("#{relative_to.year}-01-01")
          Period.new(year_start, relative_to)
        }
      end

    end
  end
  
end