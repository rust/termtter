# -*- coding: utf-8 -*-

module Termtter
  class Status
    def is_member?(group = nil)
      if group
        config.plugins.group.groups[group].include? self.user_screen_name
      else
        config.plugins.group.groups.values.flatten.include? self.user_screen_name
      end
    end
  end
end

module Termtter::Client
  config.plugins.group.
    set_default(:groups, {})

  def self.find_group_candidates(a, b)
    config.plugins.group.groups.keys.map {|k| k.to_s}.
      grep(/^#{Regexp.quote a}/).
      map {|u| b % u }
  end

  def self.get_group_of(screen_name)
    config.plugins.group.groups.select{ |k, v| v.include? screen_name}.map{|a| a.first}
  end    

  register_command(
   :name => :group,
   :aliases => [:g],
   :exec_proc => lambda {|arg|
     unless arg.empty?
       group_name = arg.to_sym
       if group_name == :all
         targets = config.plugins.group.groups.values.flatten.uniq
       else
         targets = config.plugins.group.groups[group_name]
       end
       statuses = targets ? targets.map { |target|
          public_storage[:tweet][target]
        }.flatten.uniq.compact.sort_by{ |s| s[:id]} : []
       output(statuses, :search)
     else
       config.plugins.group.groups.each_pair do |key, value|
         puts "#{key}: #{value.join(',')}"
       end
     end
   },
   :completion_proc => lambda {|cmd, arg|
     find_group_candidates arg, "#{cmd} %s"
                   },
   :help => ['group,g GROUPNAME', 'Filter by group members']
   )
  
end

# group.rb
#   plugin 'group'
#   config.plugins.group.groups = {
#     :rits => %w(hakobe isano hitode909)
#   }
# NOTE: group.rb needs plugin/log

