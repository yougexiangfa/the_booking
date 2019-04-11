module FullCalendarHelper
  extend self

  def repeat_settings(repeat_type: 'once')
    settings = {
      dayCount: 7,
      columnHeaderFormat: {
        year: 'numeric',
        month: 'numeric',
        day: 'numeric',
        weekday: 'short'
      }
    }
    case repeat_type
    when 'monthly'
      settings.merge!(
        defaultDate: default_date(repeat_type: repeat_type).to_s,
        dayCount: 31,
        columnHeaderFormat: { day: 'numeric' }
      )
    when 'weekly'
      settings.merge!(
        defaultDate: default_date(repeat_type: repeat_type).to_s,
        dayCount: 7,
        columnHeaderFormat: { weekday: 'short' }
      )
    end
    settings
  end

  def default_date(repeat_type: 'once')
    case repeat_type
    when 'once'
      Date.today.beginning_of_week
    when 'weekly'
      Date.today.beginning_of_year.beginning_of_week
    when 'monthly'
      Date.today.beginning_of_year
    end
  end


end
