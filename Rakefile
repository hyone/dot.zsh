require 'rake'

desc "prepare to use zsh configuration"
task :install do
  zsh_dir     = File.expand_path '~/.zsh.d'
  auto_fu_dir = File.join(zsh_dir, 'modules', 'auto-fu.zsh', 'auto-fu.zsh')

  system %Q{ zsh -c "source #{auto_fu_dir}; auto-fu-zcompile #{auto_fu_dir} #{zsh_dir}" }
end
