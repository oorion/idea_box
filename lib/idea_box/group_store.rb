require 'yaml/store'

class GroupStore
  def self.database
    return @database if @database

    @database = YAML::Store.new "db/group_store"
    @database.transaction do
      @database['groups'] ||= ['default']
    end
    @database
  end

  def self.create(group)
    database.transaction do
      database['groups'] << group
    end
  end

  def self.groups
    database.transaction do
      database['groups']
    end
  end

  def self.delete(name)
    database.transaction do
      database['groups'].delete_at(database['groups'].index(name))
    end
  end
end
