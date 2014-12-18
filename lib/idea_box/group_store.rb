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
end
