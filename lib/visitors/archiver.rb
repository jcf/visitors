class Visitors::Archiver
  Day   = Visitors::Day
  Month = Visitors::Month
  Year  = Visitors::Year

  def archive_yesterday
    Day.all.map do |day|
      execute()
    end
  end

  def save_today
    Day.destroy

    Visitors.store.slice.map do |id, stats|
      Day.create(stats.merge(:resource_id => id))
    end
  end

  private

  def execute(*args)
    Day.repository.adapter.select(*args)
  end
end
