require 'rubyforge'

##
# RubyForge plugin for hoe.
#
# Adds a release dependency that cleans, packages, performs sanity
# checks, and releases to RubyForge.
#
# === Tasks Provided:
#
# release_to_rubyforge:: Release to rubyforge when release task is run.

module Hoe::RubyForge
  def define_rubyforge_tasks # :nodoc:

    # no doco, invisible hook
    task :release_to => :release_to_rubyforge

    desc 'Release to rubyforge.'
    task :release_to_rubyforge => [:clean, :package, :release_sanity] do
      rf = RubyForge.new.configure
      puts "Logging in"
      rf.login

      c = rf.userconfig
      c["release_notes"]   = description if description
      c["release_changes"] = changes     if changes
      c["preformatted"]    = true

      pkg   = "pkg/#{name}-#{version}"
      files = [(@need_tar ? "#{pkg}.tgz" : nil),
               (@need_zip ? "#{pkg}.zip" : nil),
               Dir["#{pkg}*.gem"]].flatten.compact

      puts "Releasing #{name} v. #{version}"
      rf.add_release rubyforge_name, name, version, *files
    end
  end
end
