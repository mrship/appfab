# encoding: UTF-8
class Karma::IdeaObserver < ActiveRecord::Observer
  observe :idea

  def after_create(record)
    record.author.change_karma! by:configatron.app_fab.karma.idea.created
  ensure
    return true
  end

  def after_destroy(record)
    record.author.change_karma! by:-configatron.app_fab.karma.idea.created
  ensure
    return true
  end

  def after_save(record)
    return unless record.state_changed?
    return unless [:vetted, :picked, :live].include? record.state_name
    record.author.change_karma! by:configatron.app_fab.karma.idea.send(record.state_name)
  ensure
    return true
  end
end
