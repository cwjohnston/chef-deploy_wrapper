use_inline_resources

def whyrun_supported?
   true
end

action :create do
  directory new_resource.ssh_key_dir do
    owner new_resource.owner
    group new_resource.group
    mode 0740
    recursive true
  end

  directory new_resource.ssh_wrapper_dir do
    owner new_resource.owner
    group new_resource.group
    mode 0750
    recursive true
  end

  file key_path do
    owner new_resource.owner
    group new_resource.group
    mode 0600
    content new_resource.ssh_key_data if new_resource.ssh_key_data
  end

  template wrapper_path do
    cookbook 'deploy_wrapper'
    source "ssh_wrapper.sh.erb"
    owner new_resource.owner
    group new_resource.group
    mode 0755
    variables(
      :ssh_key_path => key_path,
      :app_name => new_resource.application,
      :sloppy => new_resource.sloppy
    )
  end
end

action :delete do
  [key_path, wrapper_path].each do |file_path|
    file file_path do
      action :delete
    end
  end
end

def key_path
  if new_resource.ssh_key_data
    return ::File.join(new_resource.ssh_key_dir, "#{new_resource.application}_deploy_key")
  elsif new_resource.ssh_key_file
    return new_resource.ssh_key_file
  else
    Chef::Log.fatal "ssh_key_data or ssh_key_file aren't set"
  end
end

def wrapper_path
  if new_resource.ssh_wrapper_path 
    return new_resource.ssh_wrapper_path 
  elsif new_resource.ssh_wrapper_dir
    return ::File.join(new_resource.ssh_wrapper_dir, "#{new_resource.application}_deploy_wrapper.sh")
  else
    Chef::Log.fatal "wrapper_path or ssh_wrapper_dir aren't set"
  end
end
