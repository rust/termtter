OptionParser.new { |opt|
  opt.program_name = 'Termtter'

  opt.on('-f', '--config-file file', 'Set path to configfile') do |val|
    config.system.__assign__(:conf_file, val)
  end

  opt.on('-t', '--termtter-directory directory', 'Set termtter directory') do |val|
    config.system.__assign__(:conf_dir, val)
  end

  opt.on('-d', '--devel', 'Start in developer mode') do |flg|
    config.system.__assign__(:devel, true) if flg
  end

  config.system.cmd_mode = false
  opt.on('-c', '--command-mode', 'Run as command mode') do |flg|
    config.system.cmd_mode = flg
  end

  config.system.run_commands = []
  opt.on('-r', '--run-command command', 'Run command') do |cmd|
    config.system.run_commands << cmd
  end

  config.system.load_plugins = []
  opt.on('-p', '--plugin plugin', 'Load plugin') do |plugin|
    config.system.load_plugins << plugin
  end

  config.system.eval_scripts = []
  opt.on('-e', '--eval-script script', 'Eval script') do |script|
    config.system.eval_scripts << script
  end

  opt.version = Termtter::VERSION
  opt.parse!(ARGV)
}
